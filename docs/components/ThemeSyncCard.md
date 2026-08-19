# ThemeSyncCard

Summarize ThemeSync vs ThemePrefs vs persist:false semantics.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ThemeSyncCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ThemeSyncCard.qml)

**Category:** Media & platform · **Library:** v2.64

[← Component index](../components.md)

**Extends** `SettingsGroup`.

## Notes

ThemeSync copies WindowHelper system a11y / color scheme into Theme knobs.
ThemePrefs persists those knobs via QSettings (category).
ThemeAppearanceSettings.persist controls whether its internal ThemePrefs autoSave.

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
