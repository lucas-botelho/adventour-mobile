class BaseApiResponse<T> {
  final bool success;
  final String message;
  final Map<String, List<String>>? errors;
  final T? data;
  final int? statusCode;
  BaseApiResponse({
    required this.success,
    required this.message,
    this.errors,
    this.data,
    this.statusCode,
  });

  factory BaseApiResponse.fromJson(int? statusCode, Map<String, dynamic> json,
      T Function(Map<String, dynamic>)? fromJsonT) {
    return BaseApiResponse<T>(
      success: json.containsKey('success') ? json['success'] : false,
      message: json.containsKey('message')
          ? json['message'] ?? ''
          : json['title'] ?? 'An error occurred.',
      errors: json.containsKey('errors') ? _parseErrors(json['errors']) : null,
      data:
          json.containsKey('data') && json['data'] != null && fromJsonT != null
              ? fromJsonT(json['data'])
              : null,
      statusCode: statusCode,
    );
  }

  static Map<String, List<String>> _parseErrors(dynamic errorsJson) {
    if (errorsJson is Map<String, dynamic>) {
      return errorsJson.map((key, value) {
        return MapEntry(key, List<String>.from(value));
      });
    }
    return {};
  }
}
