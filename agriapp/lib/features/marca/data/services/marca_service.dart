import '../../domain/entities/marca_entity.dart';

class MarcaService {
  // Simulating a service, in real app this would use repository
  List<Marca> _marcas = [];

  Future<Marca> cadastrarMarca(Marca marca) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    // Add id if not present
    final newMarca = marca.copyWith(id: marca.id ?? DateTime.now().toString());
    _marcas.add(newMarca);
    return newMarca;
  }

  Future<void> editarMarca(String id, Marca marca) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _marcas.indexWhere((m) => m.id == id);
    if (index != -1) {
      _marcas[index] = marca.copyWith(id: id);
    }
  }

  Future<List<Marca>> getMarcas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _marcas;
  }
}
