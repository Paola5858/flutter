import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HiveService {
  static const String _boxName = 'agriapp_box';
  static const String _pendingRequestsKey = 'pending_requests';
  late Box _box;

  Future<void> init() async {
    final secureStorage = const FlutterSecureStorage();
    var encryptionKeyString = await secureStorage.read(key: 'hive_key');

    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      encryptionKeyString = base64UrlEncode(key);
      await secureStorage.write(key: 'hive_key', value: encryptionKeyString);
    }

    final encryptionKeyUint8List = base64Url.decode(encryptionKeyString);
    _box = await Hive.openBox(_boxName, encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
  }

  Future<void> put(String key, dynamic value) async {
    await _box.put(key, value);
  }

  dynamic get(String key) {
    return _box.get(key);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  Future<void> clear() async {
    await _box.clear();
  }

  Future<void> close() async {
    await _box.close();
  }

  Future<void> savePendingRequest(Map<String, dynamic> request) async {
    final current =
        _box.get(_pendingRequestsKey, defaultValue: <dynamic>[]) as List;
    final updated = List<dynamic>.from(current)..add(request);
    await _box.put(_pendingRequestsKey, updated);
  }

  List<Map<String, dynamic>> getPendingRequests() {
    final current =
        _box.get(_pendingRequestsKey, defaultValue: <dynamic>[]) as List;
    return current.cast<Map<String, dynamic>>();
  }

  Future<void> removePendingRequest(String id) async {
    final current =
        _box.get(_pendingRequestsKey, defaultValue: <dynamic>[]) as List;
    final updated = current
        .where((item) => item is Map && item['id'] != id)
        .toList();
    await _box.put(_pendingRequestsKey, updated);
  }
}