# GeometryAndPrefsGuard

Warn when ThemeAppearanceSettings.persist=false may surprise users.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/GeometryAndPrefsGuard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/GeometryAndPrefsGuard.qml)

**Category:** Other · **Library:** v2.64

[← Component index](../components.md)

**Extends** `SettingsCard`.

## Notes

True detection of “main ThemePrefs autoSave” requires app-side wiring.
This component therefore accepts the main autoSave flag as an input.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `settingsPersistEnabled` | `bool` | Whether the Settings page is persisting changes. |
| `mainThemePrefsAutoSave` | `bool` | Whether the main window is persisting theme via ThemePrefs. |
| `prefsCategoryMatches` | `bool` | If both are written into the same prefs category, mismatch is more confusing. |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
