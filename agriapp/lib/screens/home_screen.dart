import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ColorTokenSet>()!;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: const Text('Menu Principal'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _botaoMenu(context, 'Gerenciar Marcas', Icons.branding_watermark, '/marcas', tokens.accent),
                _botaoMenu(context, 'Gerenciar Modelos', Icons.directions_car, '/modelos', const Color(0xFF2A9D8F)),
                _botaoMenu(context, 'Gerenciar Veículos', Icons.directions_bus, '/veiculos', const Color(0xFFE76F51)),
              ],
            );
          },
        ),
      ),
    );
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
