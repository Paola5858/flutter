import 'package:dio/dio.dart';
import 'http_client_adapter_stub.dart'
    if (dart.library.io) 'http_client_adapter_io.dart' as adapter;

HttpClientAdapter? createPinnedHttpClientAdapter(String? expectedSha256) =>
    adapter.createPinnedHttpClientAdapter(expectedSha256);
