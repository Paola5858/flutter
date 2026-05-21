import 'package:flutter/material.dart';
import '../../../../core/theme/tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ColorTokens>()!;

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: AppBar(
        title: const Text('AgriApp'),
        backgroundColor: tokens.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(context, 'Veículos', Icons.directions_car, '/veiculo'),
            _buildCard(context, 'Marcas', Icons.business, '/marca'),
            _buildCard(context, 'Modelos', Icons.car_repair, '/modelo'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String route) {
    final tokens = Theme.of(context).extension<ColorTokens>()!;

    return Card(
      color: tokens.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: tokens.primary),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(color: tokens.textPrimary, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}