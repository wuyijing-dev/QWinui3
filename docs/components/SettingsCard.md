# SettingsCard

Settings row: icon, title, description, action.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsCard.qml`](../../src/extras/QWinUI3/Extras/SettingsCard.qml)

[← Component index](../components.md)

**Extends** `Pane`.

## Example

```qml
SettingsCard {
    title: qsTr("Dark mode")
    action: Switch { checked: Theme.dark; onToggled: Theme.dark = checked }
}

// --- API ---
// signals: onClicked
// inherits Pane (+ Qt Quick Controls base API)
```

## Notes

Settings row card with symbol, title, description, and trailing content slot.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `description` | `string` | Supporting description text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `headerIcon` | `var` | Header icon glyph |
| `action` | `alias` | Custom action slot |
| `content` | `alias` | Content slot / children host |
| `interactive` | `bool` | Enable hover / click interaction |
| `showChevron` | `bool` | Show trailing chevron |
| `effectiveHeaderIcon` | `string` | Resolved header icon |

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
