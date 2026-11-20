import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    required this.isFavorite,
    required this.movieTitle,
    required this.onPressed,
    this.elevatedWhite = false,
    super.key,
  });

  final bool isFavorite;
  final String movieTitle;
  final VoidCallback onPressed;
  final bool elevatedWhite;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  double _scale = 1;

  Future<void> _handleTap() async {
    widget.onPressed();
    if (MediaQuery.disableAnimationsOf(context)) {
      return;
    }
    setState(() => _scale = 0.90);
    await Future<void>.delayed(const Duration(milliseconds: 90));
    if (!mounted) {
      return;
    }
    setState(() => _scale = 1.07);
    await Future<void>.delayed(const Duration(milliseconds: 110));
    if (!mounted) {
      return;
    }
    setState(() => _scale = 1);
  }

  @override
  Widget build(BuildContext context) {
    final saved = widget.isFavorite;
    final backgroundColor = widget.elevatedWhite
        ? AppColors.surface
        : (saved ? AppColors.surfaceWarm : AppColors.canvas);
    final borderColor = widget.elevatedWhite
        ? AppColors.surface
        : (saved ? AppColors.peachLight : AppColors.outline);
    final iconColor = saved ? AppColors.peach : AppColors.plum;
    final semanticLabel = saved
        ? 'Remove ${widget.movieTitle} from favorites'
        : 'Save ${widget.movieTitle} to favorites';

    return Semantics(
      button: true,
      toggled: saved,
      label: semanticLabel,
      child: Tooltip(
        message: semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            customBorder: const CircleBorder(),
            child: AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: Container(
                width: AppSpacing.minTapTarget,
                height: AppSpacing.minTapTarget,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  border: Border.all(color: borderColor),
                  boxShadow: widget.elevatedWhite
                      ? AppColors.softShadow(blurRadius: 20, alpha: 0.09)
                      : null,
                ),
                alignment: Alignment.center,
                child: Icon(
                  saved
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 20,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
