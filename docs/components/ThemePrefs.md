# ThemePrefs

Persist Theme knobs via QtCore Settings (1.69).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ThemePrefs.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ThemePrefs.qml)

**Category:** Media & platform · **Library:** v2.59

[← Component index](../components.md)

**Gallery:** `Theme prefs` — [`src/gallery/pages/ThemePrefsPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ThemePrefsPage.qml)

**Extends** `Item`.

## Example

```qml
ThemePrefs {
    category: "ThemePrefs"
    Component.onCompleted: load()
}

// --- API ---
// methods: load(), save()
// Then ThemeSync.applyFromSystem() so follow* flags win over stored dark/motion.
```

## Notes

Same QSettings recipe as docs/settings-persistence.md — not a Gallery store.
Keep WindowGeometry on geometryPersistenceKey; this category is Theme only.
Branding wave 2 persist recipe: docs/theme-overrides.md (2.38).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `category` | `string` | QSettings category (not WindowGeometry) |
| `autoLoad` | `bool` | Load Theme.apply(store) on completed |
| `autoSave` | `bool` | Write Theme knobs back when they change |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `load()` | — |
| `save()` | — |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
