import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/network/dio_client.dart';
import '../../core/local/hive_service.dart';
import '../../features/veiculo/data/datasources/remote/veiculo_remote_datasource.dart';
import '../../features/veiculo/data/datasources/local/veiculo_local_datasource.dart';
import '../../features/marca/data/services/marca_service.dart';
import 'package:agriapp/features/veiculo/data/repositories/veiculo_repository_impl.dart';
import 'package:agriapp/features/veiculo/domain/repositories/veiculo_repository.dart';
import '../../features/veiculo/domain/usecases/get_veiculos.dart';
import '../../features/veiculo/presentation/blocs/veiculo_bloc.dart';
import '../../features/marca/presentation/blocs/marca_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => HiveService());
  sl.registerLazySingleton(
    () => DioClient(secureStorage: sl(), hiveService: sl()),
  );

  sl.registerLazySingleton<VeiculoRemoteDataSource>(
    () => VeiculoRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<VeiculoLocalDataSource>(
    () => VeiculoLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<VeiculoRepository>(
    () => VeiculoRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => GetVeiculos(sl()));

  sl.registerLazySingleton(() => MarcaService());
  sl.registerFactory(() => VeiculoBloc(sl()));
  sl.registerFactory(() => MarcaBloc(sl<MarcaService>()));
}
