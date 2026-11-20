# DECISIONS.md — Project decisions and open questions

## Decisions made for the blueprint

| ID | Decision | Status | Note |
|---|---|---|---|
| D-001 | Project working name: **Movie Muse** | Proposed | Can be renamed |
| D-002 | Flutter, Android-first | Chosen | APK delivery required |
| D-003 | MVVM with ChangeNotifier + repositories | Chosen | Practical in 4-hour test |
| D-004 | OMDb HTTPS API with dart-define key | Chosen | No hardcoded credential in Git history |
| D-005 | SharedPreferences JSON favorites | Chosen | Small local saved summaries |
| D-006 | Discover/Search/Saved tabs; Detail route | Chosen | Distinct test flows |
| D-007 | Search 450 ms, minimum 2 characters | Chosen | Not specified by original PDF |
| D-008 | Discover uses transparently labeled default title query | Chosen | No OMDb trending feed |
| D-009 | Reference-inspired soft editorial palette | Chosen | See `DESIGN.md` |
| D-010 | Pagination and query chips optional | Deferred | Add only after P0 |

## Open questions (non-blocking)

- Which valid OMDb API key will be used for build/test? **Required before live functionality can work.**
- What final GitHub repository URL should be included in README/submission? **Not yet provided.**
- What exact app display name/package ID should appear in release APK? Default working title is Movie Muse; package ID can be chosen at project setup.
- Is iOS build required? The PDF explicitly requests APK; Android is delivery priority. iOS-ready layout is a bonus, not an asserted submission requirement.

## Explicit exclusions

Do not invent rankings, genre filters, TMDb integration, trailer playback, social login, AI recommendations, or e-commerce. These are not needed to meet the assessed test.
