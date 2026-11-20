# Movie Muse

Flutter movie browser built for the **Android/iOS Developer coding test**. Uses the OMDb API, lightweight MVVM, live title search, detail screens, and favorites stored on-device. The UI follows a soft editorial cinema design inspired by the supplied peach/lavender reference.

> **Project status:** Documentation/blueprint only. This folder does not claim the Flutter application or APK has been implemented yet. Replace this notice, the screenshot placeholders, and checklists with actual results before publishing.

## Required features

- Remote movie list (OMDb search)
- Detailed movie information by IMDb ID
- Live debounced search
- Save/remove favorites locally and retain them across launches
- MVVM with repository separation

## Technical choices

Flutter · Dart · OMDb HTTPS API · `http` · `shared_preferences` · `ChangeNotifier`.

## Getting started (after Flutter project implementation)

1. Install Flutter and Android SDK; verify `flutter doctor`.
2. Obtain an OMDb API key at [omdbapi.com](https://www.omdbapi.com/).
3. Install dependencies using `flutter pub get`.
4. Start the app: `flutter run --dart-define=OMDB_API_KEY=YOUR_KEY`.
5. Build APK: `flutter build apk --release --dart-define=OMDB_API_KEY=YOUR_KEY`.

**Key caveat:** `dart-define` avoids committing the key but it remains recoverable in the APK; never treat it as a production secret.

## Screenshots — add actual app captures

| Discover | Detail | Search | Saved |
|---|---|---|---|
| TODO: `screenshots/discover.png` | TODO: `screenshots/detail.png` | TODO: `screenshots/search.png` | TODO: `screenshots/saved.png` |

Do not commit example/reference imagery as if it were app screenshots.

## Architecture

Flutter widgets → ViewModels (`ChangeNotifier`) → Movie/Favorites repositories → OMDb HTTPS / local SharedPreferences. See [ARCHITECTURE.md](ARCHITECTURE.md).

## Documentation

- [REQUIREMENTS.md](REQUIREMENTS.md) — scope, functional and nonfunctional acceptance
- [DESIGN.md](DESIGN.md) — colors, layout, screens, components and motion
- [ARCHITECTURE.md](ARCHITECTURE.md) — MVVM, models, state and persistence
- [API.md](API.md) — OMDb endpoints and response handling
- [TASKS.md](TASKS.md) — four-hour work plan
- [TEST_PLAN.md](TEST_PLAN.md) — automated/manual scenarios
- [DECISIONS.md](DECISIONS.md) — decisions and unresolved points
- [AI_IMPLEMENTATION_PROMPT.md](AI_IMPLEMENTATION_PROMPT.md) — implementation handoff prompt

## Required submission

When implementation is complete: push the code and README with genuine screenshots to GitHub, verify the release APK, and email the APK + repository link to the address stated in the test document (`iam@andazlan.com`).
