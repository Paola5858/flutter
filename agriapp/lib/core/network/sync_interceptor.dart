import 'dart:io';

import 'package:dio/dio.dart';

import '../local/hive_service.dart';
import 'dio_client.dart';

class OfflineSyncInterceptor extends Interceptor {
  final HiveService hiveService;

  OfflineSyncInterceptor(this.hiveService);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldQueue(err)) {
      await _queueRequest(err.requestOptions);
    }
    return handler.next(err);
  }

  bool _shouldQueue(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown ||
        (error.error is SocketException);
  }

  Future<void> _queueRequest(RequestOptions options) async {
    final requestMap = {
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'method': options.method,
      'path': options.path,
      'baseUrl': options.baseUrl,
      'queryParameters': options.queryParameters,
      'headers': options.headers,
      'data': options.data,
      'contentType': options.contentType?.toString(),
    };
    await hiveService.savePendingRequest(requestMap);
  }
}

class OfflineSyncService {
  final DioClient dioClient;
  final HiveService hiveService;

  OfflineSyncService({required this.dioClient, required this.hiveService});

  Future<void> syncPendingRequests() async {
    final pending = hiveService.getPendingRequests();
    for (final item in List<Map<String, dynamic>>.from(pending)) {
      try {
        await dioClient.instance.request(
          item['path'] as String,
          options: Options(
            method: item['method'] as String,
            headers: item['headers'] != null
                ? Map<String, dynamic>.from(item['headers'] as Map)
                : <String, dynamic>{},
            contentType: item['contentType'] as String?,
          ),
          data: item['data'],
          queryParameters: item['queryParameters'] != null
              ? Map<String, dynamic>.from(item['queryParameters'] as Map)
              : null,
        );
        await hiveService.removePendingRequest(item['id'] as String);
      } catch (_) {
        // keep the request in the queue and retry later
      }
    }
  }
}
