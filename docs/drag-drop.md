# Drag-drop & clipboard (1.41)

Copy-ready patterns for **file drop**, **text copy**, and **paste**. Prefer these over ad-hoc `DropArea` / invisible `TextEdit` helpers scattered through the app.

| Surface | Module | Role |
|---------|--------|------|
| [`FileDropZone`](components/FileDropZone.md) | Extras | Fluent drop target (`text/uri-list`) |
| [`CopyButton`](components/CopyButton.md) | Extras | Copy + success glyph feedback |
| `WindowHelper.copyText` / `clipboardText` | Platform | Programmatic clipboard R/W |
| [`FilePicker`](system-integration.md) | Platform | Browse fallback when users prefer a dialog |

Gallery: **FileDropZone** · **CopyButton** · System integration (FilePicker).

Related: [system-integration.md](system-integration.md) · [window-helper.md](window-helper.md) · [platform-linux-wayland.md](platform-linux-wayland.md) · [compatibility-1xx.md](compatibility-1xx.md).

---

## File drop recipe

```qml
import QWinUI3.Extras
import QWinUI3.Platform

FileDropZone {
    title: qsTr("Drop images here")
    subtitle: qsTr("PNG / JPEG — or use Browse")
    acceptExtensions: [".png", ".jpg", ".jpeg", ".webp"]
    onFilesDropped: function (urls) {
        // urls are QUrl strings (often file:///…)
        for (var i = 0; i < urls.length; ++i)
            console.log(urls[i])
    }
}

Button {
    text: qsTr("Browse…")
    onClicked: FilePicker.openFiles(
        qsTr("Open images"),
        ["Images (*.png *.jpg *.jpeg *.webp)", "All (*.*)"],
        function (paths) {
            if (!paths || !paths.length)
                return
            // Same handler as drop — normalize to file URLs if needed
        },
        Window.window)
}
```

| Topic | Detail |
|-------|--------|
| MIME | `DropArea.keys: ["text/uri-list"]` — OS file managers / Explorer / Nautilus |
| Filter | `acceptExtensions` — lowercase suffixes; **empty = accept all** URLs (production: prefer a non-empty list — [security-trust.md](security-trust.md) **1.64**) |
| Reject | Non-matching drops are ignored (no `filesDropped`) |
| Browse | Wire `FilePicker` beside the zone — drop is not enough for keyboard / a11y / **touch** users ([touch-pointer.md](touch-pointer.md) **1.57**) |
| Paths | Drop gives URLs; FilePicker gives native paths — normalize in one place |

### Win / Linux notes

| Host | Expectation |
|------|-------------|
| **Windows** | Explorer → app drop works with `text/uri-list`. Always pass `Window.window` to FilePicker. |
| **Linux X11** | Same DropArea path. Portal FilePicker gets `parent_window`. |
| **Linux Wayland** | DnD still uses Qt DropArea; FilePicker portal parent may be empty — [platform-linux-wayland.md](platform-linux-wayland.md) (**1.68**). Prefer Solid chrome shells. |
| **Out of scope (1.41)** | Full OLE / complex shell DnD, dragging *out* of the app, custom non-file MIME productization |

Do **not** invent a second drop chrome — restyle via `title` / `subtitle` / `symbol` / Theme tokens.

---

## Clipboard — copy

### UI control (preferred in toolbars / forms)

```qml
CopyButton {
    textToCopy: apiKeyField.text
    onCopyCompleted: function (t) { /* toast / status */ }
    onCopyFailed: { /* empty payload */ }
}
```

`CopyButton` uses an offscreen `TextEdit` copy path (works without importing Platform). Icon-only: omit `text` / set empty text.

### Programmatic (shell / C++ bridge)

```qml
import QWinUI3.Platform

WindowHelper.copyText(payload)
var pasted = WindowHelper.clipboardText()
```

| Use when | Prefer |
|----------|--------|
| Visible “Copy” affordance | `CopyButton` |
| Copy from code / menu / CommandPalette | `WindowHelper.copyText` |
| Hex / color samples | `ColorPicker.copyHex()` — [pickers.md](pickers.md) |

---

## Clipboard — paste

```qml
TextField {
    id: field
    placeholderText: qsTr("Paste here")
}

Button {
    text: qsTr("Paste")
    onClicked: {
        var t = WindowHelper.clipboardText()
        if (t.length)
            field.text = t
    }
}
```

| Topic | Detail |
|-------|--------|
| Focus | Standard `TextField` / `TextArea` already handle Ctrl+V |
| Explicit Paste | Use `WindowHelper.clipboardText()` for custom Paste actions |
| Password | Respect `PasswordBox` paste policies (`canPasteClipboardContent`) — Gallery PasswordBox page |
| Secrets | Prefer `CopyButton` feedback; avoid logging clipboard contents |

---

## Pairing drop + clipboard + picker

Typical import surface:

1. **Drop** files onto `FileDropZone`  
2. **Browse** via `FilePicker.openFiles` (same processing function)  
3. **Copy path** of the last import with `CopyButton` / `WindowHelper.copyText`  
4. Optional: `WindowHelper.revealFileInFolder(path)` after save — [shell-extras.md](shell-extras.md)

```qml
function ingestPaths(paths) { /* shared */ }

FileDropZone {
    onFilesDropped: function (urls) {
        var paths = []
        for (var i = 0; i < urls.length; ++i)
            paths.push(String(urls[i]).replace(/^file:\/\//, "")) // simplify as needed
        ingestPaths(paths)
    }
}
```

URL → local path conversion should use your Qt helpers (`QUrl.toLocalFile` from C++, or a small QML util)—do not assume stripping `file://` is enough on Windows.

---

## Checklist

- [ ] `acceptExtensions` matches what FilePicker filters show  
- [ ] Browse button (or equivalent) next to every drop zone  
- [ ] One ingest function for drop + dialog  
- [ ] Copy uses `CopyButton` or `WindowHelper.copyText` — not a one-off TextEdit  
- [ ] Linux: tested under Wayland *or* documented as X11-validated — see Wayland matrix  

Out of scope: OLE compound documents, browser HTML DnD as a product API, mobile share sheets.

**Export / print the other direction:** [print-share.md](print-share.md) (**1.63**) — grabToImage → save → reveal.  
**Trust:** [security-trust.md](security-trust.md) (**1.64**) — never auto-execute drops; keep filters tight.
