import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reelora/core/viewmodel/base_view_model.dart';
import 'package:reelora/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:reelora/features/home/presentation/widgets/status_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeViewModel>().loadGreeting();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reelora')),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return switch (viewModel.state) {
            ViewState.initial || ViewState.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            ViewState.error => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      viewModel.errorMessage ?? 'Something went wrong.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: viewModel.loadGreeting,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            ViewState.loaded => Center(
              child: StatusCard(
                title: viewModel.greeting?.title ?? '',
                subtitle: viewModel.greeting?.subtitle ?? '',
                onRefresh: viewModel.loadGreeting,
              ),
            ),
          };
        },
      ),
    );
  }
}
