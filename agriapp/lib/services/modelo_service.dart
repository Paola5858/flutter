import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/modelo.dart';

class ModeloService {
  final DioClient dioClient;

  ModeloService(this.dioClient);

  Future<List<Modelo>> listar() async {
    try {
      final response = await dioClient.instance.get('/modelo');
      final List listaJson = response.data;
      return listaJson.map((item) => Modelo.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Erro ao listar modelos: ${e.message}');
    }
  }

  Future<void> cadastrar(Modelo modelo) async {
    try {
      await dioClient.instance.post('/modelo', data: modelo.toJson());
    } on DioException catch (e) {
      throw Exception('Erro ao cadastrar modelo: ${e.message}');
    }
  }

  Future<void> editar(int id, Modelo modelo) async {
    try {
      await dioClient.instance.patch('/modelo/$id', data: modelo.toJson());
    } on DioException catch (e) {
      throw Exception('Erro ao editar modelo: ${e.message}');
    }
  }

  Future<void> excluir(int id) async {
    try {
      await dioClient.instance.delete('/modelo/$id');
    } on DioException catch (e) {
      throw Exception('Erro ao excluir modelo: ${e.message}');
    }
  }
}
