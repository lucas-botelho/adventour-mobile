import 'dart:io';
import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/requests/auth/confirm_email.dart';
import 'package:adventour/models/requests/auth/patch_public_data.dart';
import 'package:adventour/models/requests/auth/user_registration.dart';
import 'package:adventour/models/responses/auth/patch_public_data.dart';
import 'package:adventour/models/responses/auth/token.dart';
import 'package:adventour/models/responses/auth/user.dart';
import 'package:adventour/models/responses/files/file_upload.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final firebaseAuthService = FirebaseAuthService();
  final apiService = ApiService();

  Future<UserResponse?> getUserData() async {
    var firebaseUser = firebaseAuthService.getUser();

    if (firebaseUser != null) {
      var response = await apiService.get(
        Authentication.me,
        await firebaseAuthService.getIdToken(),
        headers: {},
        fromJsonT: (json) => UserResponse.fromJson(json),
      );

      return response.data;
    }

    return null;
  }

  Future<BaseApiResponse<TokenResponse>?> createUser(
      User? user, String username) async {
    if (user == null) {
      return null;
    }

    var token = await firebaseAuthService.getIdToken();

    try {
      final requestModel = UserRegistrationRequest(
        name: user.displayName ?? username,
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        oAuthId: user.uid,
      );

      final result = await apiService.post(
        token: token,
        endpoint: Authentication.user,
        headers: <String, String>{},
        body: requestModel.toJson(),
        fromJsonT: (json) => TokenResponse.fromJson(json),
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponse<TokenResponse>?> confirmEmail(
      String userId, List<String> code, String token) async {
    var token = await firebaseAuthService.getIdToken();

    try {
      final requestModel = EmailConfirmationRequest(
        userId: userId,
        pin: code[0] + code[1] + code[2] + code[3],
      );

      final result = await apiService.post(
        token: token,
        endpoint: Authentication.confirmEmail,
        headers: <String, String>{},
        body: requestModel.toJson(),
        fromJsonT: (json) => TokenResponse.fromJson(json),
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponse<PatchUserPublicDataResponse>?> updateUserPublicData(
      String userId, String name, String photoUrl) async {
    var token = await firebaseAuthService.getIdToken();

    try {
      final requestModel = PatchUserPublicDataRequest(
        userName: name,
        imagePublicUrl: photoUrl,
        userId: userId,
      );

      final result = await apiService.patch(
        endpoint: '${Authentication.user}/$userId',
        headers: <String, String>{},
        body: requestModel.toJson(),
        fromJsonT: (json) => PatchUserPublicDataResponse.fromJson(json),
        token: token,
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponse<FileUploadResponse>?> uploadProfilePicture(
      File profileImage) async {
    final response = await apiService.uploadFile(
      endpoint: Files.upload,
      file: profileImage,
      token: await firebaseAuthService.getIdToken(),
      fromJsonT: (json) => FileUploadResponse.fromJson(json),
    );

    return response;
  }
}
