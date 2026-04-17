import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';
import '../../core/local/hive_service.dart';
import '../../features/veiculo/data/datasources/remote/veiculo_remote_datasource.dart';
import '../../features/veiculo/data/datasources/local/veiculo_local_datasource.dart';
import '../../features/veiculo/data/repositories/veiculo_repository_impl.dart';
import '../../features/veiculo/domain/repositories/veiculo_repository.dart';
import '../../features/veiculo/domain/usecases/get_veiculos.dart';
import '../../features/veiculo/presentation/blocs/veiculo_bloc.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  // 1. core
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => HiveService());

  // 2. data sources
  sl.registerLazySingleton<VeiculoRemoteDataSource>(
    () => VeiculoRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<VeiculoLocalDataSource>(
    () => VeiculoLocalDataSourceImpl(sl()),
  );

  // 3. repository
  sl.registerLazySingleton<VeiculoRepository>(
    () => VeiculoRepositoryImpl(sl(), sl()),
  );

  // 4. usecases
  sl.registerLazySingleton(() => GetVeiculos(sl()));

  // 5. blocs
  sl.registerFactory(() => VeiculoBloc(sl()));
}
