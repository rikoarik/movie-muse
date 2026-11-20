import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';
import 'package:movie_muse/core/widgets/atmosphere_blob.dart';
import 'package:movie_muse/core/widgets/favorite_button.dart';
import 'package:movie_muse/core/widgets/poster_image.dart';

class DetailParallaxBackdrop extends StatelessWidget {
  const DetailParallaxBackdrop({
    required this.scrollOffsetListenable,
    super.key,
  });

  final ValueListenable<double> scrollOffsetListenable;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final baseHeight = topPadding + 308;

    return ValueListenableBuilder<double>(
      valueListenable: scrollOffsetListenable,
      builder: (context, rawOffset, _) {
        final offset = disableAnimations ? 0.0 : rawOffset;
        final stretch = offset < 0 ? (-offset * 0.7).clamp(0.0, 140.0) : 0.0;
        final shiftY = offset > 0 ? -(offset * 0.36).clamp(0.0, 140.0) : 0.0;
        final lavenderShift = offset > 0
            ? -(offset * 0.24).clamp(0.0, 96.0)
            : -stretch * 0.2;
        final peachShift = offset > 0
            ? -(offset * 0.48).clamp(0.0, 150.0)
            : stretch * 0.15;
        final haloScale = offset > 0
            ? (1.0 - (offset / 260) * 0.14).clamp(0.86, 1.0)
            : (1.0 + (-offset / 360) * 0.06).clamp(1.0, 1.06);
        final haloOpacity = offset > 0
            ? (1.0 - (offset / 180)).clamp(0.0, 1.0)
            : 1.0;

        return Transform.translate(
          offset: Offset(0, shiftY),
          child: SizedBox(
            height: baseHeight + stretch,
            width: double.infinity,
            child: ClipRect(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppColors.detailBackdropGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: -70,
                      top: -40 + lavenderShift,
                      child: const AtmosphereBlob(
                        size: 260,
                        color: AppColors.lavender,
                        alpha: 0.85,
                      ),
                    ),
                    Positioned(
                      right: -50,
                      top: -30 + peachShift,
                      child: const AtmosphereBlob(
                        size: 240,
                        color: AppColors.peach,
                        alpha: 0.42,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: topPadding + 42 + stretch * 0.35,
                      child: Center(
                        child: Opacity(
                          opacity: haloOpacity,
                          child: Transform.scale(
                            scale: haloScale,
                            child: Container(
                              width: 232,
                              height: 232,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surface.withValues(
                                  alpha: 0.28,
                                ),
                                border: Border.all(
                                  color: AppColors.surface.withValues(
                                    alpha: 0.55,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailPosterHero extends StatelessWidget {
  const DetailPosterHero({
    required this.scrollOffsetListenable,
    required this.posterUrl,
    required this.monogram,
    this.imdbRating,
    this.heroTag,
    super.key,
  });

  final ValueListenable<double> scrollOffsetListenable;
  final String? posterUrl;
  final String monogram;
  final String? imdbRating;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final stageHeight = topPadding + 308;

    return SizedBox(
      height: stageHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 92,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusSheet),
                ),
                boxShadow: AppColors.softShadow(
                  offsetY: -10,
                  blurRadius: 28,
                  alpha: 0.08,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: topPadding + 56,
            child: ValueListenableBuilder<double>(
              valueListenable: scrollOffsetListenable,
              builder: (context, rawOffset, child) {
                final offset = disableAnimations ? 0.0 : rawOffset;
                final translateY = offset > 0
                    ? (offset * 0.26).clamp(0.0, 70.0)
                    : (offset * 0.14).clamp(-20.0, 0.0);
                final scale = offset > 0
                    ? (1.0 - (offset / 320) * 0.10).clamp(0.90, 1.0)
                    : (1.0 + (-offset / 400) * 0.05).clamp(1.0, 1.05);
                final opacity = offset > 0
                    ? (1.0 - (offset / 280) * 0.30).clamp(0.70, 1.0)
                    : 1.0;

                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, translateY),
                    child: Transform.scale(scale: scale, child: child),
                  ),
                );
              },
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    PosterImage(
                      posterUrl: posterUrl,
                      monogram: monogram,
                      width: 156,
                      height: 234,
                      borderRadius: AppSpacing.radiusPosterLg,
                      showBorder: true,
                      borderWidth: 3,
                      heroTag: heroTag,
                      shadows: AppColors.softShadow(
                        offsetY: 16,
                        blurRadius: 36,
                        alpha: 0.22,
                      ),
                    ),
                    if (imdbRating != null)
                      Positioned(
                        right: -14,
                        bottom: -8,
                        child: _FloatingRatingBadge(rating: imdbRating!),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTopActionBar extends StatelessWidget {
  const DetailTopActionBar({
    required this.scrollOffsetListenable,
    required this.movieTitle,
    required this.isFavorite,
    required this.onBack,
    this.onToggleFavorite,
    super.key,
  });

  final ValueListenable<double> scrollOffsetListenable;
  final String movieTitle;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final gutter = AppSpacing.horizontalGutter(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return ValueListenableBuilder<double>(
      valueListenable: scrollOffsetListenable,
      builder: (context, rawOffset, child) {
        final offset = disableAnimations ? 0.0 : rawOffset;
        final barOpacity = ((offset - 120) / 90).clamp(0.0, 1.0);

        return Container(
          padding: EdgeInsets.fromLTRB(gutter, topPadding + 12, gutter, 10),
          decoration: BoxDecoration(
            color: AppColors.canvas.withValues(alpha: barOpacity * 0.94),
            border: Border(
              bottom: BorderSide(
                color: AppColors.outline.withValues(alpha: barOpacity),
              ),
            ),
          ),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BackPillButton(onTap: onBack),
          if (onToggleFavorite != null)
            FavoriteButton(
              isFavorite: isFavorite,
              movieTitle: movieTitle,
              elevatedWhite: true,
              onPressed: onToggleFavorite!,
            )
          else
            const SizedBox(width: AppSpacing.minTapTarget),
        ],
      ),
    );
  }
}

class _BackPillButton extends StatelessWidget {
  const _BackPillButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Go back',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: Container(
            height: AppSpacing.minTapTarget,
            padding: const EdgeInsets.only(left: 14, right: 18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              boxShadow: AppColors.softShadow(blurRadius: 20, alpha: 0.09),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                  color: AppColors.plum,
                ),
                const SizedBox(width: 8),
                Text(
                  'BACK',
                  style: AppTypography.eyebrow.copyWith(
                    color: AppColors.plum,
                    letterSpacing: 0.9,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingRatingBadge extends StatelessWidget {
  const _FloatingRatingBadge({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'IMDb rating $rating',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          gradient: AppColors.ratingBadgeGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: AppColors.surface, width: 3),
          boxShadow: AppColors.softShadow(blurRadius: 18, alpha: 0.14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 15, color: AppColors.plum),
            const SizedBox(width: 4),
            Text(
              rating,
              style: AppTypography.label.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.plum,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
