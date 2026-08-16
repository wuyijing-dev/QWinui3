# SettingsCard

Settings row: icon, title, description, action (Toolkit ContentAlignment).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SettingsCard.qml)

**Category:** Layout · **Library:** v1.10

[← Component index](../components.md)

**Gallery:** `SettingsCard` — [`src/gallery/pages/SettingsCardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SettingsCardPage.qml)

**Extends** `Pane`.

## Example

```qml
SettingsCard {
    title: qsTr("Dark mode")
    description: qsTr("Use a dark appearance.")
    toggle: true
    checked: Theme.dark
    onToggled: Theme.dark = checked
}

SettingsCard {
    title: qsTr("Density")
    action: ComboBox { model: [qsTr("Standard"), qsTr("Compact")] }
}

// --- API ---
// signals: onClicked, onToggled
// inherits Pane (+ Qt Quick Controls base API)
```

## Notes

Toolkit SettingsCard: Header/Description/HeaderIcon, Content + Action slots,
ContentAlignment (right|left|vertical|center), IsClickEnabled, ActionIcon chevron,
cornerRadius for ElevatedChrome.
Set toggle: true for a built-in Switch (checked / onToggled) — no action glue.
Toggle rows are one Accessible CheckBox (title + Space/Enter); the Switch is mouse-only.
Empty title/description collapse; contentAlignment "center" centers content (illustration cards).
Layout.fillWidth defaults to true inside Column/Row/Grid layouts.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text (Toolkit Header) |
| `header` | `alias` | Toolkit Header alias |
| `description` | `string` | Supporting description text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `headerIcon` | `var` | Header icon glyph / symbol (Toolkit HeaderIcon) |
| `action` | `alias` | Custom action slot (trailing control); ignored when toggle is true |
| `content` | `alias` | Content slot / children host |
| `toggle` | `bool` | Built-in Switch action (mutually exclusive with action:) |
| `checked` | `alias` | Switch checked state (when toggle is true) |
| `toggleEnabled` | `alias` | Switch enabled (when toggle is true) |
| `toggleText` | `alias` | Optional Switch text beside the thumb |
| `interactive` | `bool` | Enable hover / click interaction |
| `isClickEnabled` | `alias` | Toolkit IsClickEnabled |
| `contentAlignment` | `string` | Toolkit ContentAlignment: "right" \| "left" \| "vertical" \| "center" |
| `showChevron` | `bool` | Show trailing chevron when clickable |
| `actionIcon` | `var` | Toolkit ActionIcon — Fluent symbol for the trailing affordance |
| `actionIconGlyph` | `string` | Action icon glyph fallback |
| `cornerRadius` | `real` | Card corner radius (binds ElevatedChrome) |
| `effectiveHeaderIcon` | `string` | — |
| `effectiveActionIcon` | `string` | — |

### Signals

| Signature | Description |
| --- | --- |
| `clicked()` | Emitted when clicked |
| `toggled(bool checked)` | Emitted when the built-in Switch toggles |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Pane`

Also available (base type / Qt Quick Controls):

- `padding`
- `background`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
