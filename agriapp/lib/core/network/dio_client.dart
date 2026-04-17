import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    _dio.options
      ..baseUrl = 'https://api.agrocontrol.com/v1/'
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // TODO(paola): inject secure_storage getter de token (eta: amanhã)
          const token = 'mock_jwt_token_for_now';
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // TODO: Implementar RetryInterceptor para conexões instáveis em campo
          if (e.response?.statusCode == 401) {
            // Pipeline de Refresh Token - Crítico para UX empresarial
          }
          if (kDebugMode) {
            // Logger seguro: evita PII leak em logs de produção
            debugPrint('dio error: ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get instance => _dio;
}
