import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../models/indicador.dart';
import '../../services/indicador_service.dart';
import 'cadastro_indicador.dart';
import 'indicador_webview.dart';

class IndicadoresPage extends StatefulWidget {
  const IndicadoresPage({super.key});
  @override
  State<IndicadoresPage> createState() => _IndicadoresPageState();
}

class _IndicadoresPageState extends State<IndicadoresPage> {
  final _service = IndicadorService();
  late Future<List<IndicadorRest>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => _future = _service.listar();

  Future<void> _edit([IndicadorRest? indicador]) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => CadastroIndicadorPage(indicador: indicador)));
    if (!mounted || saved != true) return;
    setState(_reload);
  }

  Future<void> _delete(IndicadorRest indicador) async {
    final id = indicador.id;
    if (id == null) return;
    final confirm = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('excluir indicador?'), content: Text('essa ação remove "${indicador.nome}" da api.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('cancelar')), FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('excluir'))]));
    if (confirm != true || !mounted) return;
    try {
      await _service.excluir(id);
      if (!mounted) return;
      setState(_reload);
      _message('indicador excluído.');
    } catch (error) {
      if (mounted) _message(error.toString(), error: true);
    }
  }

  void _message(String text, {bool error = false}) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating, backgroundColor: error ? AppColors.critical : const Color(0xff2c6149)));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('indicadores'), actions: [IconButton(tooltip: 'atualizar', onPressed: () => setState(_reload), icon: const Icon(Icons.refresh_rounded))]),
        floatingActionButton: FloatingActionButton.extended(onPressed: () => _edit(), icon: const Icon(Icons.add_rounded), label: const Text('novo indicador')),
        body: FutureBuilder<List<IndicadorRest>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return _Failure(message: snapshot.error.toString(), onRetry: () => setState(_reload));
            final records = (snapshot.data ?? []).where((item) => item.nome.toLowerCase().contains(_query.toLowerCase()) || item.descricao.toLowerCase().contains(_query.toLowerCase())).toList();
            return Column(children: [Padding(padding: const EdgeInsets.fromLTRB(18, 14, 18, 10), child: TextField(onChanged: (value) => setState(() => _query = value), decoration: const InputDecoration(hintText: 'buscar indicador', prefixIcon: Icon(Icons.search_rounded), isDense: true))), Expanded(child: records.isEmpty ? _Empty(filtered: _query.isNotEmpty, onCreate: () => _edit()) : RefreshIndicator(onRefresh: () async => setState(_reload), child: ListView.separated(padding: const EdgeInsets.fromLTRB(18, 8, 18, 100), itemCount: records.length, separatorBuilder: (_, __) => const SizedBox(height: 9), itemBuilder: (context, index) { final item = records[index]; return _IndicatorTile(indicator: item, onOpen: item.url.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => IndicadorWebView(indicador: item))), onEdit: () => _edit(item), onDelete: () => _delete(item)); })))]);
          },
        ),
      );
}

class _IndicatorTile extends StatelessWidget {
  final IndicadorRest indicator;
  final VoidCallback? onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _IndicatorTile({required this.indicator, required this.onOpen, required this.onEdit, required this.onDelete});
  @override
  Widget build(BuildContext context) => Container(decoration: BoxDecoration(color: Colors.white.withValues(alpha: .055), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: .1))), child: ListTile(onTap: onOpen, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.moss.withValues(alpha: .13), borderRadius: BorderRadius.circular(14)), child: Icon(onOpen == null ? Icons.insights_outlined : Icons.open_in_browser_rounded, color: AppColors.moss)), title: Text(indicator.nome, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(indicator.descricao, maxLines: 1, overflow: TextOverflow.ellipsis)), trailing: PopupMenuButton<String>(onSelected: (value) => value == 'editar' ? onEdit() : onDelete(), itemBuilder: (_) => const [PopupMenuItem(value: 'editar', child: Text('editar')), PopupMenuItem(value: 'excluir', child: Text('excluir'))])));
}

class _Empty extends StatelessWidget {
  final bool filtered;
  final VoidCallback onCreate;
  const _Empty({required this.filtered, required this.onCreate});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.insights_outlined, size: 48, color: AppColors.moss), const SizedBox(height: 14), Text(filtered ? 'nenhum indicador encontrado.' : 'ainda não há indicadores cadastrados.', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted)), if (!filtered) ...[const SizedBox(height: 16), OutlinedButton.icon(onPressed: onCreate, icon: const Icon(Icons.add_rounded), label: const Text('criar primeiro indicador'))]])));
}

class _Failure extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _Failure({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off_rounded, size: 46, color: AppColors.critical), const SizedBox(height: 13), const Text('não foi possível carregar os indicadores.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)), const SizedBox(height: 17), FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('tentar novamente'))])));
}
