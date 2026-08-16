# SettingsCard

Settings row: icon, title, description, action (Toolkit ContentAlignment).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsCard.qml`](../../src/extras/QWinUI3/Extras/SettingsCard.qml)

[← Component index](../components.md)

**Extends** `Pane`.

## Example

```qml
SettingsCard {
    header: qsTr("Dark mode")
    description: qsTr("Use a dark appearance.")
    contentAlignment: "right"
    isClickEnabled: false
    action: Switch { checked: Theme.dark; onToggled: Theme.dark = checked }
}

// --- API ---
// signals: onClicked
// inherits Pane (+ Qt Quick Controls base API)
```

## Notes

Toolkit SettingsCard: Header/Description/HeaderIcon, Content + Action slots,
ContentAlignment (right|left|vertical), IsClickEnabled, ActionIcon chevron,
cornerRadius for ElevatedChrome.

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
| `action` | `alias` | Custom action slot (trailing control) |
| `content` | `alias` | Content slot / children host |
| `interactive` | `bool` | Enable hover / click interaction |
| `isClickEnabled` | `alias` | Toolkit IsClickEnabled |
| `contentAlignment` | `string` | Toolkit ContentAlignment: "right" \| "left" \| "vertical" |
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

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Pane`

Also available (base type / Qt Quick Controls):

- `padding`
- `background`
- `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
