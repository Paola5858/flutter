import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/veiculo.dart';

class VeiculoService {
  final DioClient dioClient;

  VeiculoService(this.dioClient);

  Future<List<Veiculo>> listar() async {
    try {
      final response = await dioClient.instance.get('/veiculo');
      final List listaJson = response.data;
      return listaJson.map((item) => Veiculo.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Erro ao listar veículos: ${e.message}');
    }
  }

  Future<void> cadastrar(Veiculo veiculo) async {
    try {
      await dioClient.instance.post('/veiculo', data: veiculo.toJson());
    } on DioException catch (e) {
      throw Exception('Erro ao cadastrar veículo: ${e.message}');
    }
  }

  Future<void> editar(int id, Veiculo veiculo) async {
    try {
      await dioClient.instance.patch('/veiculo/$id', data: veiculo.toJson());
    } on DioException catch (e) {
      throw Exception('Erro ao editar veículo: ${e.message}');
    }
  }

  Future<void> excluir(int id) async {
    try {
      await dioClient.instance.delete('/veiculo/$id');
    } on DioException catch (e) {
      throw Exception('Erro ao excluir veículo: ${e.message}');
    }
  }
}
