import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_muse/app/router/app_routes.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';
import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/core/widgets/app_empty_state.dart';
import 'package:movie_muse/core/widgets/app_error_state.dart';
import 'package:movie_muse/core/widgets/editorial_header.dart';
import 'package:movie_muse/core/widgets/movie_list_tile.dart';
import 'package:movie_muse/core/widgets/movie_skeleton.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/saved/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:movie_muse/features/search/presentation/viewmodels/search_viewmodel.dart';
import 'package:movie_muse/features/search/presentation/widgets/search_pill.dart';
import 'package:movie_muse/features/shell/presentation/viewmodels/shell_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late final ShellViewModel _shellViewModel;
  int _lastFocusTrigger = 0;

  @override
  void initState() {
    super.initState();
    _shellViewModel = context.read<ShellViewModel>();
    _lastFocusTrigger = _shellViewModel.searchFocusTrigger;
    _shellViewModel.addListener(_onShellChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onShellChanged() {
    if (_shellViewModel.searchFocusTrigger != _lastFocusTrigger) {
      _lastFocusTrigger = _shellViewModel.searchFocusTrigger;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      unawaited(context.read<SearchViewModel>().loadMore());
    }
  }

  void _applySuggestion(String suggestion) {
    _controller.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
    unawaited(context.read<SearchViewModel>().submitSearch(suggestion));
  }

  void _clearSearch() {
    _controller.clear();
    context.read<SearchViewModel>().clear();
    _focusNode.requestFocus();
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
    _shellViewModel.removeListener(_onShellChanged);
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gutter = AppSpacing.horizontalGutter(context);
    final searchVm = context.watch<SearchViewModel>();
    final favoritesVm = context.watch<FavoritesViewModel>();

    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: CustomScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  gutter,
                  AppSpacing.lg,
                  gutter,
                  AppSpacing.md,
                ),
                sliver: const SliverToBoxAdapter(
                  child: EditorialHeader(
                    eyebrow: 'LIVE SEARCH',
                    title: 'Find a film.',
                    subtitle: 'Search by title.',
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                sliver: SliverToBoxAdapter(
                  child: SearchPill(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: searchVm.onQueryChanged,
                    onSubmitted: (value) =>
                        unawaited(searchVm.submitSearch(value)),
                    onClear: _clearSearch,
                  ),
                ),
              ),
              ..._buildStateSlivers(
                searchVm: searchVm,
                favoritesVm: favoritesVm,
                gutter: gutter,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStateSlivers({
    required SearchViewModel searchVm,
    required FavoritesViewModel favoritesVm,
    required double gutter,
  }) {
    switch (searchVm.status) {
      case SearchStatus.idle:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AppEmptyState(
                icon: Icons.movie_outlined,
                title: 'What are you in the\nmood for?',
                message: 'Type at least 2 characters to browse OMDb films live as you type.',
                footer: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final suggestion in EnvConfig.searchQuickSuggestions)
                      _SuggestionChip(
                        label: suggestion,
                        onTap: () => _applySuggestion(suggestion),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ];

      case SearchStatus.loading:
        return [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, 0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text('SEARCHING FILMS...', style: AppTypography.eyebrow),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            sliver: SliverList.separated(
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, index) {
                const widths = [
                  (0.68, 0.42),
                  (0.56, 0.36),
                  (0.74, 0.46),
                  (0.52, 0.34),
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

      case SearchStatus.results:
        return [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'RESULTS FOR “${searchVm.activeSearchedQuery.toUpperCase()}”',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.eyebrow,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
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
                      '${searchVm.totalResults} matches',
                      style: AppTypography.label.copyWith(
                        fontSize: 11,
                        color: AppColors.plum,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            sliver: SliverList.separated(
              itemCount: searchVm.results.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final movie = searchVm.results[index];
                final heroTag = 'search-${movie.imdbId}';
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
          if (searchVm.isLoadingMore)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, 0),
              sliver: const SliverToBoxAdapter(
                child: MovieSkeleton(
                  titleWidthFactor: 0.64,
                  subtitleWidthFactor: 0.38,
                ),
              ),
            ),
        ];

      case SearchStatus.empty:
        return [
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AppEmptyState(
                icon: Icons.search_off_rounded,
                title: 'No films found.',
                message: 'No films found. Try another title.',
              ),
            ),
          ),
        ];

      case SearchStatus.error:
        return [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              gutter,
              AppSpacing.xxl,
              gutter,
              AppSpacing.lg,
            ),
            sliver: SliverToBoxAdapter(
              child: AppErrorState(
                title: "Couldn't load films.",
                message: searchVm.errorMessage ?? 'Please check your internet connection and try searching again.',
                onRetry: () => unawaited(searchVm.retry()),
              ),
            ),
          ),
        ];

      case SearchStatus.missingApiKey:
        return [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              gutter,
              AppSpacing.xxl,
              gutter,
              AppSpacing.lg,
            ),
            sliver: SliverToBoxAdapter(
              child: AppErrorState(
                icon: Icons.key_off_rounded,
                title: "OMDb API key isn't configured.",
                message:
                    searchVm.errorMessage ??
                    'Run the app with --dart-define=OMDB_API_KEY=YOUR_KEY.',
              ),
            ),
          ),
        ];
    }
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search $label',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(color: AppColors.outline),
              boxShadow: AppColors.softShadow(
                offsetY: 4,
                blurRadius: 12,
                alpha: 0.04,
              ),
            ),
            child: Text(
              label,
              style: AppTypography.label.copyWith(color: AppColors.plum),
            ),
          ),
        ),
      ),
    );
  }
}
