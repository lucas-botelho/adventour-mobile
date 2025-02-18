//Copied from flutter docs

class UserRegistrationRequest {
  final String name;
  final String email;
  final String confirmPassword;
  final String password;

  UserRegistrationRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
