import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class EqualizerMini extends StatelessWidget {
  const EqualizerMini({super.key, this.bars = 4});

  final int bars;

  @override
  Widget build(BuildContext context) {
    final barsCount = bars.clamp(3, 5);
    return SizedBox(
      width: 28,
      height: 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(barsCount, (i) {
          final height = [4.0, 7.0, 10.0, 14.0, 16.0][i];
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppTheme.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              height: height,
            ),
          );
        }),
      ),
    );
  }
}
