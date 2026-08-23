# FileDropZone

Drag-and-drop target with Fluent empty chrome.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FileDropZone.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FileDropZone.qml)

**Category:** Media & platform · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `FileDropZone` — [`src/gallery/pages/FileDropZonePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FileDropZonePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
FileDropZone {
    title: qsTr("Drop files here")
    acceptExtensions: [".png", ".jpg"]
    acceptMimeTypes: ["image/png", "image/jpeg"]
    onFilesDropped: (urls) => { … }
}

// --- API ---
// signals: onFilesDropped(var urls), onEntered, onExited
// properties: title, subtitle, symbol, acceptExtensions, acceptMimeTypes, isActive
```

## Notes

DropArea wrapper with dashed ElevatedChrome. acceptExtensions filters by
lowercase suffix; acceptMimeTypes (2.13) filters drag MIME when reported.
Empty acceptExtensions = accept all URLs; pair both filters in production.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | — |
| `subtitle` | `string` | — |
| `symbol` | `var` | — |
| `acceptExtensions` | `var` | — |
| `acceptMimeTypes` | `var` | — |
| `isActive` | `bool` | — |
| `isDragRejected` | `bool` | — |
| `cornerRadius` | `real` | — |

### Signals

| Signature | Description |
| --- | --- |
| `filesDropped(var urls)` | — |
| `entered()` | — |
| `exited()` | — |
| `dragRejected()` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
