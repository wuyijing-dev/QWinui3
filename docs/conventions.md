# QML / Fluent conventions

Authoritative patterns for QWinUI3 controls and Gallery samples.

## Rounded corners vs fills

Qt Quick `clip: true` **only clips to an axis-aligned rectangle**. It does **not** follow `radius`.

- Opaque children of a rounded `Rectangle` are **not** masked to that radius.
- Progress / selection fills must set their own `radius` (usually `host.radius - borderWidth`) and inset by the border (often `anchors.margins: 1`).
- Do not rely on `clip: true` to “round” an animated bar; keep the bar inside the host bounds instead.

See Gallery **Pitfalls** for side-by-side demos (`DelayButton` / `ProgressButton` / `ProgressBar` follow the correct pattern).

## Accessible / focus

- Attach `Accessible.*` only to an `Item` / `Action` / `Control`. Never attach to `Window` / `ApplicationWindow` / `Popup` / `Menu` / `Dialog` / `Drawer` / `ToolTip` (they are not Items). Qt already exposes popup chrome via `popupItem`; name interactive children (`MenuItem`, buttons, labels) instead of the popup host.
- Prefer `FocusStroke` with `frameRadius` matching the control corner.
- Interactive Style controls expose `Accessible.role` / `name` / checked state / description where applicable. Do **not** set `Accessible.value` / `valueMinimum` / `valueMaximum` — those attached properties were removed in Qt 6.8; put numeric state in `Accessible.description` (controls with a real `value` property are still exposed via Qt’s value interface).
- Charts / gauges use `Accessible.Graphic` (or ProgressBar for meters) with `title` / label as `Accessible.name`.
- Composite Extras (`HeaderedTextBox`, `ChipGroup`, `StepBar`, `CommandBar`, split/drop-down buttons) expose role + keyboard arrows / Esc / F10 where the control owns navigation.
- Selection composites (`RadioButtons`, `SelectorBar`, `PagerControl`, `ChipGroup`, `ItemsView`) use roving tabindex: one host `StrongFocus`, children `NoFocus`, so arrows reach the group.
- Title bars / caption buttons set `Accessible` on Item chrome (`PlatformTitleBar`, `CaptionButton`), not on `ApplicationWindow`.
- Pure transitions, glue (`ShellWindowSupport`, `WindowResizeBorder`), and decorative chrome use `Accessible.ignored`.
- QtObject singletons (`ChartUtils`, `ContentDialogQueue`) are non-visual and omit Accessible.
- Icon-only buttons must set `Accessible.name` (prefer `toolTipText`, then `text`; glyph alone is not enough). Gallery icon demos should set `toolTipText`.
- Respect `Theme.reducedMotion` / `Theme.highContrast` (and Gallery “Follow system accessibility” / **Accessibility** catalog page).
- Keyboard: `focusPolicy: Qt.StrongFocus` + `activeFocusOnTab` for custom interactive Extras; handle arrows / Home / End / Esc where the control owns navigation. Date/time pickers open with Space / Enter / F4 / Alt+Down.

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

## Packaging

- Release shared libs: `python scripts/package_release_libs.py --shared`
- Default builds stay STATIC; SHARED via `-DQWINUI3_BUILD_SHARED=ON`.
- Project license: **LGPL-3.0** (`LICENSE` + `COPYING`).

## Docs

- Component API docs are generated from QML header comments: `python scripts/generate_component_docs.py`.
