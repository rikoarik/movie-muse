import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_muse/app/router/app_routes.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';
import 'package:movie_muse/core/widgets/app_empty_state.dart';
import 'package:movie_muse/core/widgets/atmosphere_blob.dart';
import 'package:movie_muse/core/widgets/editorial_header.dart';
import 'package:movie_muse/core/widgets/movie_list_tile.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/saved/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:movie_muse/features/shell/presentation/viewmodels/shell_viewmodel.dart';
import 'package:provider/provider.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    final gutter = AppSpacing.horizontalGutter(context);
    final favoritesVm = context.watch<FavoritesViewModel>();
    final favorites = favoritesVm.favorites;
    final filmCountLabel =
        '${favorites.length} ${favorites.length == 1 ? 'film' : 'films'}';

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          const Positioned(
            top: -80,
            right: -40,
            child: AtmosphereBlob(
              size: 240,
              color: AppColors.lavender,
              alpha: 0.42,
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      gutter,
                      AppSpacing.lg,
                      gutter,
                      AppSpacing.md,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const EditorialHeader(
                            eyebrow: 'YOUR COLLECTION',
                            title: 'Saved for later.',
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: favorites.isEmpty
                                      ? AppColors.outline
                                      : AppColors.peachLight,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusPill,
                                  ),
                                ),
                                child: Text(
                                  filmCountLabel,
                                  style: AppTypography.label.copyWith(
                                    fontWeight: favorites.isEmpty
                                        ? FontWeight.w600
                                        : FontWeight.w700,
                                    color: favorites.isEmpty
                                        ? AppColors.muted
                                        : AppColors.plum,
                                  ),
                                ),
                              ),
                              if (favorites.isNotEmpty) ...[
                                const SizedBox(width: 10),
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Available offline',
                                  style: AppTypography.label.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (favoritesVm.storageWarning != null)
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        gutter,
                        0,
                        gutter,
                        AppSpacing.sm,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.errorSoft,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            favoritesVm.storageWarning!,
                            style: AppTypography.label.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (favoritesVm.isLoading && favorites.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.plum),
                      ),
                    )
                  else if (favorites.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: AppEmptyState(
                          icon: Icons.confirmation_number_outlined,
                          title: 'Your watchlist is empty.',
                          message: 'Save films you want to revisit anytime, even when you are offline.',
                          secondaryGlowColor: AppColors.butter,
                          showMiniHeart: true,
                          actionLabel: 'Explore movies',
                          onAction: () =>
                              context.read<ShellViewModel>().selectTab(0),
                        ),
                      ),
                    )
                  else ...[
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: gutter),
                      sliver: SliverList.separated(
                        itemCount: favorites.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final movie = favorites[index];
                          final heroTag = 'saved-${movie.imdbId}';
                          return MovieListTile(
                            movie: movie,
                            heroTag: heroTag,
                            isFavorite: true,
                            onTap: () => _openDetail(context, movie, heroTag),
                            onToggleFavorite: () =>
                                unawaited(favoritesVm.toggleFavorite(movie)),
                          );
                        },
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        gutter,
                        AppSpacing.lg,
                        gutter,
                        AppSpacing.xl,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Stored locally on your device  ·  Newest saved first',
                          textAlign: TextAlign.center,
                          style: AppTypography.label.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, MovieSummary movie, String heroTag) {
    unawaited(
      context.push(
        AppRoutes.movieDetailPath(movie.imdbId),
        extra: MovieDetailRouteExtra(summary: movie, heroTag: heroTag),
      ),
    );
  }
}
