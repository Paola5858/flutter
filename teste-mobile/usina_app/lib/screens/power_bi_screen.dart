import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core/theme/app_tokens.dart';

class PowerBiScreen extends StatefulWidget {
  const PowerBiScreen({super.key});

  @override
  State<PowerBiScreen> createState() => _PowerBiScreenState();
}

class _PowerBiScreenState extends State<PowerBiScreen> {
  static final Uri reportUri = Uri.parse(
    'https://app.powerbi.com/reportEmbed?reportId=22450b7a-e0c7-4472-a33a-becc7adaa99e&autoAuth=true&ctid=b1051c4b-3b94-41ab-9441-e73a72342fdd',
  );

  late final WebViewController _controller;
  int _progress = 0;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _loading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() {
              _loading = false;
              _progress = 100;
            });
          },
          onWebResourceError: (error) {
            if (!mounted || error.isForMainFrame != true) return;
            setState(() {
              _loading = false;
              _errorMessage = _friendlyError(error);
            });
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri != null && _isAllowedHost(uri.host)) {
              return NavigationDecision.navigate;
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('esse link fica fora do ambiente autorizado do relatório.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(reportUri);
    if (!kIsWeb) {
      _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      _controller.setBackgroundColor(AppColors.mineral);
    }
  }

  bool _isAllowedHost(String host) {
    final normalized = host.toLowerCase();
    const allowed = <String>{
      'app.powerbi.com',
      'powerbi.com',
      'login.microsoftonline.com',
      'microsoftonline.com',
      'microsoft.com',
      'office.com',
      'live.com',
      'pess.portalsesisp.org.br',
    };
    return allowed.any((domain) => normalized == domain || normalized.endsWith('.$domain'));
  }

  String _friendlyError(WebResourceError error) {
    final description = error.description.toLowerCase();
    if (description.contains('net::err') || description.contains('network')) {
      return 'não foi possível conectar ao Power BI. verifique sua internet e tente novamente.';
    }
    return 'o relatório não pôde ser carregado agora. tente atualizar ou abrir pelo navegador.';
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _progress = 0;
    });
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dashboard power bi'),
        actions: [
          IconButton(
            tooltip: 'atualizar relatório',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_errorMessage == null) WebViewWidget(controller: _controller),
          if (_errorMessage != null) _ErrorState(message: _errorMessage!, onRetry: _refresh),
          if (_loading && _errorMessage == null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progress == 0 || _progress == 100 ? null : _progress / 100,
                minHeight: 2,
                backgroundColor: Colors.transparent,
                color: AppColors.moss,
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.moss.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.analytics_outlined, color: AppColors.moss, size: 32),
              ),
              const SizedBox(height: 20),
              const Text(
                'o painel ficou fora do alcance',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, height: 1.45),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('tentar novamente'),
              ),
            ],
          ),
        ),
      );
}
