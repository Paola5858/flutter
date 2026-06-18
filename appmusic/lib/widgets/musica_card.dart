import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/musica_model.dart';
import '../screens/musica_details_screen.dart';
import 'equalizer_mini.dart';

class MusicaCard extends StatelessWidget {
  const MusicaCard({super.key, required this.musica});

  final MusicaModel musica;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MusicaDetailsScreen(musica: musica),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // borda lateral pontilhada
            SizedBox(
              width: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final dashCount = (c.maxHeight / 6).floor();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        dashCount,
                        (_) => Container(
                          width: 6,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppTheme.amber,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            musica.nomeMusica,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontFamily: 'Bricolage Grotesque',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            musica.nomeArtista ?? 'Artista',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontFamily: 'Hanken Grotesk',
color: Colors.black.withValues(alpha: 0.75),
                                ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.moss.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              musica.genero,
                              style: const TextStyle(
                                fontFamily: 'Space Mono',
                                color: AppTheme.moss,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const EqualizerMini(bars: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
