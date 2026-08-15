# IconSource

Resolve FluentIcons symbol or glyph string.

`import QWinUI3.Theme` · [`src/theme/QWinUI3/Theme/IconSource.qml`](../../src/theme/QWinUI3/Theme/IconSource.qml)

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

## Usage

```qml
IconSource.resolve(symbol, iconGlyph)
```

## Methods

- `isRawGlyph(value)` — True when iconGlyph is a raw glyph (not a symbol name)
- `toPascalCase(name)` — Convert an identifier to PascalCase
- `lookupName(name)` — Resolve a Fluent icon name
- `resolve(value, fallback)` — value: FluentIcons.X | "Save" | "\uE74E" | codepoint | { glyph|symbol|icon|name }
- `has(value)` — True when the named case / key exists

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
