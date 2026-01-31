import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  // GET request
  Future<Map<String, dynamic>> get(String url, {String? token}) async {
    final response = await client.get(
      Uri.parse(url),
      headers: _getHeaders(token),
    );
    return _handleResponse(response);
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await client.post(
      Uri.parse(url),
      headers: _getHeaders(token),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  // Headers
  Map<String, String> _getHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Response handler
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(body['message'] ?? 'Something went wrong');
    }
  }
}