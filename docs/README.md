# Movie Muse

Movie Muse is a Flutter app for browsing and searching OMDb, viewing film details, and saving favorites on-device. The [project README](../README.md) has setup instructions, APK downloads, and app screenshots.

## Required features

- Remote movie list (OMDb search)
- Detailed movie information by IMDb ID
- Live debounced search
- Save/remove favorites locally and retain them across launches
- MVVM with repository separation

## Technical choices

Flutter and Dart, Dio for OMDb requests, SharedPreferences for local favorites, Provider and ChangeNotifier for state, GetIt for dependency injection, and GoRouter for navigation.

## Architecture

Flutter widgets → ViewModels → use cases → repositories → data sources. See [ARCHITECTURE.md](ARCHITECTURE.md).

## Documentation

- [REQUIREMENTS.md](REQUIREMENTS.md) — scope, functional and nonfunctional acceptance
- [DESIGN.md](DESIGN.md) — colors, layout, screens, components and motion
- [ARCHITECTURE.md](ARCHITECTURE.md) — MVVM, models, state and persistence
- [API.md](API.md) — OMDb endpoints and response handling
- [TASKS.md](TASKS.md) — four-hour work plan
- [TEST_PLAN.md](TEST_PLAN.md) — automated/manual scenarios
- [DECISIONS.md](DECISIONS.md) — decisions and unresolved points

## Required submission

The coding test requests the compiled APK and repository link by email to `iam@andazlan.com`.
