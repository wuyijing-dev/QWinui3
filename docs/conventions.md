# QML / Fluent conventions

Authoritative patterns for QWinUI3 controls and Gallery samples.

## Rounded corners vs fills

Qt Quick `clip: true` **only clips to an axis-aligned rectangle**. It does **not** follow `radius`.

- Opaque children of a rounded `Rectangle` are **not** masked to that radius.
- Progress / selection fills must set their own `radius` (usually `host.radius - borderWidth`) and inset by the border (often `anchors.margins: 1`).
- Do not rely on `clip: true` to “round” an animated bar; keep the bar inside the host bounds instead.

See Gallery **Pitfalls** for side-by-side demos (`DelayButton` / `ProgressButton` / `ProgressBar` follow the correct pattern).

## Accessible / focus

- Attach `Accessible.*` to an `Item` / `Action` / `Control`, never to a bare `Popup` / `Menu`.
- Prefer `FocusStroke` with `frameRadius` matching the control corner.

## Extras module

- Inside `QWinUI3.Extras` QML, **do not** `import QWinUI3.Extras` (sibling types are in-module).
- Prefer Theme tokens, `FluentIcons`, and `Theme.reducedMotion` / `Theme.duration()`.

## Docs

- Component API docs are generated from QML header comments: `python scripts/generate_component_docs.py`.
