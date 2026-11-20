import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_muse/app/theme/app_colors.dart';

abstract final class AppTypography {
  static TextStyle get display => GoogleFonts.plusJakartaSans(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.10,
    color: AppColors.plum,
  );

  static TextStyle get titleXL => GoogleFonts.plusJakartaSans(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.12,
    color: AppColors.plum,
  );

  static TextStyle get titleL => GoogleFonts.plusJakartaSans(
    fontSize: 23,
    fontWeight: FontWeight.w700,
    height: 1.20,
    color: AppColors.plum,
  );

  static TextStyle get titleM => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.30,
    color: AppColors.plum,
  );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
    color: AppColors.plum,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.55,
    color: AppColors.plum,
  );

  static TextStyle get label => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.30,
    color: AppColors.plum,
  );

  static TextStyle get eyebrow => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.20,
    letterSpacing: 1.1,
    color: AppColors.muted,
  );

  static TextTheme get textTheme {
    final baseBody = body;
    final smallLabel = label.copyWith(color: AppColors.muted);
    return TextTheme(
      displayLarge: display,
      displayMedium: display,
      displaySmall: display,
      headlineLarge: titleXL,
      headlineMedium: titleL,
      headlineSmall: titleL,
      titleLarge: titleL,
      titleMedium: titleM,
      titleSmall: label,
      bodyLarge: baseBody,
      bodyMedium: baseBody,
      bodySmall: smallLabel,
      labelLarge: label,
      labelMedium: label,
      labelSmall: eyebrow,
    );
  }
}
