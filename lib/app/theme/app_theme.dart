import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.peach,
      surface: AppColors.surface,
      onSurface: AppColors.plum,
      primary: AppColors.plum,
      onPrimary: AppColors.surface,
      secondary: AppColors.peach,
      onSecondary: AppColors.plum,
      tertiary: AppColors.lavender,
      onTertiary: AppColors.plum,
      error: AppColors.error,
      onError: AppColors.surface,
      outline: AppColors.outline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: AppTypography.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        foregroundColor: AppColors.plum,
      ),
      dividerColor: AppColors.hairline,
      splashFactory: InkSparkle.splashFactory,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.plum,
          foregroundColor: AppColors.surface,
          minimumSize: const Size(44, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: AppTypography.label.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.peach,
        selectionColor: AppColors.peachLight.withValues(alpha: 0.7),
        selectionHandleColor: AppColors.peach,
      ),
    );
  }
}
