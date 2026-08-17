# QWinUI3 documentation

Published site: **https://wuyijing-dev.github.io/QWinui3/**

**Recipes hub (1.36):** [`recipes.md`](recipes.md) — all LoB how-tos in one place.

## Conventions

| Doc | Description |
|-----|-------------|
| [`index.md`](index.md) | Docs site home |
| [`recipes.md`](recipes.md) | Recipe hub / MkDocs Recipes tab |
| [`compatibility-1xx.md`](compatibility-1xx.md) | 1.xx will-not-break Theme / shells / stable (1.40) |
| [`upgrade-notes.md`](upgrade-notes.md) | Consumer upgrade checklist + template (1.40) |
| [`color-contrast.md`](color-contrast.md) | Accent AA diagnostics / Theme.contrastRatio (1.43) |
| [`keyboard.md`](keyboard.md) | Keyboard-first app cookbook (1.44) |
| [`on-screen-keyboard.md`](on-screen-keyboard.md) | Win11 OSK → IME (1.70…**1.75** Keyman packs; still experimental) |
| [`conventions.md`](conventions.md) | Radius/clip pitfalls, Accessible rules, Extras import rule |
| [`gallery-catalog-page.md`](gallery-catalog-page.md) | Gallery `CatalogPage` host — **Item not Page**, footer/overlay slots |
| [`webview2-future.md`](webview2-future.md) | Legacy redirect → [`webview2.md`](webview2.md) |

## Component API

| Doc | Description |
|-----|-------------|
| [`components.md`](components.md) | Index of all controls |
| [`components/`](components/) | One markdown page per control (generated) |
| [`components.json`](components.json) | Machine-readable catalog (generated) |

Source of truth is the `//` comment header in each `.qml` file. Regenerate:

```bash
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
```

Build the MkDocs site locally:

```bash
pip install -r requirements-docs.txt
python scripts/generate_component_docs.py
mkdocs serve
```

Header convention:

```qml
// Name — one-line summary.
//
//   Name {
//       /* example + // --- API --- call notes */
//   }
//
// @notes
//   Optional free-form notes rendered as ## Notes.
```

## Tooling

| Doc | Description |
|-----|-------------|
| [`qt-creator.md`](qt-creator.md) | Open Gallery / examples in Qt Creator (CMake only) |
| [`packaging-consumer.md`](packaging-consumer.md) | Shared vs static / windeploy / strip |
| [`qt-version-compat.md`](qt-version-compat.md) | Compat shims + CI matrix |

Shell / platform / LoB recipes are indexed on [`recipes.md`](recipes.md) (window shells, navigation, forms, feedback, …).
