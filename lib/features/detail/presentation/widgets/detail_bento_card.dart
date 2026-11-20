import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';

class DetailBentoCard extends StatelessWidget {
  const DetailBentoCard({
    required this.eyebrow,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.badgeColor,
    super.key,
  });

  const DetailBentoCard.peach({
    required this.eyebrow,
    required this.value,
    required this.icon,
    super.key,
  }) : backgroundColor = AppColors.surfaceWarmSoft,
       borderColor = AppColors.peachLight,
       badgeColor = AppColors.peachLight;

  const DetailBentoCard.lavender({
    required this.eyebrow,
    required this.value,
    required this.icon,
    super.key,
  }) : backgroundColor = AppColors.lavenderSoft,
       borderColor = AppColors.lavenderLight,
       badgeColor = AppColors.lavenderLight;

  final String eyebrow;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: borderColor),
        boxShadow: AppColors.softShadow(
          offsetY: 6,
          blurRadius: 18,
          alpha: 0.04,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                eyebrow,
                style: AppTypography.eyebrow.copyWith(fontSize: 10),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badgeColor,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 13, color: AppColors.plum),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.titleM.copyWith(fontSize: 14.5, height: 1.32),
          ),
        ],
      ),
    );
  }
}
