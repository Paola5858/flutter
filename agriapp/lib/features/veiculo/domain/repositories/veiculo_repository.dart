import '../../domain/entities/veiculo_entity.dart';

abstract class VeiculoRepository {
  Future<List<VeiculoEntity>> getVeiculos();
  Future<void> createVeiculo(VeiculoEntity veiculo);
  Future<void> updateVeiculo(int id, VeiculoEntity veiculo);
  Future<void> deleteVeiculo(int id);
}
