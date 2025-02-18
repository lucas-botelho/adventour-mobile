class FileUploadResponse {
  final String publicUrl;

  FileUploadResponse({required this.publicUrl});

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      publicUrl: json['publicUrl'],
    );
  }
}
