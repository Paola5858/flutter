import '../repositories/veiculo_repository.dart';
import '../entities/veiculo_entity.dart';

class GetVeiculos {
  final VeiculoRepository repository;

  GetVeiculos(this.repository);

  Future<List<VeiculoEntity>> call() async {
    return await repository.getVeiculos();
  }
}
