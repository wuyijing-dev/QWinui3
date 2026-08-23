# ConfirmWithReason

ContentDialog with a required reason field (2.79).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ConfirmWithReason.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ConfirmWithReason.qml)

**Category:** Other · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `ContentDialog`.

## Example

```qml
ConfirmWithReason {
    id: confirm
    title: qsTr("Delete project")
    message: qsTr("Explain why this is needed.")
    onConfirmed: function (reason) { … }
}
confirm.show()
```

## Notes

Primary stays disabled until reason is non-empty (unless requireReason is false).
Use confirmed(reason) — do not shadow Dialog's parameterless accepted().

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `message` | `string` | — |
| `reasonPlaceholder` | `string` | — |
| `reason` | `string` | — |
| `requireReason` | `bool` | — |
| `minimumReasonLength` | `int` | — |

### Signals

| Signature | Description |
| --- | --- |
| `confirmed(string reason)` | / Reason text when the user confirms (keeps Dialog.accepted parameterless). |

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
