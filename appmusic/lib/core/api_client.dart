import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const baseUrl = 'https://x8ki-letl-twmt.n7.xano.io/api:93kA9_te';

  static String _extractErrorMessage(String resBody) {
    try {
      final decoded = jsonDecode(resBody);
      if (decoded is Map<String, dynamic>) {
        final message =
            decoded['message'] ?? decoded['error'] ?? decoded['detail'];
        if (message is String && message.trim().isNotEmpty) return message;
      }
    } catch (_) {
      // ignore parsing errors
    }
    return resBody;
  }

  static Future<dynamic> get(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'));
    if (res.statusCode != 200) {
      final msg = _extractErrorMessage(res.body);
      throw Exception(
          'erro ao buscar $path (statusCode=${res.statusCode}): $msg');
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
      final msg = _extractErrorMessage(res.body);
      throw Exception(
          'erro ao salvar em $path (statusCode=${res.statusCode}): $msg');
    }

    return res.body.isEmpty ? null : jsonDecode(res.body);
  }

  static Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final res = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      final msg = _extractErrorMessage(res.body);
      throw Exception(
          'erro ao atualizar em $path (statusCode=${res.statusCode}): $msg');
    }

    return res.body.isEmpty ? null : jsonDecode(res.body);
  }

  static Future<void> delete(String path) async {
    final res = await http.delete(Uri.parse('$baseUrl$path'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      final msg = _extractErrorMessage(res.body);
      throw Exception(
          'erro ao deletar em $path (statusCode=${res.statusCode}): $msg');
    }
  }
}
