import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cadastros.dart';
import 'core/theme/app_theme.dart';
import 'data/demo_dashboard.dart' as demo;
import 'models/domain.dart';
import 'screens/cadastro_screen.dart';
import 'screens/cadastros/cadastro_indicador.dart';
import 'screens/cadastros/cadastro_usuario.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_page.dart';

void main() {
  runApp(UsinaApp(dashboard: criarDashboardDemo()));
}

DashboardExtracao criarDashboardDemo() => demo.criarDashboardDemo();

class UsinaApp extends StatelessWidget {
  final DashboardExtracao dashboard;

  const UsinaApp({super.key, required this.dashboard});

  Future<bool> _hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loginRealizado') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'usina aurora',
      theme: AppTheme.dark,
      routes: {
        '/dashboard': (_) => DashboardScreen(dashboard: dashboard),
        '/login': (_) => LoginPage(dashboard: dashboard),
        '/cadastro/indicador': (_) => const CadastroIndicadorPage(),
        '/cadastro/usuario': (_) => const CadastroUsuarioPage(),
        for (final entry in cadastros.entries)
          '/cadastro/${entry.key}': (_) => CadastroScreen(config: entry.value),
      },
      home: FutureBuilder<bool>(
        future: _hasActiveSession(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const _SessionLoading();
          }
          return snapshot.data == true
              ? DashboardScreen(dashboard: dashboard)
              : LoginPage(dashboard: dashboard);
        },
      ),
    );
  }
}

class _SessionLoading extends StatelessWidget {
  const _SessionLoading();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}
