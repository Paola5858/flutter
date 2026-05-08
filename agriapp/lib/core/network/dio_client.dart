import 'package:agriapp/core/local/hive_service.dart';
import 'package:agriapp/core/network/http_client_adapter.dart';
import 'package:agriapp/core/network/sync_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// leviatã rule: interceptors blindados. auth automática, retry, observability.
// a11y: garantindo que falhas de rede sejam reportadas semanticamente.
class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final HiveService _hiveService;

  static const _expectedPinnedCertificateSha256 = String.fromEnvironment(
    'API_CERT_SHA256',
    defaultValue: '',
  );

  DioClient({
    required FlutterSecureStorage secureStorage,
    required HiveService hiveService,
  }) : _secureStorage = secureStorage,
       _hiveService = hiveService,
       _dio = Dio(
         BaseOptions(
           baseUrl:
               'https://api.agricontrol.com.br/v1', // env vars no prod real
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 10),
         ),
       ) {
    final adapter = createPinnedHttpClientAdapter(
      _expectedPinnedCertificateSha256,
    );
    if (adapter != null) {
      _dio.httpClientAdapter = adapter;
    }
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(OfflineSyncInterceptor(_hiveService));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            try {
              final refreshed = await _refreshToken();
              if (refreshed) {
                return handler.resolve(await _dio.fetch(e.requestOptions));
              }
            } catch (_) {
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh': refreshToken},
      );
      if (response.statusCode == 200) {
        final newToken = response.data['access'];
        final newRefresh = response.data['refresh'];
        await _secureStorage.write(key: 'access_token', value: newToken);
        await _secureStorage.write(key: 'refresh_token', value: newRefresh);
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  Dio get instance => _dio;
}
