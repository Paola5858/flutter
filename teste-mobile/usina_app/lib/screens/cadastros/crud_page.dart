import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../services/crud_service.dart';

class CrudResource {
  final String keyName;
  final String title;
  final String singular;
  final String route;
  final IconData icon;

  const CrudResource({required this.keyName, required this.title, required this.singular, required this.route, required this.icon});

  CrudService get service => CrudService(route);

  bool get needsDateRange => keyName == 'safra';
  bool get needsUnit => keyName == 'equipamento';
  bool get needsMeasureUnit => keyName == 'tipo';
  bool get needsMeasurementRelations => keyName == 'medicao';

  String titleOf(Map<String, dynamic> item) {
    switch (keyName) {
      case 'safra':
        return _text(item, 'NomeSafra', 'nomeSafra');
      case 'medicao':
        return 'medição ${_text(item, 'Valor', 'valor')}';
      default:
        return _text(item, 'Nome', 'nome');
    }
  }

  String subtitleOf(Map<String, dynamic> item) {
    switch (keyName) {
      case 'safra':
        return '${_text(item, 'DataInicio', 'dataInicio')} até ${_text(item, 'DataFim', 'dataFim')}';
      case 'unidadeMedida':
        return 'símbolo: ${_text(item, 'Simbolo', 'simbolo')}';
      case 'equipamento':
        return 'unidade id: ${_text(item, 'UnidadeId', 'unidadeId')}';
      case 'tipo':
        return 'unidade de medida id: ${_text(item, 'UnidadeMedidaId', 'unidadeMedidaId')}';
      case 'medicao':
        return '${_text(item, 'Data', 'data')} · safra ${_text(item, 'SafraId', 'safraId')}';
      default:
        return 'registro id ${idOf(item) ?? 'novo'}';
    }
  }

  int? idOf(Map<String, dynamic> item) => _int(item['Id'] ?? item['id']);

  static String _text(Map<String, dynamic> item, String primary, String fallback) => (item[primary] ?? item[fallback] ?? '').toString();
  static int? _int(dynamic value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
}

const crudResources = <CrudResource>[
  CrudResource(keyName: 'safra', title: 'safras', singular: 'safra', route: ApiConfig.safras, icon: Icons.calendar_month_outlined),
  CrudResource(keyName: 'unidade', title: 'unidades', singular: 'unidade', route: ApiConfig.unidades, icon: Icons.account_tree_outlined),
  CrudResource(keyName: 'unidadeMedida', title: 'unidades de medida', singular: 'unidade de medida', route: ApiConfig.unidadesMedida, icon: Icons.straighten_outlined),
  CrudResource(keyName: 'equipamento', title: 'equipamentos', singular: 'equipamento', route: ApiConfig.equipamentos, icon: Icons.precision_manufacturing_outlined),
  CrudResource(keyName: 'tipo', title: 'tipos de informação', singular: 'tipo de informação', route: ApiConfig.tiposInformacao, icon: Icons.data_object_rounded),
  CrudResource(keyName: 'medicao', title: 'medições', singular: 'medição', route: ApiConfig.medicoes, icon: Icons.monitor_heart_outlined),
];

class CrudPage extends StatefulWidget {
  final CrudResource resource;
  const CrudPage({super.key, required this.resource});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  late Future<List<Map<String, dynamic>>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => _future = widget.resource.service.listar();

  Future<void> _openEditor([Map<String, dynamic>? record]) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => CrudEditorPage(resource: widget.resource, record: record)));
    if (!mounted || saved != true) return;
    setState(_reload);
  }

  Future<void> _delete(Map<String, dynamic> record) async {
    final id = widget.resource.idOf(record);
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('excluir registro?'),
        content: Text('essa ação remove "${widget.resource.titleOf(record)}" da api e não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('cancelar')),
          FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('excluir')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.resource.service.excluir(id);
      if (!mounted) return;
      setState(_reload);
      _message('registro excluído.');
    } catch (error) {
      if (mounted) _message(error.toString(), error: true);
    }
  }

  void _message(String text, {bool error = false}) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating, backgroundColor: error ? AppColors.critical : const Color(0xff2c6149)));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.resource.title), actions: [IconButton(tooltip: 'atualizar', onPressed: () => setState(_reload), icon: const Icon(Icons.refresh_rounded))]),
        floatingActionButton: FloatingActionButton.extended(onPressed: () => _openEditor(), icon: const Icon(Icons.add_rounded), label: const Text('novo registro')),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return _FailureState(message: snapshot.error.toString(), onRetry: () => setState(_reload));
            final records = (snapshot.data ?? []).where((item) => widget.resource.titleOf(item).toLowerCase().contains(_query.toLowerCase())).toList();
            return Column(
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(18, 14, 18, 10), child: TextField(onChanged: (value) => setState(() => _query = value), decoration: const InputDecoration(hintText: 'buscar registro', prefixIcon: Icon(Icons.search_rounded), isDense: true))),
                Expanded(child: records.isEmpty ? _EmptyState(resource: widget.resource, filtered: _query.isNotEmpty, onCreate: () => _openEditor()) : RefreshIndicator(onRefresh: () async => setState(_reload), child: ListView.separated(padding: const EdgeInsets.fromLTRB(18, 8, 18, 100), itemCount: records.length, separatorBuilder: (_, __) => const SizedBox(height: 9), itemBuilder: (context, index) => _RecordTile(resource: widget.resource, record: records[index], onEdit: () => _openEditor(records[index]), onDelete: () => _delete(records[index]))))),
              ],
            );
          },
        ),
      );
}

class _RecordTile extends StatelessWidget {
  final CrudResource resource;
  final Map<String, dynamic> record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _RecordTile({required this.resource, required this.record, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .055), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: .1))),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.moss.withValues(alpha: .13), borderRadius: BorderRadius.circular(14)), child: Icon(resource.icon, color: AppColors.moss)),
          title: Text(resource.titleOf(record), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(resource.subtitleOf(record), maxLines: 1, overflow: TextOverflow.ellipsis)),
          trailing: PopupMenuButton<String>(onSelected: (value) => value == 'editar' ? onEdit() : onDelete(), itemBuilder: (_) => const [PopupMenuItem(value: 'editar', child: Text('editar')), PopupMenuItem(value: 'excluir', child: Text('excluir'))]),
        ),
      );
}

class CrudEditorPage extends StatefulWidget {
  final CrudResource resource;
  final Map<String, dynamic>? record;
  const CrudEditorPage({super.key, required this.resource, this.record});
  @override
  State<CrudEditorPage> createState() => _CrudEditorPageState();
}

class _CrudEditorPageState extends State<CrudEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _symbol = TextEditingController();
  final _value = TextEditingController();
  DateTime? _start;
  DateTime? _end;
  DateTime _measurementDate = DateTime.now();
  int? _unitId;
  int? _measureUnitId;
  int? _harvestId;
  int? _equipmentId;
  int? _typeId;
  bool _saving = false;
  bool _loadingRelations = false;
  List<Map<String, dynamic>> _units = [];
  List<Map<String, dynamic>> _measureUnits = [];
  List<Map<String, dynamic>> _harvests = [];
  List<Map<String, dynamic>> _equipment = [];
  List<Map<String, dynamic>> _types = [];

  bool get editing => widget.record != null;

  @override
  void initState() {
    super.initState();
    _fillRecord();
    if (widget.resource.needsUnit || widget.resource.needsMeasureUnit || widget.resource.needsMeasurementRelations) _loadRelations();
  }

  void _fillRecord() {
    final item = widget.record;
    if (item == null) return;
    _name.text = _text(item, 'Nome', 'nome');
    if (widget.resource.keyName == 'safra') {
      _name.text = _text(item, 'NomeSafra', 'nomeSafra');
      _start = DateTime.tryParse(_text(item, 'DataInicio', 'dataInicio'));
      _end = DateTime.tryParse(_text(item, 'DataFim', 'dataFim'));
    }
    _symbol.text = _text(item, 'Simbolo', 'simbolo');
    _value.text = _text(item, 'Valor', 'valor');
    _unitId = _int(item['UnidadeId'] ?? item['unidadeId']);
    _measureUnitId = _int(item['UnidadeMedidaId'] ?? item['unidadeMedidaId']);
    _harvestId = _int(item['SafraId'] ?? item['safraId']);
    _equipmentId = _int(item['EquipamentoId'] ?? item['equipamentoId']);
    _typeId = _int(item['TipoInformacaoId'] ?? item['tipoInformacaoId']);
    _measurementDate = DateTime.tryParse(_text(item, 'Data', 'data')) ?? DateTime.now();
  }

  Future<void> _loadRelations() async {
    setState(() => _loadingRelations = true);
    try {
      if (widget.resource.needsUnit || widget.resource.needsMeasurementRelations) _units = await CrudService(ApiConfig.unidades).listar();
      if (widget.resource.needsMeasureUnit || widget.resource.needsMeasurementRelations) _measureUnits = await CrudService(ApiConfig.unidadesMedida).listar();
      if (widget.resource.needsMeasurementRelations) {
        _harvests = await CrudService(ApiConfig.safras).listar();
        _equipment = await CrudService(ApiConfig.equipamentos).listar();
        _types = await CrudService(ApiConfig.tiposInformacao).listar();
      }
    } catch (error) {
      if (mounted) _show(error.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loadingRelations = false);
    }
  }

  Future<void> _pickDate({required bool start}) async {
    final selected = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100), initialDate: (start ? _start : _end) ?? DateTime.now());
    if (!mounted || selected == null) return;
    setState(() {
      if (start) _start = selected; else _end = selected;
    });
  }

  Future<void> _pickMeasurementDate() async {
    final date = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100), initialDate: _measurementDate);
    if (!mounted || date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_measurementDate));
    if (!mounted || time == null) return;
    setState(() => _measurementDate = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (widget.resource.keyName == 'safra' && (_start == null || _end == null || _end!.isBefore(_start!))) {
      _show('informe um intervalo de datas válido para a safra.', error: true);
      return;
    }
    setState(() => _saving = true);
    try {
      final payload = _payload();
      final id = _int(widget.record?['Id'] ?? widget.record?['id']);
      if (editing && id != null) await widget.resource.service.editar(id, payload); else await widget.resource.service.criar(payload);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (mounted) _show(error.toString(), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Map<String, dynamic> _payload() {
    switch (widget.resource.keyName) {
      case 'safra': return {'NomeSafra': _name.text.trim(), 'DataInicio': _date(_start!), 'DataFim': _date(_end!)};
      case 'unidade': return {'Nome': _name.text.trim()};
      case 'unidadeMedida': return {'Nome': _name.text.trim(), 'Simbolo': _symbol.text.trim()};
      case 'equipamento': return {'Nome': _name.text.trim(), 'UnidadeId': _unitId};
      case 'tipo': return {'Nome': _name.text.trim(), 'UnidadeMedidaId': _measureUnitId};
      case 'medicao': return {'SafraId': _harvestId, 'EquipamentoId': _equipmentId, 'TipoInformacaoId': _typeId, 'Valor': double.parse(_value.text.replaceAll(',', '.')), 'Data': _measurementDate.toIso8601String()};
      default: return {};
    }
  }

  String _date(DateTime date) => date.toIso8601String().substring(0, 10);
  int? _int(dynamic value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
  String _text(Map<String, dynamic> item, String key, String fallback) => (item[key] ?? item[fallback] ?? '').toString();
  void _show(String text, {bool error = false}) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating, backgroundColor: error ? AppColors.critical : const Color(0xff2c6149)));

  @override
  void dispose() { _name.dispose(); _symbol.dispose(); _value.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('${editing ? 'editar' : 'novo'} ${widget.resource.singular}')),
        body: _loadingRelations ? const Center(child: CircularProgressIndicator()) : Form(key: _formKey, child: ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 34), children: [_intro(), ..._fields(), const SizedBox(height: 22), FilledButton.icon(onPressed: _saving ? null : _save, icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check_rounded), label: Text(_saving ? 'salvando...' : editing ? 'salvar alterações' : 'criar registro'))])),
      );

  Widget _intro() => Padding(padding: const EdgeInsets.only(bottom: 20), child: Text(editing ? 'atualize os dados e confirme a alteração na api.' : 'preencha os campos obrigatórios. o registro será enviado para a api.', style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, height: 1.4)));

  List<Widget> _fields() {
    final key = widget.resource.keyName;
    if (key == 'safra') return [_textField('nome da safra', _name, Icons.calendar_month_outlined), _dateField('data de início', _start, () => _pickDate(start: true)), _dateField('data de fim', _end, () => _pickDate(start: false))];
    if (key == 'unidade') return [_textField('nome', _name, Icons.account_tree_outlined)];
    if (key == 'unidadeMedida') return [_textField('nome', _name, Icons.straighten_outlined), _textField('símbolo', _symbol, Icons.short_text_rounded)];
    if (key == 'equipamento') return [_textField('nome', _name, Icons.precision_manufacturing_outlined), _dropdown('unidade', _unitId, _units, 'Nome', (value) => setState(() => _unitId = value))];
    if (key == 'tipo') return [_textField('nome', _name, Icons.data_object_rounded), _dropdown('unidade de medida', _measureUnitId, _measureUnits, 'Nome', (value) => setState(() => _measureUnitId = value))];
    return [_dropdown('safra', _harvestId, _harvests, 'NomeSafra', (value) => setState(() => _harvestId = value)), _dropdown('equipamento', _equipmentId, _equipment, 'Nome', (value) => setState(() => _equipmentId = value)), _dropdown('tipo de informação', _typeId, _types, 'Nome', (value) => setState(() => _typeId = value)), _textField('valor', _value, Icons.numbers_rounded, numeric: true), _dateField('data e hora', _measurementDate, _pickMeasurementDate)];
  }

  Widget _textField(String label, TextEditingController controller, IconData icon, {bool numeric = false}) => Padding(padding: const EdgeInsets.only(bottom: 13), child: TextFormField(controller: controller, keyboardType: numeric ? const TextInputType.numberWithOptions(decimal: true) : null, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)), validator: (value) { if (value == null || value.trim().isEmpty) return 'informe $label'; if (numeric && double.tryParse(value.replaceAll(',', '.')) == null) return 'informe um número válido'; return null; }));

  Widget _dateField(String label, DateTime? value, VoidCallback onTap) => Padding(padding: const EdgeInsets.only(bottom: 13), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: InputDecorator(decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.event_outlined), errorText: value == null ? 'selecione uma data' : null), child: Text(value == null ? 'selecionar' : value.toLocal().toString().substring(0, widget.resource.keyName == 'medicao' ? 16 : 10)))));

  Widget _dropdown(String label, int? value, List<Map<String, dynamic>> items, String nameKey, ValueChanged<int?> onChanged) => Padding(padding: const EdgeInsets.only(bottom: 13), child: DropdownButtonFormField<int>(initialValue: items.any((item) => _int(item['Id'] ?? item['id']) == value) ? value : null, decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.link_rounded)), items: items.map((item) { final id = _int(item['Id'] ?? item['id']); return DropdownMenuItem(value: id, child: Text((item[nameKey] ?? item['nome'] ?? item['Nome'] ?? 'registro $id').toString())); }).toList(), onChanged: onChanged, validator: (selected) => selected == null ? 'selecione $label' : null));
}

class _EmptyState extends StatelessWidget {
  final CrudResource resource;
  final bool filtered;
  final VoidCallback onCreate;
  const _EmptyState({required this.resource, required this.filtered, required this.onCreate});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(filtered ? Icons.search_off_rounded : resource.icon, size: 46, color: AppColors.moss), const SizedBox(height: 13), Text(filtered ? 'nenhum registro encontrado.' : 'ainda não há ${resource.title} cadastradas.', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted)), if (!filtered) ...[const SizedBox(height: 16), OutlinedButton.icon(onPressed: onCreate, icon: const Icon(Icons.add_rounded), label: const Text('criar primeiro registro'))]])));
}

class _FailureState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _FailureState({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off_rounded, size: 46, color: AppColors.critical), const SizedBox(height: 13), const Text('não foi possível carregar os registros.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)), const SizedBox(height: 17), FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('tentar novamente'))])));
}
