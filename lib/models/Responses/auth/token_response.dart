class TokenResponse {
  final String token;
  final int expiresIn;

  TokenResponse({required this.token, required this.expiresIn});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'],
      expiresIn: json['expiresIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiresIn': expiresIn,
    };
  }
}
