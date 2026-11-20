import 'package:flutter/material.dart';
import 'package:movie_muse/features/discover/presentation/views/discover_view.dart';
import 'package:movie_muse/features/saved/presentation/views/saved_view.dart';
import 'package:movie_muse/features/search/presentation/views/search_view.dart';
import 'package:movie_muse/features/shell/presentation/viewmodels/shell_viewmodel.dart';
import 'package:movie_muse/features/shell/presentation/widgets/movie_muse_bottom_nav.dart';
import 'package:provider/provider.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<ShellViewModel, int>(
      (vm) => vm.currentIndex,
    );

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [DiscoverView(), SearchView(), SavedView()],
      ),
      bottomNavigationBar: MovieMuseBottomNav(
        currentIndex: currentIndex,
        onSelect: context.read<ShellViewModel>().selectTab,
      ),
    );
  }
}
