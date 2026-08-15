# CaptionButton

Native-chrome caption min/max/close button.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/CaptionButton.qml`](../../src/platform/QWinUI3/Platform/CaptionButton.qml)

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

## Usage

```qml
CaptionButton { glyph: FluentIcons.ChromeClose }
```

## Properties

- `glyph: string` — Fluent glyph drawn in the button
- `destructive: bool` — Use destructive (close) colors
- `forceHovered: bool` — Drive hover visuals from outside
- `forcePressed: bool` — Drive pressed visuals from outside
- `interactive: bool` — Enable hover / click interaction
- `backgroundColor: color` — Rest background
- `hoverColor: color` — Hover background
- `pressedColor: color` — Pressed background
- `foregroundColor: color` — Glyph / content color
- `visualHovered: bool` — Effective hovered visual
- `visualPressed: bool` — Effective pressed visual

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
