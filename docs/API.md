# API.md — OMDb integration contract

> Provider mandated by assignment: [OMDb API](https://www.omdbapi.com/)

## 1. Configuration

The app reads `OMDB_API_KEY` at build time and calls `https://www.omdbapi.com/`. For a local build, copy [`.env.example`](../.env.example) to `.env`, fill in an active key, and pass `--dart-define-from-file=.env`. The built APK contains the key it uses.

| Action | Request | Notes |
|---|---|---|
| Search movie | `GET /?apikey=KEY&s=batman&type=movie&page=1` | `s` searches by title; pages start at 1 |
| Movie detail | `GET /?apikey=KEY&i=tt0372784&plot=full` | IMDb ID is authoritative lookup key |

Do not use `genre` query filtering, trending lists, or recommendations: these are not standard OMDb search endpoints.

## 2. Typical response shapes

Search response **illustrative only** (not live API data):

```json
{
  "Search": [{"Title":"Example Movie","Year":"2020","imdbID":"tt0000001","Type":"movie","Poster":"N/A"}],
  "totalResults":"1",
  "Response":"True"
}
```

Detail response **illustrative only**:

```json
{
  "Title":"Example Movie", "Year":"2020", "imdbID":"tt0000001",
  "Runtime":"120 min", "Genre":"Drama", "Director":"Example Director",
  "Actors":"Example Cast", "Plot":"Example plot", "imdbRating":"7.0",
  "Poster":"N/A", "Response":"True"
}
```

Failure is often a valid HTTP 200 payload such as `{"Response":"False","Error":"Movie not found!"}`. Parse `Response` explicitly, never rely on HTTP status alone. `totalResults` is a numeric **string**; parse defensively with `int.tryParse(...) ?? 0`. OMDb can return `N/A` for many fields.

## 3. Error map

| Condition | Mapping | UX |
|---|---|---|
| Missing key in build | `ApiConfigurationException` | Display setup message, no request |
| Invalid key returned by OMDb | `InvalidApiKeyException` | Display configuration error |
| Search returns no match | `EmptySearchResult` | Show no-results illustration |
| Network offline, timeout, HTTP 5xx | `NetworkException` | Error card and Retry |
| Unexpected JSON / missing mandatory ID | `ParseException` | Retry / safe fallback |
| `Poster = "N/A"` | `poster = null` | Show placeholder artwork |

## 4. Optional pagination

OMDb search results commonly return 10 items per page. If implementing infinite scroll: next page starts at `2`, load only when `items.length < totalResults`, prevent simultaneous fetches, and deduplicate by `imdbID`. A new search term resets the loaded pages and invalidates old in-flight results.

## 5. Testing without a key

Inject a fake movie repository for unit/widget tests. Do not require live API calls in CI. Run one integration smoke test with a valid key before APK delivery.
