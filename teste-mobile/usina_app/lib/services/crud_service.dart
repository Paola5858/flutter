import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'USINA_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:1880',
  );

  static const safras = '/api/safras';
  static const unidades = '/api/unidades';
  static const unidadesMedida = '/api/unidadesmedida';
  static const equipamentos = '/api/equipamentos';
  static const tiposInformacao = '/api/tipoinformacoes';
  static const medicoes = '/api/medicoes';
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

class CrudService {
  static final http.Client _sharedClient = http.Client();
  final String route;
  final http.Client _client;
  final Duration timeout;

  CrudService(this.route, {http.Client? client, this.timeout = const Duration(seconds: 12)}) : _client = client ?? _sharedClient;

  Uri _uri([int? id]) => Uri.parse('${ApiConfig.baseUrl}$route${id == null ? '' : '/$id'}');

  Future<List<Map<String, dynamic>>> listar() async {
    final response = await _request(() => _client.get(_uri()));
    final decoded = _decode(response);
    final raw = decoded is Map<String, dynamic> ? (decoded['data'] ?? decoded['items'] ?? decoded['result']) : decoded;
    if (raw is! List) throw const ApiException('a api retornou um formato de lista inválido.');
    return raw.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<void> criar(Map<String, dynamic> payload) async {
    final response = await _request(() => _client.post(_uri(), headers: _headers, body: jsonEncode(payload)));
    _ensureSuccess(response, expected: const {200, 201, 202, 204});
  }

  Future<void> editar(int id, Map<String, dynamic> payload) async {
    final response = await _request(() => _client.put(_uri(id), headers: _headers, body: jsonEncode(payload)));
    _ensureSuccess(response, expected: const {200, 201, 202, 204});
  }

  Future<void> excluir(int id) async {
    final response = await _request(() => _client.delete(_uri(id), headers: _headers));
    _ensureSuccess(response, expected: const {200, 202, 204});
  }

  Map<String, String> get _headers => const {'Content-Type': 'application/json', 'Accept': 'application/json'};

  Future<http.Response> _request(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(_serverMessage(response), statusCode: response.statusCode);
      }
      return response;
    } on ApiException {
      rethrow;
    } on FormatException {
      throw const ApiException('a resposta da api veio inválida.');
    } catch (_) {
      throw const ApiException('não foi possível conectar à api. verifique o servidor e a rede.');
    }
  }

  dynamic _decode(http.Response response) {
    if (response.bodyBytes.isEmpty) return null;
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  void _ensureSuccess(http.Response response, {required Set<int> expected}) {
    if (!expected.contains(response.statusCode)) {
      throw ApiException(_serverMessage(response), statusCode: response.statusCode);
    }
  }

  String _serverMessage(http.Response response) {
    try {
      final decoded = _decode(response);
      if (decoded is Map) {
        final message = decoded['message'] ?? decoded['error'] ?? decoded['mensagem'];
        if (message != null && message.toString().trim().isNotEmpty) return message.toString();
      }
    } catch (_) {}
    return 'a api recusou a operação (${response.statusCode}).';
  }
}
