import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';

class EditorialHeader extends StatelessWidget {
  const EditorialHeader({
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow, style: AppTypography.eyebrow),
              const SizedBox(height: AppSpacing.xxs),
              Text(title, style: AppTypography.display),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle!,
                  style: AppTypography.body.copyWith(color: AppColors.muted),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.sm),
          trailing!,
        ],
      ],
    );
  }
}
