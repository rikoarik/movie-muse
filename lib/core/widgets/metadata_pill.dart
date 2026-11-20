import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';

class MetadataPill extends StatelessWidget {
  const MetadataPill({
    required this.label,
    this.icon,
    this.iconColor = AppColors.peach,
    this.warm = false,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color iconColor;
  final bool warm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: warm ? AppColors.surfaceWarm : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(
          color: warm ? AppColors.peachLight : AppColors.outline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: AppTypography.label.copyWith(color: AppColors.plum),
          ),
        ],
      ),
    );
  }
}
