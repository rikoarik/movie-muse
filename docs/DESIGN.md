# DESIGN.md — Movie Muse

> Design system & UX specification for a Flutter movie-discovery application.
>
> **Status:** Ready for implementation · **Platform:** Android-first, responsive for iOS · **Target:** Recruitment coding test (4 hours) · **Design direction:** *Soft Editorial Cinema*

## 0. Design source and interpretation

**Visual reference:** [`references/visual-reference.png`](references/visual-reference.png), supplied by the requester.

The reference shows three playful, premium mobile screens with a warm white canvas, generous whitespace, cream/peach/lilac gradients, rounded pill controls, organic soft-edged artwork, small utility icons, oversized friendly typography, and highly curated cards. The original subject is a mental-health application. **Borrow the visual language, not its content, screen layout verbatim, mascots, or copy.** The resulting app must clearly be a movie application with actual OMDb poster data.

**Design thesis:** A movie journal meets a contemporary editorial app: expressive enough to look custom, quiet enough for posters and readable film information to lead.

### Required translation from reference to movie UI

| Reference characteristic | Application translation | Avoid |
|---|---|---|
| Peach + lavender atmospheric backgrounds | Gradient surface behind a featured movie and on detail hero | Full-screen orange behind every screen |
| Large organic soft forms | Layered translucent blobs/ellipses using Flutter gradients | Copying the reference's mental-health mascot |
| Tilted white foreground card | Featured movie information panel with intentional overlap | Unreadable tiny text or excessive rotation |
| Rounded white search/back controls | Consistent 44–48 dp icon buttons and rounded search field | Icon-only buttons without semantics |
| Friendly editorial headings | Bold film titles, small uppercase section eyebrow | Too many font sizes or full uppercase paragraphs |
| Fine, restrained bottom icons | Three destinations: Discover, Search, Saved | Five or more navigation tabs |
| Calm, airy composition | Larger section gaps, fewer surfaces, strong image hierarchy | Dense dashboard or repeated glassmorphism |

## 1. Design principles

1. **Movies first.** Show real movie artwork or reliable poster fallbacks; decorative shapes must remain secondary.
2. **Editorial, not dashboard.** Lead with one strong message, one feature, then simple browsable results.
3. **Soft, not flat.** Organic gradient shapes and subtle shadows establish depth without distracting blur.
4. **Functional by default.** Design search, network failure, loading, no posters, and saved-empty states deliberately.
5. **Restraint under time pressure.** Implement the high-impact layout first; complex custom painting is optional.
6. **No decorative emoji.** Use Flutter Material/Lucide-like line icons; Android and iOS system UI should feel native.

## 2. Foundation tokens

### 2.1 Color tokens

Use these values as the source of truth in `app_theme.dart`; all text contrast must be checked on its **actual** background.

| Token | Hex | Usage |
|---|---|---|
| `canvas` | `#FAF8F6` | Main screen background |
| `surface` | `#FFFFFF` | Cards, buttons, navigation surface |
| `surfaceWarm` | `#FFF3EC` | Small surface accents |
| `peach` | `#FF9C62` | Primary expressive accent, gradient |
| `peachLight` | `#FFE3CF` | Soft accent fill |
| `lavender` | `#D9C9ED` | Secondary expressive accent |
| `lavenderDeep` | `#AC91CC` | Selected graphics, non-essential accents |
| `butter` | `#FFE4A8` | Warm highlight |
| `plum` | `#392B3D` | Primary text and high-contrast icons |
| `muted` | `#7C727D` | Secondary text |
| `outline` | `#EDE6EB` | Hairline borders |
| `success` | `#256E57` | Positive feedback |
| `error` | `#B42337` | Network and validation error |
| `placeholder` | `#EDE7EB` | Image/skeleton base |

**Gradient recipes** (implement using `LinearGradient` / `RadialGradient`):

```dart
// Example theme values — copy into production theme class.
const kCanvas = Color(0xFFFAF8F6);
const kPlum = Color(0xFF392B3D);
const kPeach = Color(0xFFFF9C62);
const kLavender = Color(0xFFD9C9ED);

const featureGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFE8C9), Color(0xFFFFAE83), Color(0xFFE4D5F1)],
  stops: [0.0, 0.58, 1.0],
);
```

Contrast rules:
- Use `plum` for body text and buttons on light/peach surfaces. **Do not use orange text on white** for essential information.
- Place white text only on sufficiently dark surfaces or over an explicit dark scrim on imagery.
- `muted` is secondary text, never the only signal of selection or error.
- Provide visible focus states and at least 44×44 dp hit targets.
- If a generated gradient reduces readability, move the text to a solid surface instead of relying on blur.

### 2.2 Typography

**Preferred family:** `Plus Jakarta Sans` (widely available, rounded geometric feel). The source resembles a soft contemporary grotesk; this approximates it without requiring proprietary font assets. If a legally licensed Satoshi font is already supplied, it may replace Plus Jakarta Sans, but do **not** source an unlicensed font.

| Text style | Font size | Weight | Height | Usage |
|---|---:|---:|---:|---|
| `display` | 34 sp | 700 | 1.10 | Discover statement |
| `titleXL` | 30 sp | 700 | 1.12 | Movie detail title |
| `titleL` | 23 sp | 700 | 1.20 | Sections and featured card |
| `titleM` | 16 sp | 650/700 | 1.30 | Result title |
| `body` | 14 sp | 400/500 | 1.55 | Plot, metadata |
| `label` | 12 sp | 600 | 1.30 | Chips, navigation |
| `eyebrow` | 10–11 sp | 700 | 1.20 | Overlines / section identifiers |

- Avoid manually letter-spacing all copy; only short eyebrow labels may have `0.8–1.2` tracking.
- Limit feature headings to two or three lines, then allow natural wrap on smaller devices.
- Minimum essential metadata size: approximately 12 sp, responsive to system text scale.
- Prefer sentence case: `Find something worth watching.` over all-caps slogans.

### 2.3 Geometry, spacing, and shadows

Use **4 dp base grid**. Common spacing: `4, 8, 12, 16, 20, 24, 32, 40, 48` dp.

| Element | Size |
|---|---|
| Page horizontal gutter | 24 dp (`16` on width < 360 dp) |
| Content max width | 520 dp on tablets/large windows |
| Feature surface radius | 32 dp |
| Movie tile radius | 22 dp |
| Poster radius | 16–20 dp |
| Search pill radius | 26 dp |
| Tag/chip radius | 99 dp |
| Button/icon hit area | >=44 dp |
| Bottom navigation height | 70–78 dp plus system safe area |
| Regular elevation | Very soft: black opacity 5–8%, 18–30 dp blur |

Avoid strokes on every object; use elevation or `outline` when card and canvas need separation. Shadow direction remains consistent, no hard neumorphic inset shadows.

### 2.4 Icons and illustration

- Icons: Material Symbols/`Icons.*` line variants (`search`, `favorite_border`, `favorite`, `arrow_back`, `close`, `movie`, `wifi_off`, `refresh`). If an existing icon pack is available, use one pack consistently.
- Decorative blobs: create from `Container` + radial gradient + oval/organic clipping. For the 4-hour test, **do not require a new 3D pipeline** or a raster illustration service.
- Posters: load directly from the `Poster` field in OMDb response (when valid); show a designed placeholder for `N/A`, invalid URL, timeout, or network errors.
- No static dummy movie listings should appear as if received from the API.

## 3. Information architecture

```text
Application
├── Discover (default tab)
│   ├── Featured movie panel (curated title from OMDb, optional)
│   ├── Search entry
│   ├── Genre-like query chips (predefined search terms, NOT real genre API)
│   └── Movie results → Movie details
├── Search (tab)
│   ├── Text input (debounced)
│   ├── Search results → Movie details
│   └── Empty / no results / error states
└── Saved (tab)
    ├── Local favorite list → Movie details
    └── Empty state
```

**Navigation model:** Single `Scaffold` with consistent bottom navigation for Discover, Search, Saved. Hide bottom navigation on the full-page detail route if that improves poster focus. All routes must preserve the user's scroll/search state when practical (e.g., `IndexedStack`).

## 4. Screen specifications

### 4.1 Discover — primary screen

**Goal:** Provide an immediately readable movie listing and one visually distinctive feature without hiding the test requirements.

**Composition (top to bottom):**

1. Android/iOS system status bar with safe area; light system bar, dark icons.
2. Header: small `MOVIE MUSE / DISCOVER` eyebrow; main headline `A good film starts here.`; to the right, a 44 dp circular search icon (optional if search pill exists).
3. Main featured hero (`aspect ratio ~1.15–1.35`, min 260 dp height, max ~340 dp on typical phones): cream-to-peach-to-lilac atmospheric gradient; decorative translucent circles in back; movie poster as an actual 2:3 image, positioned to one side with a small angle **≤5°**; solid or white-tinted lower card carrying eyebrow `FEATURED FILM`, movie title, year, and `View details` arrow. Keep text readable independent of poster color.
4. `Explore films` heading, short subheading `Pick a story for tonight.`
5. Optional pill query chips `Batman`, `Star Wars`, `Love`, `Comedy`. **These trigger OMDb text searches; they are not a genre taxonomy.** The selected chip has soft peach fill plus plum text. Optional if implementation time is tight.
6. Vertical movie list showing posters, titles, year, a small secondary label, and a trailing favorite control. List must display API-backed content and be scrollable. Consider `ListView.builder` / slivers.
7. Bottom navigation integrated into safe area.

**First-load data rule:** OMDb does not expose a trending/discover feed in the required API. For a reproducible starter list, request a predefined text search such as `s=batman&type=movie`. Label it `Batman films` or `Discover: Batman`, **not** `Trending now` or `Top rated`. A featured film may be retrieved separately by its known IMDb ID; do not hardcode its plot/poster as remote truth.

**Wireframe (structure, not scale):**

```text
┌──────────────────────────────────────┐
│ MOVIE MUSE                       ◯   │
│ A good film                       │
│ starts here.                      │
│                                    │
│  ╭── warm gradient feature ─────╮ │
│  │      ○ lilac       ┌──────┐  │ │
│  │ FEATURED FILM      │POSTER│  │ │
│  │ Film title         │ 2:3  │  │ │
│  │ Year         ↗     └──────┘  │ │
│  ╰───────────────────────────────╯ │
│                                    │
│ Explore films                      │
│ (Batman) (Star Wars) (Love)        │
│                                    │
│ ┌──────┐  Film title          ♡    │
│ │poster│  2020 · Movie             │
│ └──────┘                           │
│ ┌──────┐  Next film            ♡    │
│ │poster│  2012 · Movie             │
│ └──────┘                           │
├────────────────────────────────────┤
│    Discover    Search     Saved    │
└────────────────────────────────────┘
```

**Interaction:** Tap poster/list card → detail. Tap heart → local save toggle and immediate UI update. Tap chip → update query and list state; scrolling resets to top. Tap search icon/tab → search field focus.

### 4.2 Search — intentional live-search UI

**Goal:** Search starts responding after the user pauses typing, with a visibly clear query/result relationship.

- Header: `Find a film.` large dark-plum title and compact helper `Search by title.`
- Search field: white rounded pill, search icon at left, text hint `Search movies...`, clear icon at right when non-empty; 52–56 dp height; border `outline` and soft shadow.
- Under field: small helper label `RESULTS` / `12 matches` (from API `totalResults`) when available. Do not claim the visible results count equals total result count.
- Results: same `MovieListTile` as Discover; reuse view model, skeleton, empty and error components.
- Input debounce: ~400–500 ms; minimum 2 characters; allow clearing to a friendly idle state (do not call the API with empty text).
- Keyboard: text search action; content avoids keyboard obscuring lower rows. `SafeArea` + `resizeToAvoidBottomInset`.
- Stale network responses cannot replace newer results. Keep a monotonically increasing request generation ID or cancellation mechanism.

**States:**

| State | Visible design | Text example |
|---|---|---|
| Idle | Lavender/peach subtle blob + line icon | `What are you in the mood for?` |
| Loading | 3–5 poster-row skeletons | (No fake results) |
| Results | API movie cards with result count | `Results for “batman”` |
| No results | Minimal outlined film icon, compact helper | `No films found. Try another title.` |
| Network error | Inline white card and retry button | `Couldn't load films.` |
| Missing API key | Actionable setup notice | `OMDb API key isn't configured.` |

### 4.3 Movie details — visual centerpiece

**Goal:** Make movie metadata readable while preserving the expressive reference aesthetic.

1. Full-bleed but bounded gradient backdrop behind a centered poster (poster ratio `2:3`; height ~280–360 dp according to viewport). Use hero tag `movie-${imdbID}` for a deliberate poster transition, only when image exists.
2. Top-left white round back button, top-right white round heart toggle. Buttons have semantics.
3. A soft peach/lilac ellipse peeks out around poster, but stays behind poster (never overlaps metadata).
4. Below hero: large film title (30 sp), year, runtime, rating if valid; metadata displayed as small pills or one row with good wrapping.
5. `The story` / plot in readable 14 sp, generous line height.
6. `Details` with fields: Genre, Director, Actors, Released, and optionally IMDb rating. Hide unavailable fields or display `Not available`, **never render raw `N/A`**.
7. Short page with natural scroll; no unrelated booking, watch-video, subscription, trailer, AI recommendation, or purchase CTA.

**Mobile layout:**

```text
┌──────────────────────────────────────┐
│ (←)                             (♡) │
│   organic lavender + peach          │
│             ┌─────────┐             │
│             │  POSTER │             │
│             │   2:3   │             │
│             └─────────┘             │
│                                      │
│ The Movie Title                      │
│ 2014  ·  169 min  ·  IMDb 8.6        │
│                                      │
│ THE STORY                            │
│ Movie overview text from API...      │
│                                      │
│ DETAILS                              │
│ Genre       Sci-Fi, Adventure        │
│ Director    ...                      │
│ Cast        ...                      │
└──────────────────────────────────────┘
```

**Fallback:** If details cannot load, show a designed retry state. For saved films, use the locally saved title/year/poster and cached metadata if present, while indicating extended details are unavailable offline.

### 4.4 Saved — favorites persisted on device

**Goal:** Make saved films feel like a personal small collection, not a generic settings list.

- Header: small `YOUR COLLECTION`, main `Saved for later.`
- Small count label `3 films` derived from local storage.
- Movie cards reuse the listing component with a filled-heart state. Sort newest-saved first; order stays stable across relaunches.
- Removing from Saved updates storage and the Discover/Search heart controls without restarting.
- Empty state: a subtle lavender ellipse behind an outlined heart-on-ticket icon, title `Your watchlist is empty.`, helper `Save films you want to revisit.`, button `Explore movies`.
- Don't require account creation or cloud sync; local favorites are the requirement.

## 5. Reusable components

| Component | Responsibility | Notes |
|---|---|---|
| `AppShell` | Safe area, navigation, main canvas | Bottom nav on 3 tabs |
| `EditorialHeader` | Eyebrow + large title | One consistent hierarchy |
| `AtmosphereBackground` | Soft gradients and shapes | Low-cost Flutter decorations |
| `FeaturedMovieCard` | Curated movie with poster and CTA | Optional separate detail fetch |
| `SearchPill` | Debounced query input UI | Clear and focus behavior |
| `QueryChip` | Sends supported keyword search | Avoid pretending genre filter |
| `MovieListTile` | Poster + title/year + heart | Tap area 44+ dp |
| `PosterImage` | Network image + fallback | Handles `N/A` and errors |
| `FavoriteButton` | Single source of truth from repository | Semantics, pressed state |
| `MetadataPill` | Year/runtime/rating | Hide absent values |
| `AppEmptyState` | Clear title/helper/action | No random 3D mascot |
| `AppErrorState` | Recovery action | Genuine retry |
| `MovieSkeleton` | Perceived loading progress | No content jumping |

**Do not create** redundant variants of the same button/card. Define a small theme in one file and reuse it everywhere.

## 6. Motion and interaction specification

All motion must communicate navigation, feedback, or a state change. There is **no continuous ambient animation** during reading.

| Motion | Duration | Curve | Purpose |
|---|---:|---|---|
| Poster → details `Hero` | 250–350 ms | `easeInOutCubic` | Preserve spatial continuity |
| Favorite heart scale (`0.90 → 1.07 → 1.0`) | 180–240 ms | `easeOutBack` | Confirm save/remove |
| Search results change | 150–200 ms | `easeOut` | Indicate content update |
| Nav selection indicator | 160–220 ms | `easeOutCubic` | Show active destination |
| Initial content skeleton | No shimmer required | — | Avoid false waiting behavior |

Respect OS reduced-motion settings where practical. Never animate entire list on every keystroke or use long dramatic transitions that slow test evaluation.

## 7. Responsive and accessibility rules

- Target 360–430 dp mobile width first; verify at 320 dp and landscape/tablet using centered max-width layout.
- Do not hardcode iPhone Dynamic Island, clock, or status-bar decorations shown in the reference; the OS renders these elements.
- Use `SafeArea` and support Android gesture/navigation bar inset. Avoid content hidden behind keyboard.
- Image/poster ratio remains `2:3`; cards can grow vertically with accessible text scaling.
- `Semantics` labels: `Save <title> to favorites`, `Remove <title> from favorites`, `Open details for <title>`.
- Support visible selection **without color only** (filled heart and active text/icon).
- Error/empty/search states must be readable at larger text sizes.
- If a movie has no poster, show a designed colored rectangle with an icon and abbreviated movie title.

## 8. Visual QA acceptance checklist

- [ ] Three distinct screens match the *feel* of the reference: rounded, warm, editorial, playful, airy.
- [ ] Posters and movie facts come from OMDb, not hardcoded fake results.
- [ ] Discover is not a wall of same-size rectangles; hero has meaningful visual hierarchy.
- [ ] Search list and saved list use the same result-card component.
- [ ] Large headings never clip on a typical Android phone.
- [ ] Plum text remains legible on cream, peach, and lavender surfaces.
- [ ] `N/A` posters, missing fields, failed requests, zero results, and empty favorites are handled.
- [ ] Favorites remain saved after force-close and relaunch.
- [ ] Android back button returns predictably to previous screen.
- [ ] UI works with device navigation bar and keyboard visible.
- [ ] No copyrighted mental-health illustration from the reference is recreated.
- [ ] No unnecessary onboarding, login, backend, AI, review system, or film streaming added.

## 9. Implementation order for a 4-hour test

**P0 (must implement):** App theme, Explore API list, Movie details, Search, Favorites persistence, clear states, runnable APK.

**P1 (if ahead of schedule):** Feature card, subtle organic gradient composition, poster `Hero` transition, chips, one motion polish.

**P2 (only after P0 + submission artifacts):** pagination, more detailed skeletons, more elaborate organic assets.

If time is tight, prioritize accurate functionality and reliable build over decorative effects. The design succeeds when the core app still feels intentional without requiring bespoke 3D art.

## 10. Copy deck

| Location | Text |
|---|---|
| App name (working name) | `Movie Muse` |
| Discover headline | `A good film starts here.` |
| Discover section | `Explore films` |
| Featured eyebrow | `FEATURED FILM` |
| Search header | `Find a film.` |
| Search hint | `Search movies...` |
| Search idle | `What are you in the mood for?` |
| Saved headline | `Saved for later.` |
| Saved empty | `Your watchlist is empty.` |
| Saved CTA | `Explore movies` |
| Detail plot | `The story` |
| Error title | `Couldn't load films.` |
| Retry | `Try again` |

Copy can be adapted to Indonesian consistently across the whole app; avoid mixing two languages unintentionally. For the screenshot-oriented test, English text is specified here for a clean and compact UI.

---

**Related documents:** [`REQUIREMENTS.md`](REQUIREMENTS.md) · [`ARCHITECTURE.md`](ARCHITECTURE.md) · [`API_CONTRACT.md`](API_CONTRACT.md) · [`IMPLEMENTATION_PLAN.md`](IMPLEMENTATION_PLAN.md) · [`QA_CHECKLIST.md`](QA_CHECKLIST.md)
