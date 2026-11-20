# AI_IMPLEMENTATION_PROMPT.md — Codex / Claude Code handoff

Use this prompt within the Flutter repository and keep all implementation aligned with the other Markdown documents.

## Copy-paste prompt

You are implementing **Movie Muse**, a Flutter Android-first coding-test app with a **strict four-hour delivery scope**. Read `REQUIREMENTS.md`, `DESIGN.md`, `ARCHITECTURE.md`, `API.md`, `TASKS.md`, `TEST_PLAN.md`, and `DECISIONS.md` before changing code. Treat requirements stated as mandatory in `REQUIREMENTS.md` as P0. Preserve the exact soft editorial movie design direction from `DESIGN.md`: cream canvas, lavender/peach gradients, dark plum type, rounded pill controls, actual OMDb movie poster assets, prominent featured movie card, and restrained functional motion. Do **not** copy the mental-health app content or invent a trending feed.

Implement with Flutter, Dart, lightweight MVVM (`ChangeNotifier`), repository-owned HTTP and local persistence. Use HTTPS `https://www.omdbapi.com/` and take the key via `const String.fromEnvironment('OMDB_API_KEY')`. Search using `s` and detail using `i`; handle OMDb `Response=False`, `N/A`, invalid key and timeouts. Discover must show real OMDb results for an explicitly labeled default title query. Search updates after ~450 ms debounce, with a request-generation counter to reject stale responses. Favorites must be keyed by `imdbID`, stored in local SharedPreferences JSON, readable offline, and immediately synchronized across Discover, Search, Saved and Detail. Make all loading, empty, error, and missing-image states usable. Do not add authentication, backend, fake movie scores, fake rankings, remote genre filters, or complex code generation.

Implement in small working increments: (1) skeleton/theme/network/models, (2) discover and detail, (3) live search, (4) persistent favorites, (5) visual polish, (6) tests and real screenshots, (7) release APK. After each increment, run appropriate `flutter analyze` and tests and fix failures. Do not report a step as complete without actually verifying it. Preserve an existing developer's other processes and do not kill unrelated services or processes. At the end, update `README.md` with confirmed implementation status, real screenshots, exact build commands and output path, then report any remaining limitations explicitly. Never invent a successful build, GitHub push, screenshots or email submission.

## Completion report format

```text
Implemented:
- ...
Verified:
- flutter analyze: PASS/FAIL
- flutter test: PASS/FAIL
- Android APK build: PASS/FAIL, confirmed path
Screenshots:
- actual paths or NOT CAPTURED
Outstanding:
- ...
Submission:
- repository URL (if actually pushed)
- APK path (if actually built)
```
