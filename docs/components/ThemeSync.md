# ThemeSync

Copy OS accessibility / color scheme into Theme knobs.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/ThemeSync.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/ThemeSync.qml)

**Category:** Platform · **Library:** v2.52

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
ThemeSync {
    targetWindow: window
}

// --- API ---
// methods: applyFromSystem()
// StandardWindow / ShellWindow attach this when syncThemeFromSystem is true (1.69).
```

## Notes

Item (not QtObject) so Connections can be children. Zero size / not visible.
Not a Gallery privilege — any StandardWindow / ShellWindow does this.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `targetWindow` | `var` | Window whose onActiveChanged retriggers a copy (optional). |
| `enabled` | `bool` | When false, never write Theme from the OS. |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `applyFromSystem()` | Refresh WindowHelper SPI and copy into Theme when the matching follow* flags are on. |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
