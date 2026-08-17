# Expander

Collapsible header with expandable content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Expander.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Expander.qml)

**Category:** Other · **Library:** v2.62

[← Component index](../components.md)

**Gallery:** `Expander` — [`src/gallery/pages/ExpanderPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ExpanderPage.qml)

**Extends** `Control`.

## Example

```qml
Expander {
    title: qsTr("Details")
    Label { text: qsTr("Body") }
}

// --- API ---
// signals: onExpanding, onCollapsing
// header: string title/subtitle OR custom headerContent slot (WinUI Header)
```

## Notes

Header + expandable content; expanded / expand/collapse.
headerContent replaces the default title column when it has children.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `expanded` | `bool` | Expanded state |
| `isExpanded` | `alias` | Alias of expanded |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `headerIcon` | `var` | Header icon glyph |
| `expandDirection` | `string` | WinUI ExpandDirection: down \| up |
| `headerContent` | `alias` | WinUI Header — custom header content (replaces title/subtitle when set) |
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
