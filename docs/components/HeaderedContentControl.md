# HeaderedContentControl

Labeled content host.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HeaderedContentControl.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/HeaderedContentControl.qml)

**Category:** Input & forms · **Library:** v1.08

[← Component index](../components.md)

**Gallery:** `HeaderedContentControl` — [`src/gallery/pages/HeaderedContentControlPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/HeaderedContentControlPage.qml)

**Extends** `Control`.

## Example

```qml
HeaderedContentControl {
    id: block
    header: qsTr("Account")
    Label { text: qsTr("Body content") }
}
// --- API ---
// block.header / content
```

## Notes

Header label + content slot; headerPlacement controls layout.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `headerComponent` | `Component` | Optional header component |
| `headerPlacement` | `string` | top \| left |
| `contentData` | `alias` | Default children / content slot |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
