//Copied from flutter docs

class UserRegistrationRequest {
  final String name;
  final String email;
  final String photoUrl;
  final String oAuthId;

  UserRegistrationRequest({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.oAuthId,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'oAuthId': oAuthId,
    };
  }
}
