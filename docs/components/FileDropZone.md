# FileDropZone

Drag-and-drop target with Fluent empty chrome.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FileDropZone.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FileDropZone.qml)

**Category:** Media & platform · **Library:** v1.75

[← Component index](../components.md)

**Gallery:** `FileDropZone` — [`src/gallery/pages/FileDropZonePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FileDropZonePage.qml)

**Extends** `Control`.

## Example

```qml
FileDropZone {
    title: qsTr("Drop files here")
    onFilesDropped: (urls) => { … }
}

// --- API ---
// signals: onFilesDropped(var urls), onEntered, onExited
// properties: title, subtitle, symbol, acceptExtensions, isActive
```

## Notes

DropArea wrapper with dashed ElevatedChrome. acceptExtensions filters by
lowercase suffix (e.g. [".png", ".jpg"]); empty accepts all URLs.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | — |
| `subtitle` | `string` | — |
| `symbol` | `var` | — |
| `acceptExtensions` | `var` | — |
| `isActive` | `bool` | — |
| `cornerRadius` | `real` | — |

### Signals

| Signature | Description |
| --- | --- |
| `filesDropped(var urls)` | — |
| `entered()` | — |
| `exited()` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
