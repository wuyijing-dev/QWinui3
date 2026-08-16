# InfoBarHost

Stacks InfoBars in a host region.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/InfoBarHost.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/InfoBarHost.qml)

**Category:** Dialogs & flyouts · **Library:** v1.19

[← Component index](../components.md)

**Gallery:** `InfoBarHost` — [`src/gallery/pages/InfoBarHostPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/InfoBarHostPage.qml)

**Extends** `Control`.

## Example

```qml
InfoBarHost {
    id: host
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
}
// later:
host.info(qsTr("Saved"))
host.error(qsTr("Failed"), qsTr("Retry"))
// --- API ---
// methods: info/success/warning/error, enqueue, clear
```

## Notes

Stack host for InfoBar; prefer info/success/warning/error helpers.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `maxVisible` | `int` | Max visible items before overflow |
| `count` | `int` | Item count |
| `openCount` | `int` | Number of open items |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `closeAll()` | Close all open items |
| `clearAll()` | Clear all items |
| `openAll()` | Expand / open all items |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
