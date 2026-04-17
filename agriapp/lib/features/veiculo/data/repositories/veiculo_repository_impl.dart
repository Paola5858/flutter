import 'package:agriapp/features/veiculo/domain/repositories/veiculo_repository.dart';
import 'package:agriapp/features/veiculo/domain/entities/veiculo_entity.dart';
import 'package:agriapp/features/veiculo/data/datasources/remote/veiculo_remote_datasource.dart';
import 'package:agriapp/features/veiculo/data/datasources/local/veiculo_local_datasource.dart';
import 'package:agriapp/features/veiculo/data/models/veiculo_model.dart';

class VeiculoRepositoryImpl implements VeiculoRepository {
  final VeiculoRemoteDataSource remoteDataSource;
  final VeiculoLocalDataSource localDataSource;

  VeiculoRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<VeiculoEntity>> getVeiculos() async {
    try {
      final models = await remoteDataSource.getVeiculos();
      // Cache the data locally
      await localDataSource.cacheVeiculos(models);
      return models.map(_modelToEntity).toList();
    } catch (e) {
      // Fallback to cached local data
      final cachedModels = await localDataSource.getCachedVeiculos();
      return cachedModels.map(_modelToEntity).toList();
    }
  }

  @override
  Future<void> createVeiculo(VeiculoEntity veiculo) async {
    final model = _entityToModel(veiculo);
    await remoteDataSource.createVeiculo(model);
  }

  @override
  Future<void> updateVeiculo(String id, VeiculoEntity veiculo) async {
    final model = _entityToModel(veiculo);
    await remoteDataSource.updateVeiculo(id, model);
  }

  @override
  Future<void> deleteVeiculo(String id) async {
    await remoteDataSource.deleteVeiculo(id);
  }

  VeiculoEntity _modelToEntity(VeiculoModel model) {
    return VeiculoEntity(id: model.id, placa: model.placa, marca: model.marca);
  }

  VeiculoModel _entityToModel(VeiculoEntity entity) {
    return VeiculoModel(
      id: entity.id,
      placa: entity.placa,
      marca: entity.marca,
    );
  }
}
