import '../../domain/entities/marca_entity.dart';

class MarcaService {
  final List<Marca> _marcas = [];

  Future<Marca> cadastrarMarca(Marca marca) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newMarca = marca.copyWith(id: marca.id ?? DateTime.now().toString());
    _marcas.add(newMarca);
    return newMarca;
  }

  Future<void> editarMarca(String id, Marca marca) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _marcas.indexWhere((m) => m.id == id);
    if (index != -1) {
      _marcas[index] = marca.copyWith(id: id);
    }
  }

  Future<void> excluirMarca(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _marcas.removeWhere((m) => m.id == id);
  }

  Future<List<Marca>> getMarcas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _marcas;
  }
}
