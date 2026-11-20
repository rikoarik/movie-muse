import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;

  static const double maxContentWidth = 520;
  static const double minTapTarget = 44;
  static const double bottomNavHeight = 76;

  static const double radiusFeature = 32;
  static const double radiusSheet = 36;
  static const double radiusCard = 24;
  static const double radiusTile = 22;
  static const double radiusPosterSm = 14;
  static const double radiusPosterLg = 22;
  static const double radiusSearchPill = 27;
  static const double radiusPill = 99;

  static double horizontalGutter(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width < 360 ? md : xl;
  }
}
