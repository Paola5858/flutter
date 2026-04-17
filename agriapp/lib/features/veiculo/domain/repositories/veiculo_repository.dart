import '../../domain/entities/veiculo_entity.dart';

abstract class VeiculoRepository {
  Future<List<VeiculoEntity>> getVeiculos();
  Future<void> createVeiculo(VeiculoEntity veiculo);
  Future<void> updateVeiculo(String id, VeiculoEntity veiculo);
  Future<void> deleteVeiculo(String id);
}
