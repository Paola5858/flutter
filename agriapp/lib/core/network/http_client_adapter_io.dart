import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

HttpClientAdapter? createPinnedHttpClientAdapter(String? expectedSha256) {
  if (expectedSha256 == null || expectedSha256.isEmpty) {
    return null;
  }

  return IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => false;
      return client;
    },
    validateCertificate: (cert, host, port) {
      if (cert == null) {
        return false;
      }
      final fingerprint = base64Encode(sha256.convert(cert.der).bytes);
      return fingerprint == expectedSha256;
    },
  );
}
