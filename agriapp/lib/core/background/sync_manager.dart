import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workmanager/workmanager.dart';

import '../local/hive_service.dart';
import '../network/dio_client.dart';
import '../network/sync_interceptor.dart';

const _offlineSyncTask = 'agriappOfflineSync';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final hiveService = HiveService();
    await hiveService.init();

    final dioClient = DioClient(
      secureStorage: const FlutterSecureStorage(),
      hiveService: hiveService,
    );

    final syncService = OfflineSyncService(
      dioClient: dioClient,
      hiveService: hiveService,
    );

    await syncService.syncPendingRequests();
    return Future.value(true);
  });
}

class SyncManager {
  static Future<void> initialize() async {
    if (kIsWeb) return;

    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    await Workmanager().registerPeriodicTask(
      _offlineSyncTask,
      _offlineSyncTask,
      frequency: const Duration(hours: 1),
      initialDelay: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}
