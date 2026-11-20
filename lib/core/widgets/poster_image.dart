import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({
    required this.posterUrl,
    required this.monogram,
    this.width,
    this.height,
    this.borderRadius = AppSpacing.radiusPosterSm,
    this.heroTag,
    this.showBorder = false,
    this.borderWidth = 2,
    this.shadows,
    super.key,
  });

  final String? posterUrl;
  final String monogram;
  final double? width;
  final double? height;
  final double borderRadius;
  final String? heroTag;
  final bool showBorder;
  final double borderWidth;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final validUrl = _normalizedUrl(posterUrl);
    final radius = BorderRadius.circular(borderRadius);

    Widget content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: shadows,
        border: showBorder
            ? Border.all(color: AppColors.surface, width: borderWidth)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          showBorder
              ? (borderRadius - borderWidth).clamp(0, 100)
              : borderRadius,
        ),
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: validUrl == null
              ? _PosterFallback(monogram: monogram)
              : Image.network(
                  validUrl,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return child;
                        }
                        return const ColoredBox(color: AppColors.placeholder);
                      },
                  errorBuilder: (context, error, stackTrace) {
                    return _PosterFallback(monogram: monogram);
                  },
                ),
        ),
      ),
    );

    if (heroTag != null && validUrl != null) {
      content = Hero(tag: heroTag!, child: content);
    }

    return content;
  }

  String? _normalizedUrl(String? url) {
    final trimmed = url?.trim();
    if (trimmed == null || trimmed.isEmpty || trimmed.toUpperCase() == 'N/A') {
      return null;
    }
    return trimmed;
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.monogram});

  final String monogram;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.posterFallbackGradient,
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie_outlined, size: 18, color: AppColors.muted),
          const SizedBox(height: 4),
          Text(
            monogram,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.plum,
            ),
          ),
        ],
      ),
    );
  }
}
