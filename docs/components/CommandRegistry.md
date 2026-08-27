# CommandRegistry

Scoped command store for CommandPalette auto-discovery (2.68 · 3.02 R1–R3).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandRegistry.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CommandRegistry.qml)

**Category:** Other · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
CommandRegistry {
    id: registry
    Component.onCompleted: {
        register({ id: "settings", title: qsTr("Settings"),
                   scope: "global", shortcut: "Ctrl+,", action: openSettings })
        register({ id: "cut", title: qsTr("Cut"), scope: "focused",
                   canExecute: function () { return hasSelection }, action: cut })
    }
}
CommandPalette { registry: registry }

// --- API ---
// scopes: global | window | page | focused  (palette merge: focused → page → window → global)
// methods: register(cmd), unregister(id), clearScope(scope),
//          commandsForPalette(), dispatch(id), setFocusedScope(id),
//          shortcutConflicts(), isEnabled(id), refreshContext()
// signals: commandsChanged(), commandDispatched(var), shortcutConflictsChanged()
```

## Notes

Dispatch order for palette merge: focused → page → window → global (2.68 D4).
Later register() with the same id replaces the prior entry.
canExecute / enabled (3.02 R3): disabled commands stay visible but cannot run.
shortcutConflicts() (3.02 R2): chords bound by two+ active commands.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `focusedScopeId` | `string` | — |
| `pageScopeId` | `string` | — |
| `windowScopeId` | `string` | — |
| `contextRevision` | `int` | Bump (or call refreshContext) when selection / page state changes so canExecute re-evaluates. |
| `conflicts` | `var` | — |

### Signals

| Signature | Description |
| --- | --- |
| `commandsChanged()` | — |
| `commandDispatched(var command)` | — |
| `shortcutConflictsChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `refreshContext()` | — |
| `normalizeShortcut(chord)` | Normalize chords for conflict compare: "ctrl+shift+k" style, sorted modifiers. |
| `register(cmd)` | — |
| `unregister(id)` | — |
| `clearScope(scope)` | — |
| `setFocusedScope(id)` | — |
| `setPageScope(id)` | — |
| `setWindowScope(id)` | — |
| `isEnabled(idOrCmd)` | Evaluate enabled + canExecute (contextRevision forces rebind when selection changes). |
| `commandsForPalette()` | Commands visible to CommandPalette (highest-priority scope first). Each row gets `enabled`. |
| `dispatch(id)` | Scoped dispatch: only runs when scope is active and canExecute allows it (3.02 R1/R3). |
| `shortcutConflicts()` | Returns [{ shortcut, normalized, commandIds: [], titles: [] }, …] |
| `commandCount()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
