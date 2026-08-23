# CommandRegistry

Scoped command store for CommandPalette auto-discovery.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandRegistry.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CommandRegistry.qml)

**Category:** Other · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
CommandRegistry {
    id: registry
    Component.onCompleted: {
        register({ id: "settings", title: qsTr("Settings"),
                   scope: "global", action: openSettings })
    }
}
CommandPalette { registry: registry }

// --- API ---
// scopes: global | window | page | focused
// methods: register(cmd), unregister(id), clearScope(scope),
//          commandsForPalette(), dispatch(id), setFocusedScope(id)
// signals: commandsChanged(), commandDispatched(var)
```

## Notes

Dispatch order for palette merge: focused → page → window → global (2.68 D4).
Later register() with the same id replaces the prior entry.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `focusedScopeId` | `string` | — |
| `pageScopeId` | `string` | — |
| `windowScopeId` | `string` | — |

### Signals

| Signature | Description |
| --- | --- |
| `commandsChanged()` | — |
| `commandDispatched(var command)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `register(cmd)` | — |
| `unregister(id)` | — |
| `clearScope(scope)` | — |
| `setFocusedScope(id)` | — |
| `setPageScope(id)` | — |
| `setWindowScope(id)` | — |
| `commandsForPalette()` | Commands visible to CommandPalette (highest-priority scope first) |
| `dispatch(id)` | — |
| `commandCount()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
