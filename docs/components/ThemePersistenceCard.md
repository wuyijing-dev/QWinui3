# ThemePersistenceCard

Product-friendly wrapper for ThemeAppearanceSettings.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ThemePersistenceCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ThemePersistenceCard.qml)

**Category:** Media & platform · **Library:** v2.66

[← Component index](../components.md)

**Extends** `ThemeAppearanceSettings`.

## Example

```qml
Differences vs raw ThemeAppearanceSettings:
- defaults persist=true (so “users expect it to save”)
- renames the section header for LoB shells
```

## Notes

For Gallery / demo pages that intentionally avoid persisting across runs,
prefer ThemeAppearanceSettings { persist: false } explicitly (see gallery-shell).

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
