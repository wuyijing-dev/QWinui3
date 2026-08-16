# QML / Fluent conventions

Authoritative patterns for QWinUI3 controls and Gallery samples.

## Rounded corners vs fills

Qt Quick `clip: true` **only clips to an axis-aligned rectangle**. It does **not** follow `radius`.

- Opaque children of a rounded `Rectangle` are **not** masked to that radius.
- Progress / selection fills must set their own `radius` (usually `host.radius - borderWidth`) and inset by the border (often `anchors.margins: 1`).
- Do not rely on `clip: true` to “round” an animated bar; keep the bar inside the host bounds instead.

See Gallery **Pitfalls** for side-by-side demos (`DelayButton` / `ProgressButton` / `ProgressBar` follow the correct pattern).

## Accessible / focus

- Attach `Accessible.*` to an `Item` / `Action` / `Control`, never to a bare `Popup` / `Menu` root (prefer the chrome `Item` / `contentItem` / `MenuItem`).
- Prefer `FocusStroke` with `frameRadius` matching the control corner.
- Interactive Style controls expose `Accessible.role` / `name` / value or checked state where applicable (`Button`, `CheckBox`, `Switch`, `Slider`, `ProgressBar`, `ScrollBar`, `MenuBar`, …).
- Charts / gauges use `Accessible.Graphic` (or ProgressBar for meters) with `title` / label as `Accessible.name`.
- Composite Extras (`HeaderedTextBox`, `ChipGroup`, `StepBar`, `CommandBar`, split/drop-down buttons) expose role + keyboard arrows / Esc / F10 where the control owns navigation.
- Shell / platform windows expose `Accessible.Window` / `TitleBar`; caption buttons set explicit `Accessible.name`.
- Pure transitions, glue (`ShellWindowSupport`, `WindowResizeBorder`), and decorative chrome use `Accessible.ignored`.
- QtObject singletons (`ChartUtils`, `ContentDialogQueue`) are non-visual and omit Accessible.
- Icon-only buttons must set `Accessible.name` (prefer `toolTipText`, then `text`; glyph alone is not enough). Gallery icon demos should set `toolTipText`.
- Respect `Theme.reducedMotion` / `Theme.highContrast` (and Gallery “Follow system accessibility”).
- Keyboard: `focusPolicy: Qt.StrongFocus` + `activeFocusOnTab` for custom interactive Extras; handle arrows / Home / End / Esc where the control owns navigation.

## Extras module

- Inside `QWinUI3.Extras` QML, **do not** `import QWinUI3.Extras` (sibling types are in-module).
- Prefer Theme tokens, `FluentIcons`, and `Theme.reducedMotion` / `Theme.duration()`.

## Gallery CatalogPage

- See [`gallery-catalog-page.md`](gallery-catalog-page.md).
- Root must be **`Item`**, never `Page` (Qt 6.8 `title` / `footer` are FINAL).
- Hosts: `ToastHost` / floating chrome → `overlay`; bottom bar → `footer`; dialogs →
  `Overlay.overlay` + declare under `overlay`.

## Parent / host defaults

Prefer **host push** over parent-chain walks for layout defaults:

- `FormLayout` pushes `labelWidth` / `fieldHeaderPlacement` to `formBound` fields.
- `CommandBar` pushes `barLabelPosition` into AppBar* children.
- `SwipeControl` sets `SwipeAction.swipeControl`.

Placement helpers (`mapToItem`, `Overlay.overlay`) are fine; do not reintroduce
`while (p = p.parent)` config discovery.

## Docs

- Component API docs are generated from QML header comments: `python scripts/generate_component_docs.py`.
- Gallery smoke (static): `python scripts/gallery_smoke_check.py`.
