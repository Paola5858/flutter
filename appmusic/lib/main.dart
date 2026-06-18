import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/musica_list_screen.dart';


void main() {
  runApp(const RefraoApp());
}

class RefraoApp extends StatelessWidget {
  const RefraoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MusicaListScreen(),
    );
  }
}
