import '../../domain/repositories/veiculo_repository.dart';
import '../../domain/entities/veiculo_entity.dart';
import '../datasources/remote/veiculo_remote_datasource.dart';
import '../models/veiculo_model.dart';

class VeiculoRepositoryImpl implements VeiculoRepository {
  final VeiculoRemoteDataSource remoteDataSource;

  VeiculoRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VeiculoEntity>> getVeiculos() async {
    final models = await remoteDataSource.getVeiculos();
    return models.map((model) => _modelToEntity(model)).toList();
  }

  @override
  Future<void> createVeiculo(VeiculoEntity veiculo) async {
    final model = _entityToModel(veiculo);
    await remoteDataSource.createVeiculo(model);
  }

  @override
  Future<void> updateVeiculo(int id, VeiculoEntity veiculo) async {
    final model = _entityToModel(veiculo);
    await remoteDataSource.updateVeiculo(id, model);
  }

  @override
  Future<void> deleteVeiculo(int id) async {
    await remoteDataSource.deleteVeiculo(id);
  }

  VeiculoEntity _modelToEntity(VeiculoModel model) {
    return VeiculoEntity(
      id: model.id,
      descricao: model.descricao,
      marcaId: model.marcaId,
      modeloId: model.modeloId,
      ano: model.ano,
      horimetro: model.horimetro,
    );
  }

  VeiculoModel _entityToModel(VeiculoEntity entity) {
    return VeiculoModel(
      id: entity.id,
      descricao: entity.descricao,
      marcaId: entity.marcaId,
      modeloId: entity.modeloId,
      ano: entity.ano,
      horimetro: entity.horimetro,
    );
  }
}
