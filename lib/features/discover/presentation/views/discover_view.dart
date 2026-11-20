import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_muse/app/router/app_routes.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';
import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/core/viewmodel/base_view_model.dart';
import 'package:movie_muse/core/widgets/app_empty_state.dart';
import 'package:movie_muse/core/widgets/app_error_state.dart';
import 'package:movie_muse/core/widgets/atmosphere_blob.dart';
import 'package:movie_muse/core/widgets/editorial_header.dart';
import 'package:movie_muse/core/widgets/movie_list_tile.dart';
import 'package:movie_muse/core/widgets/movie_skeleton.dart';
import 'package:movie_muse/features/discover/presentation/viewmodels/discover_viewmodel.dart';
import 'package:movie_muse/features/discover/presentation/widgets/featured_movie_card.dart';
import 'package:movie_muse/features/discover/presentation/widgets/query_chip.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/saved/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:movie_muse/features/shell/presentation/viewmodels/shell_viewmodel.dart';
import 'package:provider/provider.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(context.read<DiscoverViewModel>().initializeIfNeeded());
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      unawaited(context.read<DiscoverViewModel>().loadMore());
    }
  }

  void _onChipSelected(String query) {
    unawaited(context.read<DiscoverViewModel>().selectQuery(query));
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _openDetail(MovieSummary movie, String heroTag) {
    unawaited(
      context.push(
        AppRoutes.movieDetailPath(movie.imdbId),
        extra: MovieDetailRouteExtra(summary: movie, heroTag: heroTag),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gutter = AppSpacing.horizontalGutter(context);
    final discoverVm = context.watch<DiscoverViewModel>();
    final favoritesVm = context.watch<FavoritesViewModel>();

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          const Positioned(
            top: -84,
            right: -48,
            child: AtmosphereBlob(size: 240, color: AppColors.peachLight),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: RefreshIndicator(
                color: AppColors.plum,
                backgroundColor: AppColors.surface,
                onRefresh: discoverVm.loadMovies,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        gutter,
                        AppSpacing.lg,
                        gutter,
                        AppSpacing.md,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: EditorialHeader(
                          eyebrow: 'MOVIE MUSE  ·  DISCOVER',
                          title: 'A good film\nstarts here.',
                          trailing: _SearchActionCircle(
                            onTap: context
                                .read<ShellViewModel>()
                                .openSearchAndFocus,
                          ),
                        ),
                      ),
                    ),
                    if (discoverVm.state == ViewState.loaded &&
                        discoverVm.featuredMovie != null)
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: gutter),
                        sliver: SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xl,
                            ),
                            child: FeaturedMovieCard(
                              movie: discoverVm.featuredMovie!,
                              detail: discoverVm.featuredDetail,
                              heroTag:
                                  'featured-${discoverVm.featuredMovie!.imdbId}',
                              onTap: () => _openDetail(
                                discoverVm.featuredMovie!,
                                'featured-${discoverVm.featuredMovie!.imdbId}',
                              ),
                            ),
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: gutter),
                      sliver: SliverToBoxAdapter(
                        child: _ExploreSectionHeader(
                          activeQuery: discoverVm.activeQuery,
                          onSelectQuery: _onChipSelected,
                        ),
                      ),
                    ),
                    ..._buildBodySlivers(
                      discoverVm: discoverVm,
                      favoritesVm: favoritesVm,
                      gutter: gutter,
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.xl),
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

  List<Widget> _buildBodySlivers({
    required DiscoverViewModel discoverVm,
    required FavoritesViewModel favoritesVm,
    required double gutter,
  }) {
    if (discoverVm.state == ViewState.initial ||
        discoverVm.state == ViewState.loading) {
      return [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.md, gutter, 0),
          sliver: SliverList.separated(
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, index) {
              const widths = [
                (0.72, 0.44),
                (0.58, 0.36),
                (0.78, 0.48),
                (0.62, 0.40),
              ];
              final (titleFactor, subFactor) = widths[index % widths.length];
              return MovieSkeleton(
                titleWidthFactor: titleFactor,
                subtitleWidthFactor: subFactor,
              );
            },
          ),
        ),
      ];
    }

    if (discoverVm.state == ViewState.error) {
      final isKeyIssue = discoverVm.isMissingApiKey;
      return [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            gutter,
            AppSpacing.lg,
            gutter,
            AppSpacing.lg,
          ),
          sliver: SliverToBoxAdapter(
            child: AppErrorState(
              icon: isKeyIssue ? Icons.key_off_rounded : Icons.wifi_off_rounded,
              title: isKeyIssue
                  ? "OMDb API key isn't configured."
                  : "Couldn't load films.",
              message:
                  discoverVm.errorMessage ??
                  'Please check your internet connection and try again.',
              onRetry: isKeyIssue ? null : discoverVm.loadMovies,
            ),
          ),
        ),
      ];
    }

    final movies = discoverVm.listMovies;
    if (movies.isEmpty) {
      return [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          sliver: SliverToBoxAdapter(
            child: AppEmptyState(
              icon: Icons.movie_outlined,
              title: 'No films found.',
              message: 'Try choosing another keyword chip or search by title in Search.',
              actionLabel: 'Reload Batman',
              onAction: () => _onChipSelected(EnvConfig.defaultDiscoverQuery),
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.fromLTRB(gutter, AppSpacing.md, gutter, 0),
        sliver: SliverList.separated(
          itemCount: movies.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final movie = movies[index];
            final heroTag = 'discover-${movie.imdbId}';
            return MovieListTile(
              movie: movie,
              heroTag: heroTag,
              isFavorite: favoritesVm.isFavorite(movie.imdbId),
              onTap: () => _openDetail(movie, heroTag),
              onToggleFavorite: () =>
                  unawaited(favoritesVm.toggleFavorite(movie)),
            );
          },
        ),
      ),
      if (discoverVm.isLoadingMore)
        SliverPadding(
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, 0),
          sliver: const SliverToBoxAdapter(
            child: MovieSkeleton(
              titleWidthFactor: 0.65,
              subtitleWidthFactor: 0.38,
            ),
          ),
        ),
    ];
  }
}

class _SearchActionCircle extends StatelessWidget {
  const _SearchActionCircle({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Go to search films',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: AppSpacing.minTapTarget,
            height: AppSpacing.minTapTarget,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.outline),
              boxShadow: AppColors.softShadow(
                offsetY: 6,
                blurRadius: 16,
                alpha: 0.07,
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.search_rounded,
              size: 20,
              color: AppColors.plum,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreSectionHeader extends StatelessWidget {
  const _ExploreSectionHeader({
    required this.activeQuery,
    required this.onSelectQuery,
  });

  final String activeQuery;
  final ValueChanged<String> onSelectQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Explore films',
                style: AppTypography.titleL.copyWith(fontSize: 22),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              child: Text(
                'Discover: $activeQuery',
                style: AppTypography.label.copyWith(
                  fontSize: 11,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Pick a story for tonight.',
          style: AppTypography.body.copyWith(
            fontSize: 13,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (
                var i = 0;
                i < EnvConfig.discoverQuickQueries.length;
                i++
              ) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                QueryChip(
                  label: EnvConfig.discoverQuickQueries[i],
                  isSelected: EnvConfig.discoverQuickQueries[i] == activeQuery,
                  onTap: () => onSelectQuery(EnvConfig.discoverQuickQueries[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
