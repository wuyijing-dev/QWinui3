# ShellWindowSupport

Shared install/presenter glue for ShellWindow.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ShellWindowSupport.qml`](../../src/extras/QWinUI3/Extras/ShellWindowSupport.qml)

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

## Usage

```qml
ShellWindowSupport { targetWindow: root; autoInstall: true }
```

## Properties

- `targetWindow: var` — Window this chrome is attached to
- `paradigm: int` — WindowHelper.Paradigm* kind
- `backdrop: int` — WindowHelper.Backdrop* material
- `presenter: int` — WindowHelper.Presenter* kind
- `isAlwaysOnTop: bool` — Keep window above others
- `autoInstall: bool` — Auto-apply WindowHelper chrome on complete
- `extendsContentIntoTitleBar: bool` — Custom frame / extend content

## Methods

- `applyChrome()` — Apply Chrome
- `onDarkChanged()` — On Dark Changed
- `onCornerPreferenceChanged()` — On Corner Preference Changed

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
