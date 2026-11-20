import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color canvas = Color(0xFFFAF8F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceWarm = Color(0xFFFFF3EC);
  static const Color surfaceWarmSoft = Color(0xFFFFF6F0);

  static const Color peach = Color(0xFFFF9C62);
  static const Color peachLight = Color(0xFFFFE3CF);
  static const Color peachGlow = Color(0xFFFFB88E);

  static const Color lavender = Color(0xFFD9C9ED);
  static const Color lavenderSoft = Color(0xFFF6F1FC);
  static const Color lavenderLight = Color(0xFFE4D5F1);
  static const Color lavenderDeep = Color(0xFFAC91CC);

  static const Color butter = Color(0xFFFFE4A8);
  static const Color plum = Color(0xFF392B3D);
  static const Color muted = Color(0xFF7C727D);
  static const Color outline = Color(0xFFEDE6EB);
  static const Color hairline = Color(0xFFF4EFF2);

  static const Color success = Color(0xFF256E57);
  static const Color error = Color(0xFFB42337);
  static const Color errorSoft = Color(0xFFFBEAED);

  static const Color placeholder = Color(0xFFEDE7EB);
  static const Color placeholderSubtle = Color(0xFFF5F1F4);

  static const LinearGradient featureGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE8C9), Color(0xFFFFAE83), Color(0xFFE4D5F1)],
    stops: [0.0, 0.56, 1.0],
  );

  static const LinearGradient detailBackdropGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEFE4FA), Color(0xFFFFE5CA), Color(0xFFFFB88E)],
    stops: [0.0, 0.45, 1.0],
  );

  static const LinearGradient ratingBadgeGradient = LinearGradient(
    colors: [Color(0xFFFFE4A8), Color(0xFFFFAE7E)],
  );

  static const LinearGradient posterFallbackGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEFE7F6), Color(0xFFFFE8DA)],
  );

  static List<BoxShadow> softShadow({
    double offsetY = 8,
    double blurRadius = 24,
    double alpha = 0.06,
  }) {
    return [
      BoxShadow(
        color: plum.withValues(alpha: alpha),
        offset: Offset(0, offsetY),
        blurRadius: blurRadius,
      ),
    ];
  }
}
