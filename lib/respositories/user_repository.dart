import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/requests/auth/confirm_email.dart';
import 'package:adventour/models/requests/auth/patch_public_data.dart';
import 'package:adventour/models/requests/auth/user_registration.dart';
import 'package:adventour/models/responses/auth/patch_public_data.dart';
import 'package:adventour/models/responses/auth/token.dart';
import 'package:adventour/models/responses/auth/user.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuthService authService;
  final ApiService apiService;

  UserRepository({required this.authService, required this.apiService});

  Future<BaseApiResponse<UserResponse>?> getUserData() async {
    var firebaseUser = authService.getUser();

    if (firebaseUser != null) {
      var response = await apiService.get(
        Authentication.me,
        await authService.getIdToken(),
        headers: {},
        fromJsonT: (json) => UserResponse.fromJson(json),
      );

      return response;
    }

    return null;
  }

  Future<BaseApiResponse<TokenResponse>?> createUser(
      User? user, String username) async {
    if (user == null) {
      return null;
    }

    var token = await authService.getIdToken();

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

  Future<BaseApiResponse<TokenResponse>?> resendCode(
      User? user) async {
    if (user == null) {
      return null;
    }

    var token = await authService.getIdToken();

    try {

      final result = await apiService.post(
        token: token,
        endpoint: Authentication.resendCodeEmail,
        headers: <String, String>{},
        body: {
          "email": user.email,
        },
        fromJsonT: (json) => TokenResponse.fromJson(json),
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }



  Future<BaseApiResponse<TokenResponse>?> confirmEmail(
      String userId, List<String> code, String pinToken) async {
    try {
      final requestModel = EmailConfirmationRequest(
        userId: userId,
        pin: code[0] + code[1] + code[2] + code[3],
      );

      final result = await apiService.post(
        token: pinToken,
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
    var token = await authService.getIdToken();

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
}
