import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/theme/app_tokens.dart';
import '../../models/indicador.dart';

class IndicadorWebView extends StatefulWidget {
  final IndicadorRest indicador;
  const IndicadorWebView({super.key, required this.indicador});

  @override
  State<IndicadorWebView> createState() => _IndicadorWebViewState();
}

class _IndicadorWebViewState extends State<IndicadorWebView> {
  late final WebViewController _controller;
  late final Uri _uri;
  bool _loading = true;
  int _progress = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _uri = Uri.parse(widget.indicador.url);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.mineral)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (value) {
          if (mounted) setState(() => _progress = value);
        },
        onPageStarted: (_) {
          if (mounted) setState(() { _loading = true; _error = null; });
        },
        onPageFinished: (_) {
          if (mounted) setState(() { _loading = false; _progress = 100; });
        },
        onWebResourceError: (error) {
          if (!mounted || error.isForMainFrame != true) return;
          setState(() { _loading = false; _error = 'não foi possível carregar este indicador. verifique a conexão e tente novamente.'; });
        },
        onNavigationRequest: (request) {
          final next = Uri.tryParse(request.url);
          if (next != null && _isAllowed(next)) return NavigationDecision.navigate;
          return NavigationDecision.prevent;
        },
      ))
      ..loadRequest(_uri);
  }

  bool _isAllowed(Uri next) => (next.scheme == 'http' || next.scheme == 'https') && (next.host == _uri.host || next.host.endsWith('.${_uri.host}'));

  Future<void> _refresh() async {
    setState(() { _loading = true; _error = null; _progress = 0; });
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.indicador.nome), actions: [IconButton(tooltip: 'atualizar', onPressed: _refresh, icon: const Icon(Icons.refresh_rounded))]),
        body: Stack(children: [
          if (_error == null) WebViewWidget(controller: _controller) else _Error(onRetry: _refresh),
          if (_loading && _error == null) Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator(value: _progress == 0 || _progress == 100 ? null : _progress / 100, minHeight: 2, color: AppColors.moss, backgroundColor: Colors.transparent)),
        ]),
      );
}

class _Error extends StatelessWidget {
  final VoidCallback onRetry;
  const _Error({required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.link_off_rounded, size: 48, color: AppColors.critical), const SizedBox(height: 14), const Text('indicador indisponível', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)), const SizedBox(height: 9), const Text('a fonte não respondeu agora.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 12)), const SizedBox(height: 18), FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('tentar novamente'))])));
}
