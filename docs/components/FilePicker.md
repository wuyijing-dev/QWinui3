# FilePicker

Native open/save/folder dialogs for QML (no QtQuick.Dialogs).

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/FilePicker.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/FilePicker.h)

**Category:** Platform · **Library:** v3.56 · **C++ type** · **singleton**

[← Component index](../components.md)

**Gallery:** `System integration` — [`src/gallery/pages/SystemIntegrationPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SystemIntegrationPage.qml)

**Extends** `QObject`.

## Example

```qml
FilePicker.openFile(qsTr("Open"), ["All (*.*)"], function (path) { … }, Window.window)

Cancel → empty string / empty array. Pass parent Window for modal ownership
(Windows HWND; Linux portal parent_window on X11 / best-effort Wayland).
Linux: when parentWindow is omitted, focus/visible window is used (2.57).
See docs/system-integration.md · docs/platform-linux-wayland.md (1.68).
```

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `openFile(const QString &title, const QVariantList &nameFilters,
                              const QJSValue &callback, QObject *parentWindow = nullptr)` | — |
| `openFiles(const QString &title, const QVariantList &nameFilters,
                               const QJSValue &callback, QObject *parentWindow = nullptr)` | — |
| `saveFile(const QString &title, const QVariantList &nameFilters,
                              const QJSValue &callback, const QString &defaultSuffix = QString(),
                              QObject *parentWindow = nullptr)` | — |
| `openFolder(const QString &title, const QJSValue &callback,
                                QObject *parentWindow = nullptr)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
