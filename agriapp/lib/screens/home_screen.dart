import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ColorTokenSet>()!;
    final mq = MediaQuery.of(context);
    final isPortrait = mq.orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriApp — Menu Principal'),
        backgroundColor: tokens.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _toggleTheme(context),
            tooltip: 'Alternar tema',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // responsive breakpoints
            int crossAxisCount;
            double spacing;
            if (constraints.maxWidth < 375) {
              crossAxisCount = 1;
              spacing = SpacingTokens.sm;
            } else if (constraints.maxWidth < 768) {
              crossAxisCount = 2;
              spacing = SpacingTokens.md;
            } else if (constraints.maxWidth < 1024) {
              crossAxisCount = 3;
              spacing = SpacingTokens.lg;
            } else {
              crossAxisCount = 4;
              spacing = SpacingTokens.xl;
            }

            return GridView.builder(
              padding: const EdgeInsets.all(SpacingTokens.md),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: isPortrait ? 1.0 : 1.4,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                final items = [
                  _MenuCard(
                    title: 'Gerenciar Marcas',
                    icon: Icons.branding_watermark,
                    color: tokens.accent,
                    route: '/marcas',
                    tokens: tokens,
                  ),
                  _MenuCard(
                    title: 'Gerenciar Modelos',
                    icon: Icons.directions_car,
                    color: const Color(0xFF2A9D8F),
                    route: '/modelos',
                    tokens: tokens,
                  ),
                  _MenuCard(
                    title: 'Gerenciar Veículos',
                    icon: Icons.directions_bus,
                    color: const Color(0xFFE76F51),
                    route: '/veiculos',
                    tokens: tokens,
                  ),
                ];
                return items[index];
              },
            );
          },
        ),
      ),
    );
  }

  void _toggleTheme(BuildContext context) {
    // implementação futura: ThemeMode toggle com Provider/Riverpod
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final ColorTokenSet tokens;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'menu_${title.toLowerCase().replaceAll(' ', '_')}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(16),
          splashColor: color.withOpacity(0.2),
          highlightColor: color.withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rive animation placeholder (futuro)
                // RiveAnimation.asset('assets/riv/menu_icon.riv'),
                Icon(icon, size: 48, color: Colors.white),
                const SizedBox(height: SpacingTokens.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.xs,
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
