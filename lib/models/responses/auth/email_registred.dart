class EmailRegistredResponse {
  final bool isResgistered;

  EmailRegistredResponse({required this.isResgistered});

  factory EmailRegistredResponse.fromJson(Map<String, dynamic> json) {
    return EmailRegistredResponse(
      isResgistered:
          json.containsKey('isResgistered') ? json['isResgistered'] : false,
    );
  }
}
