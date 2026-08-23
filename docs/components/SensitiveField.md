# SensitiveField

Masked field with reveal toggle for tokens / secrets (2.79).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SensitiveField.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SensitiveField.qml)

**Category:** Other · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `PasswordBox`.

## Example

```qml
SensitiveField {
    header: qsTr("API token")
    placeholderText: qsTr("••••••••")
}
```

## Notes

Thin PasswordBox alias for non-login secrets (API keys, tokens). Same reveal UX.

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
