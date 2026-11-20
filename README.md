# Reelora

Flutter movie-discovery application built with **MVVM + Clean Architecture** and the **Soft Editorial Cinema** design system.

## Features

- **Discover** — Curated featured film hero, quick keyword chips (`Batman`, `Star Wars`, `Love`, `Comedy`), pull-to-refresh, and infinite-scroll OMDb listing.
- **Movie Details** — Atmospheric peach/lavender backdrop with overlapping 2:3 poster, floating IMDb rating badge, readable story card, Director/Released bento cards, and starring cast chips. Safe `N/A` normalization across every field.
- **Live Search** — 450 ms debounced title search (`min 2` chars) with monotonic request-generation guarding so out-of-order stale responses never overwrite newer results.
- **Saved Watchlist** — Local persistent favorites (`SharedPreferences` under `favorite_movies_v1`), newest-saved first, available offline, and synchronized across all tabs and Detail.

## Architecture

```text
lib/
├── main.dart                         # App bootstrap & Favorites preload
├── app/
│   ├── app.dart                      # MultiProvider + MaterialApp.router
│   ├── di/injection.dart             # get_it container
│   ├── router/                       # go_router routes (Shell + Detail)
│   └── theme/                        # Tokens, spacing, Plus Jakarta Sans scale
├── core/
│   ├── config/env_config.dart        # OMDb config via --dart-define
│   ├── error/                        # Sealed AppException & Failure hierarchy
│   ├── network/api_client.dart       # Dio HTTPS wrapper (no key logging)
│   ├── result/result.dart            # Sealed Result<T>
│   ├── usecase/usecase.dart          # Base UseCase<T, Params>
│   ├── viewmodel/base_view_model.dart
│   └── widgets/                      # Reusable editorial UI primitives
└── features/
    ├── movies/                       # Shared Movie & Favorites domain + data
    ├── shell/                        # IndexedStack bottom-navigation shell
    ├── discover/                     # DiscoverViewModel, Hero, Chips, View
    ├── detail/                       # MovieDetailViewModel, PosterStage, Bento
    ├── search/                       # Debounced SearchViewModel, SearchPill, View
    └── saved/                        # Shared FavoritesViewModel & SavedView
```

## Getting Started

1. Obtain an API key from [omdbapi.com](https://www.omdbapi.com/).
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run --dart-define=OMDB_API_KEY=YOUR_KEY
   ```
4. Verify formatting, static analysis, and automated tests:
   ```bash
   dart format --output=none --set-exit-if-changed lib test
   flutter analyze
   flutter test
   ```
5. Build release Android APK:
   ```bash
   flutter build apk --release --dart-define=OMDB_API_KEY=YOUR_KEY
   ```
