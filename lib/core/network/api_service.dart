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

  // Multipart POST request (file upload)
  Future<Map<String, dynamic>> postMultipart(
    String url, {
    required String filePath,
    String fieldName = 'image',
    String? token,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
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
    try {
      print('📡 API Response Status: ${response.statusCode}');
      print('📡 API Response Body: ${response.body}');
      
      final body = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✓ API call successful');
        return body;
      } else {
        print('✗ API Error: ${body['message'] ?? 'Unknown error'}');
        throw Exception(body['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      print('❌ Response parsing error: $e');
      print('❌ Status code: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
      throw Exception('Invalid response format: ${e.toString()}');
    }
  }
}