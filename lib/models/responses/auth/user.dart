class UserResponse {
  final String name;
  final String email;
  final String photoUrl;
  final String oauthId;
  final bool verified;
  final String username;

  UserResponse(
      {required this.name,
      required this.email,
      required this.photoUrl,
      required this.oauthId,
      required this.verified,
      required this.username});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      oauthId: json['oauthid'] ?? '',
      verified: json['verified'] ?? false,
      username: json['username'] ?? '',
    );
  }
}
