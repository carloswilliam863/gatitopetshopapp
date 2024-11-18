import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/url.dart';


class ApiService {
  final String fullUrl = urlBase;

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$fullUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$fullUrl/$endpoint'),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> postWithAuth(String endpoint, String token, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$fullUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return response;
  }
}
