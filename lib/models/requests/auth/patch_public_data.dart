class PatchUserPublicDataRequest {
  final String userId;
  final String userName;
  final String imagePublicUrl;

  PatchUserPublicDataRequest(
      {required this.userId,
      required this.userName,
      required this.imagePublicUrl});

  Map<String, String> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'publicUrl': imagePublicUrl,
    };
  }
}
