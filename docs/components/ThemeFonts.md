# ThemeFonts

icon/mono registration + WinUI LanguageFont-style UI stacks.

`import QWinUI3.Theme` · [`src/theme/QWinUI3/Theme/ThemeFonts.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/theme/QWinUI3/Theme/ThemeFonts.h)

**Category:** Theme · **Library:** v3.56 · **C++ type** · **singleton**

[← Component index](../components.md)

**Gallery:** `Iconography` — [`src/gallery/pages/FontIconPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FontIconPage.qml)

**Extends** `QObject`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `iconFamily` | `QString` | — |
| `monoFamily` | `QString` | — |
| `monoFont` | `QFont` | — |
| `iconFont` | `QFont` | — |
| `iconFontLoaded` | `bool` | — |
| `uiFamily` | `QString` | — |
| `uiFamilies` | `QStringList` | — |
| `textFamilies` | `QStringList` | — |
| `displayFamilies` | `QStringList` | — |
| `uiFont` | `QFont` | — |
| `uiLocale` | `QString` | — |
| `revision` | `int` | — |

### Signals

| Signature | Description |
| --- | --- |
| `uiFontsChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `monoFontFor(int pixelSize) const)` | — |
| `iconFontFor(int pixelSize) const)` | — |
| `uiFontFor(int pixelSize) const)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
