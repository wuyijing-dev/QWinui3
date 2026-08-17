# IconSource

Resolve FluentIcons symbol or glyph string.

`import QWinUI3.Theme` · [`src/theme/QWinUI3/Theme/IconSource.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/theme/QWinUI3/Theme/IconSource.qml)

**Category:** Theme · **Library:** v1.72

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `QtObject`.

## Example

```qml
IconSource.resolve(symbol, iconGlyph)

// --- API ---
// methods: isRawGlyph(value), toPascalCase(name), lookupName(name), resolve(value, fallback), has(value)
// iconSource.isRawGlyph(value)
// iconSource.toPascalCase(name)
// iconSource.lookupName(name)
// iconSource.resolve(value, fallback)
```

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `isRawGlyph(value)` | True when iconGlyph is a raw glyph (not a symbol name) |
| `toPascalCase(name)` | Convert an identifier to PascalCase |
| `lookupName(name)` | Resolve a Fluent icon name |
| `resolve(value, fallback)` | value: FluentIcons.X \| "Save" \| "\uE74E" \| codepoint \| { glyph\|symbol\|icon\|name } |
| `has(value)` | True when the named case / key exists |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
