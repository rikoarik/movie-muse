import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';
import 'package:movie_muse/core/viewmodel/base_view_model.dart';
import 'package:movie_muse/core/widgets/app_error_state.dart';
import 'package:movie_muse/core/widgets/metadata_pill.dart';
import 'package:movie_muse/features/detail/presentation/viewmodels/movie_detail_viewmodel.dart';
import 'package:movie_muse/features/detail/presentation/widgets/detail_bento_card.dart';
import 'package:movie_muse/features/detail/presentation/widgets/detail_poster_stage.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_muse/features/saved/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:provider/provider.dart';

class MovieDetailView extends StatefulWidget {
  const MovieDetailView({this.heroTag, super.key});

  final String? heroTag;

  @override
  State<MovieDetailView> createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(context.read<MovieDetailViewModel>().loadDetail());
      }
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      _scrollOffset.value = _scrollController.offset;
    }
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailVm = context.watch<MovieDetailViewModel>();
    final favoritesVm = context.watch<FavoritesViewModel>();
    final gutter = AppSpacing.horizontalGutter(context);
    final isFavorite = favoritesVm.isFavorite(detailVm.imdbId);
    final payload = detailVm.favoritePayload;
    final topPadding = MediaQuery.paddingOf(context).top;
    final minSheetHeight =
        (MediaQuery.sizeOf(context).height - (topPadding + 308)).clamp(
          320.0,
          2000.0,
        );

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: DetailParallaxBackdrop(
                scrollOffsetListenable: _scrollOffset,
              ),
            ),
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: [
                  DetailPosterHero(
                    scrollOffsetListenable: _scrollOffset,
                    posterUrl: detailVm.displayPoster,
                    monogram: detailVm.displayMonogram,
                    imdbRating: detailVm.detail?.imdbRating,
                    heroTag: widget.heroTag,
                  ),
                  Container(
                    width: double.infinity,
                    color: AppColors.canvas,
                    constraints: BoxConstraints(minHeight: minSheetHeight),
                    padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppSpacing.maxContentWidth,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: gutter),
                          child: _buildSheetContent(
                            detailVm: detailVm,
                            isFavorite: isFavorite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: DetailTopActionBar(
                scrollOffsetListenable: _scrollOffset,
                movieTitle: detailVm.displayTitle,
                isFavorite: isFavorite,
                onBack: _handleBack,
                onToggleFavorite: payload == null
                    ? null
                    : () => unawaited(favoritesVm.toggleFavorite(payload)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetContent({
    required MovieDetailViewModel detailVm,
    required bool isFavorite,
  }) {
    final detail = detailVm.detail;
    final genres = detail?.genreList ?? const <String>[];
    final hasAnyHeaderTitle = detail != null || detailVm.initialSummary != null;

    if (!hasAnyHeaderTitle && detailVm.state == ViewState.error) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: AppErrorState(
          icon: detailVm.isMissingApiKey
              ? Icons.key_off_rounded
              : Icons.wifi_off_rounded,
          title: detailVm.isMissingApiKey
              ? "OMDb API key isn't configured."
              : "Couldn't load film details.",
          message:
              detailVm.errorMessage ??
              'Please check your internet connection and try again.',
          onRetry: detailVm.isMissingApiKey ? null : detailVm.loadDetail,
        ),
      );
    }

    return Column(
      children: [
        _SmoothSectionReveal(
          duration: const Duration(milliseconds: 260),
          child: Column(
            children: [
              if (genres.isNotEmpty) ...[
                Text(
                  genres.map((g) => g.toUpperCase()).join('  ·  '),
                  textAlign: TextAlign.center,
                  style: AppTypography.eyebrow.copyWith(fontSize: 10.5),
                ),
                const SizedBox(height: 6),
              ],
              Text(
                detailVm.displayTitle,
                textAlign: TextAlign.center,
                style: AppTypography.titleXL,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  if (detailVm.displayYear.isNotEmpty)
                    MetadataPill(label: detailVm.displayYear),
                  if (detail?.runtime != null)
                    MetadataPill(label: detail!.runtime!),
                  if (isFavorite)
                    const MetadataPill(
                      label: 'Saved',
                      icon: Icons.favorite_rounded,
                      warm: true,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (detailVm.state == ViewState.loading && detail == null)
          const _DetailLoadingCards()
        else if (detailVm.state == ViewState.error &&
            detailVm.hasFallbackSummary)
          _OfflineFallbackNotice(
            isMissingKey: detailVm.isMissingApiKey,
            message:
                detailVm.errorMessage ??
                'Extended details are unavailable offline.',
            onRetry: detailVm.isMissingApiKey ? null : detailVm.loadDetail,
          )
        else if (detail != null)
          _LoadedDetailSections(detail: detail),
      ],
    );
  }
}

class _SmoothSectionReveal extends StatelessWidget {
  const _SmoothSectionReveal({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, progress, animatedChild) {
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, (1 - progress) * 14),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}

class _LoadedDetailSections extends StatelessWidget {
  const _LoadedDetailSections({required this.detail});

  final MovieDetail detail;

  @override
  Widget build(BuildContext context) {
    final cast = detail.castList;
    final hasDirector = detail.director != null;
    final hasReleased = detail.released != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (detail.plot != null) ...[
          _SmoothSectionReveal(child: _StoryCard(plot: detail.plot!)),
          const SizedBox(height: AppSpacing.md),
        ],
        if (hasDirector || hasReleased) ...[
          _SmoothSectionReveal(
            duration: const Duration(milliseconds: 340),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasDirector)
                  Expanded(
                    child: DetailBentoCard.peach(
                      eyebrow: 'DIRECTOR',
                      value: detail.director!,
                      icon: Icons.movie_creation_outlined,
                    ),
                  ),
                if (hasDirector && hasReleased)
                  const SizedBox(width: AppSpacing.sm),
                if (hasReleased)
                  Expanded(
                    child: DetailBentoCard.lavender(
                      eyebrow: 'RELEASED',
                      value: detail.released!,
                      icon: Icons.calendar_today_outlined,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (cast.isNotEmpty)
          _SmoothSectionReveal(
            duration: const Duration(milliseconds: 380),
            child: _CastCard(cast: cast),
          ),
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.plot});

  final String plot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outline),
        boxShadow: AppColors.softShadow(alpha: 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.peach,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'THE STORY',
                style: AppTypography.eyebrow.copyWith(fontSize: 10.5),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(plot, style: AppTypography.body),
        ],
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.cast});

  final List<String> cast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outline),
        boxShadow: AppColors.softShadow(
          offsetY: 6,
          blurRadius: 18,
          alpha: 0.04,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STARRING CAST',
            style: AppTypography.eyebrow.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final actor in cast)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Text(
                    actor,
                    style: AppTypography.label.copyWith(color: AppColors.plum),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailLoadingCards extends StatelessWidget {
  const _DetailLoadingCards();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outline),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBar(widthFactor: 0.32, height: 11),
          SizedBox(height: 12),
          _SkeletonBar(widthFactor: 0.96, height: 14),
          SizedBox(height: 8),
          _SkeletonBar(widthFactor: 0.88, height: 14),
          SizedBox(height: 8),
          _SkeletonBar(widthFactor: 0.68, height: 14),
        ],
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.widthFactor, required this.height});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.placeholder,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _OfflineFallbackNotice extends StatelessWidget {
  const _OfflineFallbackNotice({
    required this.isMissingKey,
    required this.message,
    this.onRetry,
  });

  final bool isMissingKey;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppErrorState(
      icon: isMissingKey ? Icons.key_off_rounded : Icons.cloud_off_rounded,
      title: isMissingKey
          ? "OMDb API key isn't configured."
          : 'Extended details unavailable',
      message: isMissingKey
          ? message
          : '$message Showing your locally saved film summary.',
      onRetry: onRetry,
    );
  }
}
