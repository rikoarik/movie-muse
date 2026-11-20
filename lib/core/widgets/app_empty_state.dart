import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';
import 'package:movie_muse/core/widgets/atmosphere_blob.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.secondaryGlowColor = AppColors.peachLight,
    this.showMiniHeart = false,
    this.actionLabel,
    this.onAction,
    this.footer,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color secondaryGlowColor;
  final bool showMiniHeart;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 170,
            height: 146,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                const Positioned(
                  left: 4,
                  top: 0,
                  child: AtmosphereBlob(
                    size: 132,
                    color: AppColors.lavender,
                    alpha: 0.72,
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 4,
                  child: AtmosphereBlob(
                    size: 108,
                    color: secondaryGlowColor,
                    alpha: 0.85,
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: AppColors.outline),
                    boxShadow: AppColors.softShadow(
                      offsetY: 12,
                      blurRadius: 28,
                      alpha: 0.08,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 30, color: AppColors.plum),
                ),
                if (showMiniHeart)
                  Positioned(
                    right: 34,
                    top: 22,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceWarm,
                        border: Border.all(color: AppColors.surface, width: 2),
                        boxShadow: AppColors.softShadow(
                          offsetY: 4,
                          blurRadius: 12,
                          alpha: 0.10,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 14,
                        color: AppColors.peach,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, textAlign: TextAlign.center, style: AppTypography.titleL),
          const SizedBox(height: AppSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 290),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.muted),
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            footer!,
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
