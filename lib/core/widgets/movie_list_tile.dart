import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';
import 'package:movie_muse/core/widgets/favorite_button.dart';
import 'package:movie_muse/core/widgets/poster_image.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';

class MovieListTile extends StatelessWidget {
  const MovieListTile({
    required this.movie,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
    this.heroTag,
    super.key,
  });

  final MovieSummary movie;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open details for ${movie.title}',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusTile),
          border: Border.all(color: AppColors.outline),
          boxShadow: AppColors.softShadow(
            offsetY: 6,
            blurRadius: 20,
            alpha: 0.05,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusTile),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusTile),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
              child: Row(
                children: [
                  PosterImage(
                    posterUrl: movie.poster,
                    monogram: movie.monogram,
                    width: 58,
                    height: 87,
                    heroTag: heroTag,
                    shadows: AppColors.softShadow(
                      offsetY: 4,
                      blurRadius: 12,
                      alpha: 0.14,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleM.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          movie.subtitleMeta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  FavoriteButton(
                    isFavorite: isFavorite,
                    movieTitle: movie.title,
                    onPressed: onToggleFavorite,
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
