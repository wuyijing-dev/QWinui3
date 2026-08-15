# SettingsExpander

Expandable settings group.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsExpander.qml`](../../src/extras/QWinUI3/Extras/SettingsExpander.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
SettingsExpander {
    title: qsTr("Advanced")
    SettingsCard { title: qsTr("Option") }
}

// --- API ---
// signals: onExpanding, onCollapsing
```

## Notes

Expander styled as a settings group; header + nested SettingsCard children.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `description` | `string` | Supporting description text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `headerIcon` | `var` | Header icon glyph |
| `expanded` | `bool` | Expanded state |
| `isExpanded` | `alias` | Alias of expanded |
| `expandDirection` | `string` | WinUI ExpandDirection: down \| up |
| `action` | `alias` | Custom action slot |
| `contentData` | `alias` | Default children / content slot |
| `effectiveHeaderIcon` | `string` | Resolved header icon |

### Signals

| Signature | Description |
| --- | --- |
| `expanding()` | True while expanding |
| `collapsing()` | True while collapsing |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
