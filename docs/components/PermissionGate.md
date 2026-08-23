# PermissionGate

Show/enable children by role (2.71).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PermissionGate.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/PermissionGate.qml)

**Category:** Other · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `PermissionGate` — [`src/gallery/pages/PermissionGatePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PermissionGatePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
PermissionGate {
    currentRole: "viewer"
    allowedRoles: ["admin", "editor"]
    mode: "hide"   // hide | disable
    Button { text: qsTr("Delete") }
}
```

## Notes

Declarative UX gate only — enforce authorization on the server / app model.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `currentRole` | `string` | — |
| `allowedRoles` | `var` | — |
| `mode` | `string` | hide \| disable (case-insensitive) |
| `allowed` | `bool` | — |
| `contentData` | `alias` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
