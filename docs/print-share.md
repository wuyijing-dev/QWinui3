# Print, share & export (1.63)

LoB pattern for **“send this view somewhere”** without a QWinUI3 print engine. Prefer **grab → save → reveal** over inventing a second chrome stack.

| Step | Tool | Module |
|------|------|--------|
| Capture | `Item.grabToImage` | Qt Quick |
| Choose path | `FilePicker.saveFile` | Platform |
| Show in folder | `WindowHelper.revealFileInFolder` | Platform |
| Optional print | Qt **PrintSupport** (`QPrinter`) in **your** app | Not a QWinUI3 dependency |

Gallery: **Print / share / export** (`PrintSharePage`).

Related: [system-integration.md](system-integration.md) · [drag-drop.md](drag-drop.md) · [shell-extras.md](shell-extras.md) · [window-helper.md](window-helper.md) · [platform-linux-wayland.md](platform-linux-wayland.md).

**Out of scope (1.63):** built-in PDF product, cloud share providers, screenshot farms (`python scripts/smoke_gallery.py` visual subset is separate).

---

## Recipe A — Export a view as PNG

```qml
import QtQuick
import QWinUI3.Platform

Item {
    id: exportRoot
    // … the chrome or chart you want to capture …

    function exportPng() {
        FilePicker.saveFile(
            qsTr("Export PNG"),
            ["PNG (*.png)", "All (*.*)"],
            function (path) {
                if (!path || !path.length)
                    return // cancelled
                exportRoot.grabToImage(function (result) {
                    if (!result || !result.saveToFile(path)) {
                        console.warn("export failed", path)
                        return
                    }
                    if (!WindowHelper.revealFileInFolder(path))
                        console.warn("reveal failed", path)
                })
            },
            "png",
            Window.window)
    }
}
```

| Topic | Detail |
|-------|--------|
| Size | Grab uses the item’s current size (including DPR). Prefer a fixed export host if you need stable pixels. |
| Timing | Call after layout/polish; for animated content set `Theme.reducedMotion` or wait a frame. |
| Filters | Always pass `Window.window` to FilePicker (HWND / portal parent). |
| Reveal | After save, `revealFileInFolder` lands the user on the file — [shell-extras.md](shell-extras.md). |

---

## Recipe B — Share path (clipboard / drop)

Once you have a file path:

```qml
WindowHelper.copyText(path)           // clipboard — docs/drag-drop.md
// or CopyButton { textToCopy: path }
```

Dragging *out* of the app / OLE shell DnD remains out of scope (same as [drag-drop.md](drag-drop.md)).

---

## Recipe C — Print / PDF via Qt PrintSupport (app-side)

QWinUI3 does **not** link Qt PrintSupport. Apps that need system print dialogs or PDF writers:

1. Enable PrintSupport in **your** CMake (`find_package(Qt6 COMPONENTS PrintSupport)`).
2. Grab to an image (Recipe A) **or** paint with `QPainter` on `QPrinter`.
3. On Linux, PDF via `QPrinter::PdfFormat` is often more reliable than a physical printer from CI/headless hosts.

Sketch (C++):

```cpp
#include <QPrinter>
#include <QPainter>
#include <QImage>

bool printImage(const QImage &img, const QString &pdfPath)
{
    QPrinter printer(QPrinter::HighResolution);
    if (!pdfPath.isEmpty()) {
        printer.setOutputFormat(QPrinter::PdfFormat);
        printer.setOutputFileName(pdfPath);
    }
    QPainter p(&printer);
    if (!p.isActive())
        return false;
    const QRect r = printer.pageRect(QPrinter::DevicePixel).toRect();
    p.drawImage(r, img);
    return true;
}
```

Then reveal the PDF with `WindowHelper.revealFileInFolder` from QML after the C++ call returns the path.

---

## Win / Linux caveats

| Host | Expectation |
|------|-------------|
| **Windows** | FilePicker uses `IFileDialog`; reveal uses Explorer `/select`. Grab needs a visible / realized item. |
| **Linux X11** | Portal FilePicker gets `parent_window`. Reveal best-effort via FileManager DBus / open parent dir. |
| **Linux Wayland** | Pass `Window.window` anyway; portal parent may be empty — [platform-linux-wayland.md](platform-linux-wayland.md). Prefer Solid chrome shells. |
| **Headless / CI** | `--smoke` / offscreen: do not expect interactive FilePicker; use Recipe A only in interactive Gallery. |
| **PrintSupport** | Optional app dependency — not redistributed by QWinUI3 shared zips. |

---

## Checklist

- [ ] Export uses `grabToImage` + `FilePicker.saveFile` + `revealFileInFolder`
- [ ] FilePicker always gets `Window.window`
- [ ] No cloud share SDK required for the LoB path
- [ ] Print/PDF only if the app already owns PrintSupport
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) for this minor

---

## Related Gallery

| Page | Role |
|------|------|
| **Print / share / export** | Interactive grab + save + reveal |
| **System integration** | FilePicker / reveal demos |
| **FileDropZone** | Import side of the pipe |
| **CopyButton** | Path / text clipboard |
