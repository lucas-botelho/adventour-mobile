class UserResponse {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String oauthId;
  final bool verified;
  final String username;
  final int registrationStep;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.oauthId,
    required this.verified,
    required this.username,
    required this.registrationStep,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      oauthId: json['oauthId'] ?? '',
      verified: json['verified'] ?? false,
      username: json['username'] ?? '',
      registrationStep: json['registrationStep'] ?? 0,
    );
  }
}
