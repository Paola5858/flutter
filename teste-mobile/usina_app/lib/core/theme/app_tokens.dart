import 'package:flutter/material.dart';

abstract final class AppColors {
  static const mineral = Color(0xff0d1211);
  static const mineralRaised = Color(0xff17231d);
  static const mineralSoft = Color(0xff22362b);
  static const surface = Color(0xff1b2822);
  static const ink = Color(0xffedf3ea);
  static const inkMuted = Color(0xffaab8ae);
  static const moss = Color(0xffa8c997);
  static const mossStrong = Color(0xff6d976e);
  static const amber = Color(0xffe4b86a);
  static const critical = Color(0xffe58d86);
  static const positive = Color(0xff8ed3a4);
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const section = 48.0;
  static const page = 64.0;
}

abstract final class AppRadii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
}

abstract final class AppShadows {
  static const surface = [
    BoxShadow(color: Color(0x55000000), blurRadius: 24, offset: Offset(0, 12)),
  ];
}

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 180);
  static const standard = Duration(milliseconds: 260);
  static const page = Duration(milliseconds: 320);
}
