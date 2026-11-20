# TASKS.md — Timeboxed implementation checklist

> Four-hour delivery plan. Prioritize correct behavior and submission over nonessential polish.

## Execution schedule (240 minutes)

| Window | Work | Deliverable |
|---|---|---|
| 00:00–00:25 | Initialize Flutter, dependencies, app theme, API key configuration, models | Running app + verified OMDb request |
| 00:25–01:10 | OMDb client/repository, Discover list, poster states, details route | List + Detail functional |
| 01:10–01:45 | Live Search, debounce, stale response suppression | Search functional |
| 01:45–02:25 | Shared FavoritesViewModel, persistence, Saved tab | Favorites survive app restart |
| 02:25–03:15 | Apply `DESIGN.md`: feature hero, responsive cards, icons, states, motion | Coherent polished screens |
| 03:15–03:40 | Tests, manual end-to-end check, fix regressions | Reliable app |
| 03:40–04:00 | README screenshots, release APK, repo push, submission draft | Delivery artifacts |

Time blocks are **targets**, not a claim that anything has been implemented already.

## Milestone A — functional core (P0)

- [ ] Create Flutter Android project and configure key via dart-define.
- [ ] Add `http` and `shared_preferences` (and a font package only if necessary).
- [ ] Build models with missing/`N/A` normalization.
- [ ] Implement API client: search by `s`, details by `i`, check `Response`.
- [ ] Create Discover movie list with progress, empty, error, and poster fallbacks.
- [ ] Create Detail with accurate OMDb metadata.
- [ ] Create Search with 450 ms debounce, latest-query-wins logic.
- [ ] Create Favorites with unique IMDb ID, offline rendering, synchronized hearts.
- [ ] Verify persistence after full process restart.

## Milestone B — visual quality (P0/P1)

- [ ] Implement theme tokens from `DESIGN.md`, avoid hardcoded per-widget color drift.
- [ ] Distinctive peach/lavender Discover hero using real poster data.
- [ ] Search pill and editorial heading; Saved empty state.
- [ ] Semantic heart controls and minimum 44 dp hit targets.
- [ ] Respect notches, keyboard, text scale, and long titles.
- [ ] Only add Hero/fade motion after the four core features work.

## Milestone C — validation and handoff (P0)

- [ ] `flutter analyze` returns no errors.
- [ ] `flutter test` passes.
- [ ] Verify poor network, `N/A` poster, no results, no favorites, relaunch.
- [ ] Capture real screenshots from the built app (not reference image or mockup).
- [ ] Update `README.md` with implemented features and screenshot links.
- [ ] Build release: `flutter build apk --release --dart-define=OMDB_API_KEY=...`.
- [ ] Install APK and launch on Android device/emulator.
- [ ] Push complete source to GitHub (exclude build output and real key).
- [ ] Email APK and repository link to `iam@andazlan.com` as specified in the test.

## Priority guardrails

If behind schedule, **do not sacrifice** local favorites, detail data, search correctness, README/screenshots, or APK. Drop optional genres/chips, page 2+ loading, decorative illustrations, advanced transitions, and tablet refinements before dropping any scored feature.

## Known risks

| Risk | Mitigation |
|---|---|
| OMDb key unavailable | Request/activate key early; don't pretend mock data fulfills API requirement |
| API quota/rate constraints | Debounce and avoid re-fetches; limit test iterations |
| Broken artwork | Designed poster placeholder |
| Stale search responses | Generation-token check |
| Favorite state mismatch | Share one FavoritesViewModel across screens |
| Android build late failure | Test Android toolchain early and build debug once |
| README screenshot omission | Reserve a 20-minute submission window |
