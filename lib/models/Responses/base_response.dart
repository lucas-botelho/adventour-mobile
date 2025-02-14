class BaseResponse<T> {
  final bool success;
  final String message;
  final T data;

  BaseResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory constructor to parse JSON with a provided `fromJsonT` function
  factory BaseResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return BaseResponse(
      success: json['success'],
      message: json['message'],
      data: fromJsonT(json['data']), // Convert `data` dynamically
    );
  }

  // Convert to JSON, ensuring `data` is properly serialized
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': toJsonT(data), // Convert `data` dynamically
    };
  }
}
