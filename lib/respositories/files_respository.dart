import 'dart:io';
import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/responses/files/file_upload.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';

class FileRepository {
  final ApiService apiService;
  final FirebaseAuthService firebaseAuthService;

  FileRepository({required this.firebaseAuthService, required this.apiService});


  Future<BaseApiResponse<FileUploadResponse>> uploadSingleFile<T>({
    required File file,
  }) async {
    return apiService.uploadFile(
      endpoint: Files.upload,
      file: file,
      token: await firebaseAuthService.getIdToken(),
      fromJsonT: (json) => FileUploadResponse.fromJson(json),
    );
  }

  Future<BaseApiResponse<FilesUploadResponse>> uploadMultipleFiles<T>({
    required List<File> files,
  }) async {
    return apiService.uploadFiles<FilesUploadResponse>(
      endpoint: Files.uploadMultiple,
      files: files,
      token: await firebaseAuthService.getIdToken(),
      fromJsonT: (json) => FilesUploadResponse.fromJson(json),
    );
  }
}

class FilesUploadResponse {
  final List<FileUploadResponse> files;

  FilesUploadResponse({required this.files});

  factory FilesUploadResponse.fromJson(Map<String, dynamic> json) {
    return FilesUploadResponse(
      files: (json['files'] as List)
          .map((file) => FileUploadResponse.fromJson(file))
          .toList(),
    );
  }
}
