# TEST_PLAN.md — Movie Muse QA

> Scope: assessed user flows, resilience, local persistence, and Android APK delivery.

## 1. Core test matrix

| ID | Scenario | Expected result | Priority |
|---|---|---|---|
| TC-01 | Launch with valid API key and internet | Labeled default search displays movie list with titles/years | P0 |
| TC-02 | Tap list movie | Opens detail of matching IMDb ID with accurate fields | P0 |
| TC-03 | Type `batman` in Search | Results update automatically after debounce | P0 |
| TC-04 | Quickly type `bat`, then `batman` | Old response never replaces the final query | P0 |
| TC-05 | Search for nonsense title | No-results state, no crash | P0 |
| TC-06 | Save from Discover then open Saved | Movie is listed, heart remains selected | P0 |
| TC-07 | Save from Detail then return | Same heart state on all screens | P0 |
| TC-08 | Force-stop/relaunch after saving | Saved movie remains listed | P0 |
| TC-09 | Remove movie from Saved | It disappears and hearts become unselected | P0 |
| TC-10 | Open Saved while offline | Previously saved summaries still visible | P0 |
| TC-11 | OMDb poster value `N/A` | Placeholder shown without image exception | P0 |
| TC-12 | No network during search/detail | Error and Retry control visible; no crash | P0 |
| TC-13 | Key missing/invalid | Actionable configuration message | P0 |
| TC-14 | Movie fields missing / `N/A` | No raw `N/A`, no crash | P0 |
| TC-15 | Long title and large font scaling | Text wraps; actionable controls remain usable | P1 |
| TC-16 | Navigate between tabs, return to Search | Query/results retained where implemented | P1 |
| TC-17 | Android release APK install/open | App runs using intended configuration | P0 |

## 2. Automated testing recommendations

- **Model parsing:** `Response=False`, absent `Search`, invalid `totalResults`, `Poster=N/A`, missing optional metadata.
- **ViewModel search:** fake delayed requests return in reverse order; only latest is displayed; query shorter than two characters does not call the repository.
- **Favorites repository:** add, duplicate add, remove, serialize/reload, malformed JSON handling.
- **Widget smoke test:** discover loading, empty state, favorite toggle semantics.

Keep all automated tests deterministic with fake repositories. Live OMDb integration is a separate manual smoke check.

## 3. Manual visual verification

Check screenshots against `DESIGN.md` on a typical 360–430 dp phone viewport. Verify main canvas `#FAF8F6`, peach-lilac hero, rounded white search elements, prominent movie posters, readable dark-plum typography, safe areas, 44 dp icon targets, and consistent state messaging. Screenshots must show the *implemented app*; do not present the supplied health reference as the result.

## 4. Run commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run --dart-define-from-file=.env
flutter build apk --release --dart-define-from-file=.env
```

Set up the local `.env` using the [README](../README.md) before running or building. The APK is built to `build/app/outputs/flutter-apk/app-release.apk`.

## 5. Release acceptance

- [ ] No missing-key or permission errors on launch.
- [ ] All P0 scenarios passed on device/emulator.
- [ ] At least 4 actual screenshots: Discover, Detail, Search, Saved.
- [ ] GitHub repository link opens and README instructions are reproducible.
- [ ] APK is built, installable, and attached for sending.
