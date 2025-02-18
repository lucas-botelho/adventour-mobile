class TokenResponse {
  final String token;
  final int expiresIn;
  final String userId;

  TokenResponse(
      {required this.token, required this.expiresIn, required this.userId});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'] ?? '',
      expiresIn: json['expiresIn'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'token': token,
  //     'expiresIn': expiresIn,
  //   };
  // }
}
