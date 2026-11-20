import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';

class SearchPill extends StatelessWidget {
  const SearchPill({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller, focusNode]),
      builder: (context, _) {
        final hasText = controller.text.isNotEmpty;
        final isFocused = focusNode.hasFocus;

        return Container(
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSearchPill),
            border: Border.all(
              color: isFocused
                  ? AppColors.peach.withValues(alpha: 0.8)
                  : AppColors.outline,
              width: 1.5,
            ),
            boxShadow: AppColors.softShadow(
              blurRadius: 22,
              alpha: isFocused ? 0.08 : 0.06,
            ),
          ),
          padding: const EdgeInsets.only(left: 18, right: 10),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20,
                color: isFocused || hasText ? AppColors.plum : AppColors.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    hintStyle: AppTypography.body.copyWith(
                      fontSize: 15,
                      color: AppColors.muted,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                ),
              ),
              if (hasText)
                Semantics(
                  button: true,
                  label: 'Clear search query',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClear,
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: AppSpacing.minTapTarget,
                        height: AppSpacing.minTapTarget,
                        child: Center(
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.canvas,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
