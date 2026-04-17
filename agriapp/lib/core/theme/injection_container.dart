import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../services/veiculo_service.dart';
import '../../features/veiculo/presentation/blocs/veiculo_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core - Network
  sl.registerLazySingleton(() => DioClient());

  // Services (Data Sources/Repositories)
  // Aqui injetamos o DioClient registrado acima no VeiculoService
  sl.registerLazySingleton(() => VeiculoService(sl<DioClient>()));

  // Blocs - Sempre factory para garantir estado limpo ao reentrar em telas
  sl.registerFactory(() => VeiculoBloc(sl<VeiculoService>()));
}