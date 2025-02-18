class EmailConfirmationRequest {
  final String pin;
  final String userId;

  EmailConfirmationRequest({required this.userId, required this.pin});

  Map<String, String> toJson() {
    return {
      'pin': pin,
      'userId': userId,
    };
  }
}
