import 'package:flutter/material.dart';
import 'models/indicador.dart';
import 'screens/dashboard_screen.dart';

final List<Indicador> indicadores = [
  Indicador(
    id: 1,
    nome: 'produção de açúcar',
    valor: 850.5,
    unidade: 'ton',
    data: DateTime.now(),
  ),
  Indicador(
    id: 2,
    nome: 'temperatura',
    valor: 75.2,
    unidade: '°C',
    data: DateTime.now(),
  ),
  Indicador(
    id: 3,
    nome: 'umidade',
    valor: 60.0,
    unidade: '%',
    data: DateTime.now(),
  ),
];

void main() {
  runApp(const UsinaApp());
}

class UsinaApp extends StatelessWidget {
  const UsinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'testando mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: DashboardScreen(indicadores: indicadores),
    );
  }
}
