import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const baseUrl = 'https://x8ki-letl-twmt.n7.xano.io/api:93kA9_te';

  static Future<dynamic> get(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'));
    if (res.statusCode != 200) {
      throw Exception('erro ao buscar $path: ${res.statusCode}');
    }
    return jsonDecode(res.body);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('erro ao salvar em $path: ${res.statusCode}');
    }
    return jsonDecode(res.body);
  }
}
