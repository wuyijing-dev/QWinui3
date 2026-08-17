# ThemeAppearanceSettings

Drop-in SettingsGroup for Theme knobs (1.69).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ThemeAppearanceSettings.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ThemeAppearanceSettings.qml)

**Category:** Layout · **Library:** v2.55

[← Component index](../components.md)

**Extends** `SettingsGroup`.

## Example

```qml
SettingsView {
    ThemeAppearanceSettings {
        persist: true
        prefsCategory: "MyAppTheme"
    }
}

// --- API ---
// persist / prefsCategory / showCopyRecipe
// Copy recipe uses Theme.recipeText() — paste into any app; not Gallery-only.
```

## Notes

Same cards Gallery Settings uses. Follow-system apply is ThemeSync (shells).
persist writes ThemePrefs (docs/settings-persistence.md).
Branding wave 2: accent packs + contrast/density — docs/theme-overrides.md (2.38).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `persist` | `bool` | Persist via ThemePrefs (QSettings). Off by default so demos do not fight each other. |
| `prefsCategory` | `string` | — |
| `showCopyRecipe` | `bool` | — |
| `recipeSnippet` | `string` | — |
| `prefs` | `ThemePrefs` | — |
| `systemSync` | `ThemeSync` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
