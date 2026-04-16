import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _botaoMenu(context, 'Gerenciar Marcas', Icons.branding_watermark, '/marcas', Colors.blue),
            _botaoMenu(context, 'Gerenciar Modelos', Icons.directions_car, '/modelos', Colors.green),
            _botaoMenu(context, 'Gerenciar Veículos', Icons.directions_bus, '/veiculos', Colors.orange),
          ],
        ),
      ),
    );

    return Container();
  }


Widget _botaoMenu(
  BuildContext context,
  String texto,
  IconData icon,
  String rota,
  Color cor,
) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, rota);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: cor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.white),
        const SizedBox(height: 10),
        Text(texto, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}
