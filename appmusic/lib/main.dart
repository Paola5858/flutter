import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/musica_list_screen.dart';

void main() {
  runApp(const ReffaoApp());
}

class ReffaoApp extends StatelessWidget {
  const ReffaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MusicaListScreen(),
    );
  }
}
