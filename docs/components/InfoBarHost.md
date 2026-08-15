# InfoBarHost

Stacks InfoBars in a host region.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/InfoBarHost.qml`](../../src/extras/QWinUI3/Extras/InfoBarHost.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
InfoBarHost { id: bars }
// bars.enqueue({ title: "Hi", severity: InfoBar.Informational })

// --- API ---
// methods: closeAll(), clearAll(), openAll()
// infoBarHost.closeAll()
// infoBarHost.clearAll()
// infoBarHost.openAll()
```

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
