import '../../domain/entities/modelo_entity.dart';

class ModeloService {
  final List<Modelo> _modelos = [];

  Future<Modelo> cadastrar(Modelo modelo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newModelo = modelo.copyWith(id: modelo.id ?? DateTime.now().toString());
    _modelos.add(newModelo);
    return newModelo;
  }

  Future<void> editar(String id, Modelo modelo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _modelos.indexWhere((m) => m.id == id);
    if (index != -1) {
      _modelos[index] = modelo.copyWith(id: id);
    }
  }

  Future<List<Modelo>> listar() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _modelos;
  }

  Future<void> excluir(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _modelos.removeWhere((m) => m.id == id);
  }
}