import '../models/indicador.dart';
import 'crud_service.dart';

class IndicadorService {
  static const route = String.fromEnvironment('USINA_INDICADORES_ROUTE', defaultValue: ApiConfig.indicadores);

  final CrudService _service;
  IndicadorService({CrudService? service}) : _service = service ?? CrudService(route);

  Future<List<IndicadorRest>> listar() async {
    final records = await _service.listar();
    return records.map(IndicadorRest.fromJson).toList();
  }

  Future<void> criar(IndicadorRest indicador) => _service.criar(indicador.toJson());

  Future<void> editar(IndicadorRest indicador) {
    final id = indicador.id;
    if (id == null) throw const ApiException('o indicador não possui id para edição.');
    return _service.editar(id, indicador.toJson());
  }

  Future<void> excluir(int id) => _service.excluir(id);
}
