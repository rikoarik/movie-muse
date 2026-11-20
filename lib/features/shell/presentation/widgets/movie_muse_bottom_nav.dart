import 'package:flutter/material.dart';
import 'package:movie_muse/app/theme/app_colors.dart';
import 'package:movie_muse/app/theme/app_spacing.dart';
import 'package:movie_muse/app/theme/app_typography.dart';

class MovieMuseBottomNav extends StatelessWidget {
  const MovieMuseBottomNav({
    required this.currentIndex,
    required this.onSelect,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.outline)),
        boxShadow: AppColors.softShadow(
          offsetY: -6,
          blurRadius: 20,
          alpha: 0.05,
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: SizedBox(
              height: AppSpacing.bottomNavHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    label: 'Discover',
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore_rounded,
                    isSelected: currentIndex == 0,
                    onTap: () => onSelect(0),
                  ),
                  _NavItem(
                    label: 'Search',
                    icon: Icons.search_rounded,
                    activeIcon: Icons.search_rounded,
                    isSelected: currentIndex == 1,
                    onTap: () => onSelect(1),
                  ),
                  _NavItem(
                    label: 'Saved',
                    icon: Icons.favorite_border_rounded,
                    activeIcon: Icons.favorite_rounded,
                    isSelected: currentIndex == 2,
                    onTap: () => onSelect(2),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.plum : AppColors.muted;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusTile),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: disableAnimations
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: 54,
                height: 30,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surfaceWarm
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isSelected ? activeIcon : icon,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.label.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
