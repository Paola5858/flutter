import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const AgroControlApp());
}

/// App principal do AgroControl
/// Usa ThemeMode.system para detectar modo escuro do sistema
class AgroControlApp extends StatelessWidget {
  const AgroControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroControl',
      debugShowCheckedModeBanner: false,
      // ThemeMode.system detecta automaticamente o modo escuro do sistema
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
