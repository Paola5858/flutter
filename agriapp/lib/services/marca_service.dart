import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/marca.dart';

class MarcaService {
  final DioClient dioClient;

  MarcaService(this.dioClient);

  Future<List<Marca>> listar() async {
    try {
      final response = await dioClient.instance.get('/marca');
      final List listaJson = response.data;
      return listaJson.map((item) => Marca.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Erro ao listar marcas: ${e.message}');
    }
  }

  Future<void> cadastrar(Marca marca) async {
    try {
      await dioClient.instance.post('/marca', data: marca.toJson());
    } on DioException catch (e) {
      throw Exception('Erro ao cadastrar marca: ${e.message}');
    }
  }

  Future<void> editar(int id, Marca marca) async {
    try {
      await dioClient.instance.patch('/marca/$id', data: marca.toJson());
    } on DioException catch (e) {
      throw Exception('Erro ao editar marca: ${e.message}');
    }
  }

  Future<void> excluir(int id) async {
    try {
      await dioClient.instance.delete('/marca/$id');
    } on DioException catch (e) {
      throw Exception('Erro ao excluir marca: ${e.message}');
    }
  }
}
