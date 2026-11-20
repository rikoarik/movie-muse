# REQUIREMENTS.md — Movie Muse

> Product requirements · Android-first Flutter · Coding test timebox: 4 hours
> Status: implementation-ready · Source: `Test Mobile Developer.pdf`, pages 1–3

## 1. Context and scope

Build a mobile application to browse movies using the [OMDb API](https://www.omdbapi.com/). The recruitment assignment specifically requires **movie listing**, **movie details**, **live search**, **favorites stored locally**, use of a design pattern as a bonus, an explanatory GitHub repository with screenshots, and an Android APK sent with the repository link. The source PDF labels requirements with scores: list (20), details (20), search (10), local favorites (30), design pattern (20), GitHub/README (10), submission (10). **These numbers are scores, not row counts.** The assignment specifies a **4-hour** completion window.

### Product goals

- Users can browse remotely retrieved movie results and open accurate detail data.
- Users can find movies by title without submitting a search form.
- Users can save or remove favorite movies and see them after restarting the app.
- The UI follows the reference-inspired `DESIGN.md`, without copying the health-app interface literally.

### Constraints and decisions (not imposed by the PDF)

| Item | Decision | Reason |
|---|---|---|
| App | Flutter, Android-first; iOS-friendly layout | One shared codebase, APK required |
| Architecture | Lightweight MVVM + repository | Meets pattern bonus within time |
| API | OMDb via HTTPS; user-provided key | Required provider; avoid exposing key in repository |
| Storage | `shared_preferences` storing a favorites JSON list | Simple persistence suitable for small timebox |
| Navigation | Discover, Search, Saved + Detail | Covers four assessed features |
| Initial movie feed | Default text query such as `batman` | OMDb lacks a native discover/trending endpoint |
| Search | Debounce 450 ms; minimum 2 characters | Reduces unnecessary API requests |
| Pagination | Optional after core requirements | OMDb search is paginated (typically 10 results/page) |

**Not in MVP:** login, backend, cloud sync, video playback, streaming links, ratings submissions, genre discovery API, notifications, or payments.

## 2. Users and navigation

**User:** Anonymous viewer (no login or account).

```text
Launch → Discover → Movie Detail ↔ Save/Unsave
                  ↘ Search → Search results → Movie Detail
                  ↘ Saved → Saved movie → Movie Detail
```

Navigation retains Discover/Search/Saved state where practical. Device Back closes Detail and returns to prior tab. A saved movie can be removed from either detail or the Saved list.

## 3. Functional requirements

| ID | Priority | Requirement | Acceptance criteria |
|---|---|---|---|
| FR-001 | P0 | Load an API-backed movie list on Discover | First launch triggers a valid OMDb search and shows titles, years, and valid posters; loading, empty, and failed states are handled |
| FR-002 | P0 | Open film details | Selecting a movie fetches details by `imdbID`; presents title, year, poster, plot, genre, director, cast, runtime and IMDb rating where available |
| FR-003 | P0 | Live title search | Entering 2+ characters triggers a request after ~450 ms without tapping submit; latest query wins |
| FR-004 | P0 | Persist favorites | Heart saves movie summary keyed by `imdbID` locally; reopening the app preserves it |
| FR-005 | P0 | Remove favorite | Heart toggles to removed state on all screens; saved list updates immediately |
| FR-006 | P0 | Read saved list offline | Saved summaries are visible even without network; detail may require network unless details were cached |
| FR-007 | P0 | Navigate correctly | Discover, Search, Saved, Detail are reachable; Back returns correctly |
| FR-008 | P0 | Error handling | API `Response=False`, invalid key, network errors, empty results, and missing poster show human-readable states |
| FR-009 | P0 | Deliver repository and APK | README explains setup, implementation, screenshots and build; APK exists and has been installed/smoke-tested |
| FR-010 | P1 | Preserve query and scroll position | Changing tab does not unnecessarily clear text/list state |
| FR-011 | P1 | Add incremental search pages | Load next page via `page`; prevent duplicate requests and deduplicate by `imdbID` |
| FR-012 | P2 | Add quick search chips | Chips are explicitly search terms, **not** claims that OMDb provides genres |

### FR-001 — Discover

- Default query is clearly labeled (for example **Batman films**) and uses `?s=batman&type=movie`.
- A featured movie can be one of the loaded results; detailed metadata is requested separately if displayed.
- Tapping a movie card opens a detail route carrying its IMDb ID.
- A poster marked `N/A` uses a styled placeholder, not a broken image.
- Do not label results *Trending*, *Most Popular*, or *Top Rated*: OMDb search does not guarantee those rankings.

### FR-002 — Movie detail

- Source detail fields come from `?i=<imdbID>&plot=full`.
- If any optional metadata equals `N/A` or is missing, omit it or show `Not available`.
- IMDb rating is displayed only if returned and valid; never invent one.
- Network failure on detail offers Retry and Back; a Saved item remains saved even when detail cannot load.

### FR-003 — Live search

- Initial state: helper illustration/text, no request for an empty query.
- Debounce 450 ms and trim whitespace; queries shorter than 2 characters show helper state.
- Show loading while querying; use visible empty state when OMDb returns no titles.
- Ignore results from a previous query after a newer query is typed, even if responses arrive out of order.
- Show the `totalResults` API count as *matching results*; not as the number of visible cards.

### FR-004/005/006 — Favorites

- Unique key: `imdbID`; saves are idempotent and do not generate duplicate rows.
- A saved record stores `imdbID`, `title`, `year`, `poster`, and optional `type`; it is enough to render Saved offline.
- Use the same favorite state for hearts on Discover, Search, Detail, and Saved.
- A removed favorite must disappear from Saved and unselect its heart in the rest of the app.
- If local storage decoding fails, the app must not crash; use an empty list and surface/log a recoverable error.

## 4. Quality requirements

| ID | Quality | Acceptance criteria |
|---|---|---|
| NFR-001 | Reliability | Null, missing and `N/A` fields cannot crash rendering |
| NFR-002 | Performance | Network queries are debounced; lists use lazy rendering; no blocking persistence on UI thread |
| NFR-003 | Accessibility | Tap targets at least 44 dp; heart controls have semantic label/state; text adapts to scaling |
| NFR-004 | Visual fidelity | `DESIGN.md` color, typography, spacing, components and screen hierarchy are implemented consistently |
| NFR-005 | Configuration | Key passed through `--dart-define=OMDB_API_KEY=...`; not committed in source, logs, screenshots or README |
| NFR-006 | Security | HTTPS requests; do not collect credentials or user personal data |
| NFR-007 | Delivery | Android release APK is generated and verified; repo has setup instructions and actual screenshots |

> A client-side application cannot genuinely keep a distributed API key secret. `--dart-define` keeps it out of the Git history, but the key can still be recovered from a distributed APK. For a production product, use a controlled proxy; a direct call is acceptable as a timeboxed test decision.

## 5. State matrix

| Screen | Initial | Loading | Success | Empty | Error |
|---|---|---|---|---|---|
| Discover | Default search | Skeleton poster rows | Movie list | No matches for default term | Retry CTA |
| Search | Idle hint | Skeleton rows | Relevant results | No matches | Retry CTA; retain query |
| Detail | ID from route | Hero skeleton | Full movie details | N/A optional metadata | Retry CTA and Back |
| Saved | Read local storage | Short spinner | Stored cards | Friendly empty state | Recoverable local-storage error |

## 6. Definition of done (P0)

- [ ] All four principal user journeys work on a real device or Android emulator.
- [ ] Search updates after typing without tapping Submit; stale responses never overwrite new results.
- [ ] Save/unsave syncs across screens and persists across a force-close/relaunch.
- [ ] API failure, empty results and `N/A` posters do not cause crashes.
- [ ] Visually consistent with `DESIGN.md` at a normal phone size.
- [ ] `flutter analyze` and tests pass; Android release APK builds.
- [ ] GitHub repo has readable setup and screenshot proof; APK and repo link are ready for sending.

## 7. Source versus implementation assumptions

**Explicit in PDF:** OMDb provider, listing, details, live search, locally stored favorites, design-pattern bonus, GitHub README/screenshots, APK/email handoff, four-hour time limit. **Our proposals:** Flutter, MVVM, three tabs, colors, initial Batman search, debounce, local storage package, pagination strategy, error-state wording and optional polish. Proposed choices can change without violating the test.
