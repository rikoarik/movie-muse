import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';
import 'package:movie_muse/core/widgets/atmosphere_blob.dart';
import 'package:movie_muse/core/widgets/poster_image.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';

class FeaturedMovieCard extends StatelessWidget {
  const FeaturedMovieCard({
    required this.movie,
    required this.onTap,
    required this.heroTag,
    this.detail,
    super.key,
  });

  final MovieSummary movie;
  final MovieDetail? detail;
  final VoidCallback onTap;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final genrePreview = detail?.genreList.take(2).join(', ');
    final subtitleText = genrePreview != null && genrePreview.isNotEmpty
        ? '${movie.year}  ·  $genrePreview'
        : movie.subtitleMeta;

    return Semantics(
      button: true,
      label: 'Open featured film details for ${movie.title}',
      child: Container(
        height: 262,
        decoration: BoxDecoration(
          gradient: AppColors.featureGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFeature),
          boxShadow: AppColors.softShadow(
            offsetY: 14,
            blurRadius: 34,
            alpha: 0.10,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFeature),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Positioned(
                    left: -50,
                    top: -60,
                    child: AtmosphereBlob(
                      size: 210,
                      color: AppColors.butter,
                      alpha: 0.58,
                    ),
                  ),
                  const Positioned(
                    right: -20,
                    bottom: -40,
                    child: AtmosphereBlob(
                      size: 220,
                      color: AppColors.lavender,
                      alpha: 0.72,
                    ),
                  ),
                  Positioned(
                    left: 88,
                    top: 12,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface.withValues(alpha: 0.34),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    top: 26,
                    child: Transform.rotate(
                      angle: -0.07,
                      child: PosterImage(
                        posterUrl: movie.poster,
                        monogram: movie.monogram,
                        width: 128,
                        height: 192,
                        borderRadius: 18,
                        showBorder: true,
                        heroTag: heroTag,
                        shadows: AppColors.softShadow(
                          offsetY: 16,
                          blurRadius: 28,
                          alpha: 0.24,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    bottom: 18,
                    right: 130,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 168),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusCard,
                          ),
                          boxShadow: AppColors.softShadow(
                            offsetY: 12,
                            blurRadius: 26,
                            alpha: 0.10,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceWarm,
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusPill,
                                    ),
                                  ),
                                  child: Text(
                                    'FEATURED FILM',
                                    style: AppTypography.eyebrow.copyWith(
                                      fontSize: 9.5,
                                      letterSpacing: 0.9,
                                      color: AppColors.plum,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.titleL.copyWith(
                                    fontSize: 19,
                                    height: 1.16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  subtitleText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.muted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'View details',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.label.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.plum,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.peachLight,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.arrow_outward_rounded,
                                    size: 14,
                                    color: AppColors.plum,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
