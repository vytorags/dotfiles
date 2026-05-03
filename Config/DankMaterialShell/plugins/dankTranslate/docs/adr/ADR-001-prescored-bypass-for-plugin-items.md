# ADR-001: Use _preScored to Bypass DMS Scorer for Plugin Items

**Status:** Accepted
**Date:** 2026-04-22
**Applies to:** `DankTranslate.qml`

## Context

DMS's Scorer.js filters launcher items by text-matching item names/subtitles against the raw query. For trigger-activated plugins, the query passed to the Scorer is the text after the trigger character (e.g. `ru hello` for `>ru hello`). Plugin items whose names don't textually match this query score 0 and are filtered out.

This caused language-prefixed translations to break — `>ru h` worked (lucky fuzzy match) but `>ru hi` didn't because the item name (a translation result or status message) had no textual relationship to the query.

## Decision

Set `_preScored: 1000` on all items returned by `getItems()`. This uses DMS's built-in mechanism for plugin items to bypass text scoring entirely.

## Alternatives Considered

- **Patching DMS Scorer.js**: Would fix it at the framework level but the plugin should work with unmodified DMS. `_preScored` is the intended API.
- **Adding the query text as a keyword on items**: Would require updating keywords on every debounced query change. Fragile, especially for async translation results.
- **Only using the default language**: Would dodge the bug but removes useful functionality.

## Consequences

- All language code prefixes work regardless of length.
- Plugin items always appear when the trigger is active, which is the correct behavior — the plugin's own `getItems()` already handles filtering/relevance.
- Async translation results (arriving via `requestLauncherUpdate`) are also correctly shown since they carry `_preScored`.
