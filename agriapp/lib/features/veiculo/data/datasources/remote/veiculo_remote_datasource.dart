import 'package:agriapp/core/network/dio_client.dart';
import '../../models/veiculo_model.dart';

abstract class VeiculoRemoteDataSource {
  Future<List<VeiculoModel>> getVeiculos();
  Future<void> createVeiculo(VeiculoModel veiculo);
  Future<void> updateVeiculo(String id, VeiculoModel veiculo);
  Future<void> deleteVeiculo(String id);
}

class VeiculoRemoteDataSourceImpl implements VeiculoRemoteDataSource {
  final DioClient dioClient;

  VeiculoRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<VeiculoModel>> getVeiculos() async {
    final response = await dioClient.instance.get('/veiculo');
    final List data = response.data;
    return data
        .map((json) => VeiculoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createVeiculo(VeiculoModel veiculo) async {
    await dioClient.instance.post('/veiculo', data: veiculo.toJson());
  }

  @override
  Future<void> updateVeiculo(String id, VeiculoModel veiculo) async {
    await dioClient.instance.patch('/veiculo/$id', data: veiculo.toJson());
  }

  @override
  Future<void> deleteVeiculo(String id) async {
    await dioClient.instance.delete('/veiculo/$id');
  }
}
