import 'dart:convert';
import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/settings/constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = AppSettings.apiBaseUrl;

  ApiService();

  Future<BaseApiResponse<T>> post<T>({
    String? token,
    required String endpoint,
    required Map<String, String> headers,
    required Object body,
    required T Function(Map<String, dynamic>) fromJsonT,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              token != null && token.isNotEmpty ? 'Bearer $token' : '',
          ...headers,
        },
        body: jsonEncode(body),
      );

      return processResponse<T>(response, fromJsonT);
    } catch (e) {
      throw Exception('Failed to process response');
    }
  }

  Future<BaseApiResponse<T>> get<T>(
    String endpoint, {
    required Map<String, String> headers,
    required T Function(Map<String, dynamic>) fromJsonT,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      return processResponse<T>(response, fromJsonT);
    } catch (e) {
      throw Exception('Failed to process response');
    }
  }

  Future<BaseApiResponse<T>> processResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJsonT,
  ) async {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return BaseApiResponse<T>.fromJson(jsonResponse, fromJsonT);
    }

    if (response.statusCode >= 400 && response.statusCode < 500) {
      return BaseApiResponse<T>.fromJson(jsonResponse, null);
    }

    return BaseApiResponse<T>(
      success: false,
      message: 'An error occurred',
      errors: {},
      data: null,
    );
  }
}
