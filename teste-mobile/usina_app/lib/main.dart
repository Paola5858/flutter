import 'package:flutter/material.dart';
import 'cadastros.dart';
import 'core/theme/app_theme.dart';
import 'data/demo_dashboard.dart' as demo;
import 'models/domain.dart';
import 'screens/cadastro_screen.dart';
import 'screens/cadastros/cadastro_indicador.dart';
import 'screens/cadastros/cadastro_usuario.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(UsinaApp(dashboard: criarDashboardDemo()));
}

DashboardExtracao criarDashboardDemo() => demo.criarDashboardDemo();

class UsinaApp extends StatelessWidget {
  final DashboardExtracao dashboard;

  const UsinaApp({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'usina aurora',
      theme: AppTheme.dark,
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (_) => DashboardScreen(dashboard: dashboard),
        '/cadastro/indicador': (_) => const CadastroIndicadorPage(),
        '/cadastro/usuario': (_) => const CadastroUsuarioPage(),
        for (final entry in cadastros.entries)
          '/cadastro/${entry.key}': (_) => CadastroScreen(config: entry.value),
      },
    );
  }
}
