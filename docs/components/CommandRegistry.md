# CommandRegistry

Scoped command store for CommandPalette auto-discovery.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandRegistry.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CommandRegistry.qml)

**Category:** Commands · **Library:** v2.68

[← Component index](../components.md)

## Example

```qml
CommandRegistry {
    id: registry
    Component.onCompleted: {
        register({
            id: "settings",
            title: qsTr("Settings"),
            scope: "global",
            action: openSettings
        })
    }
}
CommandPalette {
    registry: registry
    commands: [ /* manual extras */ ]
}
```

## Notes

Scopes: `global` | `window` | `page` | `focused`. Palette merge order: focused → page → window → global, then the manual `commands` list (2.68 D4).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `focusedScopeId` | `string` | Active focused scope filter |
| `pageScopeId` | `string` | Active page scope filter |
| `windowScopeId` | `string` | Active window scope filter |

### Signals

| Signature | Description |
| --- | --- |
| `commandsChanged()` | Registry contents changed |
| `commandDispatched(var command)` | After a successful `dispatch` |

### Methods

| Signature | Description |
| --- | --- |
| `register(cmd)` | Add or replace by `id` |
| `unregister(id)` | Remove by id |
| `clearScope(scope)` | Drop all commands in a scope |
| `commandsForPalette()` | Active commands for palette merge |
| `dispatch(id)` | Run action for id |
| `setFocusedScope(id)` / `setPageScope(id)` / `setWindowScope(id)` | Scope filters |
