import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

class AppSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool blur;

  const AppSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadii.xl)),
    this.blur = true,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .105),
            Colors.white.withValues(alpha: .035),
          ],
        ),
        borderRadius: borderRadius,
        border: Border.all(color: Colors.white.withValues(alpha: .12)),
      ),
      child: child,
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: blur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 17, sigmaY: 17),
              child: surface,
            )
          : surface,
    );
  }
}
