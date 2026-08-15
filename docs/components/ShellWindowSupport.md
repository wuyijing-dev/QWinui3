# ShellWindowSupport

Shared install/presenter glue for ShellWindow.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ShellWindowSupport.qml`](../../src/extras/QWinUI3/Extras/ShellWindowSupport.qml)

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `Item`.

## Example

```qml
ShellWindowSupport {
    id: shellWindowSupport
    targetWindow: root; autoInstall: true
}

// --- API ---
// methods: applyChrome()
// shellWindowSupport.applyChrome()
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `targetWindow` | `var` | Window this chrome is attached to |
| `paradigm` | `int` | WindowHelper.Paradigm* kind |
| `backdrop` | `int` | WindowHelper.Backdrop* material |
| `presenter` | `int` | WindowHelper.Presenter* kind |
| `isAlwaysOnTop` | `bool` | Keep window above others |
| `autoInstall` | `bool` | Auto-apply WindowHelper chrome on complete |
| `extendsContentIntoTitleBar` | `bool` | Custom frame / extend content |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `applyChrome()` | Apply window chrome / backdrop |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors` / `x` / `y`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
