class BaseApiResponse<T> {
  final bool success;
  final String message;
  final List<String> errors;
  final T data;

  BaseApiResponse({
    required this.success,
    required this.message,
    this.errors = const [],
    required this.data,
  });

  factory BaseApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return BaseApiResponse<T>(
      success: json['success'],
      message: json['message'],
      errors: List<String>.from(json['errors'] ?? []),
      data: fromJsonT(json['data']), // Convert `data` using fromJsonT function
    );
  }
}
