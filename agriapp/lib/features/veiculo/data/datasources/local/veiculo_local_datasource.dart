import 'package:agriapp/core/local/hive_service.dart';
import 'package:agriapp/features/veiculo/data/models/veiculo_model.dart';

abstract class VeiculoLocalDataSource {
  Future<List<VeiculoModel>> getCachedVeiculos();
  Future<void> cacheVeiculos(List<VeiculoModel> veiculos);
}

class VeiculoLocalDataSourceImpl implements VeiculoLocalDataSource {
  final HiveService hiveService;

  VeiculoLocalDataSourceImpl(this.hiveService);

  @override
  Future<List<VeiculoModel>> getCachedVeiculos() async {
    final cached = hiveService.get('veiculos');
    if (cached != null && cached is List) {
      return cached
          .map((json) => VeiculoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheVeiculos(List<VeiculoModel> veiculos) async {
    final jsonList = veiculos.map((model) => model.toJson()).toList();
    await hiveService.put('veiculos', jsonList);
  }
}
