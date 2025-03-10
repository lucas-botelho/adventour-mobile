class UserResponse {
  final String name;
  final String email;
  final String photoUrl;

  UserResponse(
      {required this.name, required this.email, required this.photoUrl});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
    );
  }
}
