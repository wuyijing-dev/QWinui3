# CaptionButton

Native-chrome caption min/max/close button.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/CaptionButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/CaptionButton.qml)

**Category:** Platform · **Library:** v1.52

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `AbstractButton`.

## Example

```qml
CaptionButton { glyph: FluentIcons.ChromeClose }

// --- API ---
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `glyph` | `string` | Fluent glyph drawn in the button |
| `destructive` | `bool` | Use destructive (close) colors |
| `forceHovered` | `bool` | Drive hover visuals from outside |
| `forcePressed` | `bool` | Drive pressed visuals from outside |
| `interactive` | `bool` | Enable hover / click interaction |
| `backgroundColor` | `color` | Rest background |
| `hoverColor` | `color` | Hover background |
| `pressedColor` | `color` | Pressed background |
| `foregroundColor` | `color` | Glyph / content color |
| `visualHovered` | `bool` | Effective hovered visual |
| `visualPressed` | `bool` | Effective pressed visual |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
