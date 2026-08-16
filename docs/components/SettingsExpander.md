# SettingsExpander

Expandable settings group.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsExpander.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SettingsExpander.qml)

**Category:** Layout · **Library:** v1.06

[← Component index](../components.md)

**Gallery:** `SettingsExpander` — [`src/gallery/pages/SettingsExpanderPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SettingsExpanderPage.qml)

**Extends** `Control`.

## Example

```qml
SettingsExpander {
    title: qsTr("Advanced")
    toggle: true
    checked: true
    SettingsCard { title: qsTr("Option"); toggle: true }
}

// --- API ---
// signals: onExpanding, onCollapsing, onToggled
```

## Notes

Expander styled as a settings group; header + nested SettingsCard children.
Set toggle: true for a built-in Switch (same API as SettingsCard).

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
| `action` | `alias` | Custom action slot; ignored when toggle is true |
| `toggle` | `bool` | Built-in Switch action (mutually exclusive with action:) |
| `checked` | `alias` | Switch checked state (when toggle is true) |
| `toggleEnabled` | `alias` | Switch enabled (when toggle is true) |
| `toggleText` | `alias` | Optional Switch text |
| `contentData` | `alias` | Default children / content slot |
| `effectiveHeaderIcon` | `string` | Resolved header icon |

### Signals

| Signature | Description |
| --- | --- |
| `expanding()` | True while expanding |
| `collapsing()` | True while collapsing |
| `toggled(bool checked)` | Emitted when the built-in Switch toggles |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
