# Files on Linux (2.57)

Targeted fixes for **portal pick / drop / reveal** footguns on Linux — building on **1.68** / **1.79** / **2.53** field data.

Related: [platform-linux-wayland.md](platform-linux-wayland.md) · [system-integration.md](system-integration.md) · [drag-drop.md](drag-drop.md)

---

## Goal

Product apps ship **FilePicker**, **FileDropZone**, and **reveal-in-folder** on Linux but hit three recurring failures: **missing parent window**, **reveal opens wrong/no folder**, and **silent drop reject**. **2.57** closes the top three with small platform + control fixes.

---

## Top 3 footguns (fixed in 2.57)

| # | Symptom | Cause | Fix |
|---|---------|-------|-----|
| **1** | File dialog not modal on Wayland | `FilePicker.*` called without `Window.window` | **Focus/visible window fallback** via `LinuxPortal::resolveParentObject`; still warn when `parent_window` empty |
| **2** | Reveal after Save does nothing (GNOME) | `OpenURI` fallback had no portal parent | **`revealFileInFolder(path, Window.window)`** passes `parent_window` to portal |
| **3** | Drop looks broken — no feedback | MIME/extension reject with no chrome change | **`FileDropZone.isDragRejected`** + **`dragRejected`** signal |

**Out:** Full xdg-foreign on every Qt build; Flatpak sandbox policy; WebView2 download presets (defer).

---

## Deliverables

| Item | Location |
|------|----------|
| Parent fallback | `LinuxPortal::resolveParentObject` · `FilePicker` portal path |
| Reveal parent | `WindowHelper.revealFileInFolder(path, parentWindow?)` |
| Drop reject UX | **`FileDropZone`**: `isDragRejected`, border highlight |
| Field matrix bump | [platform-linux-wayland.md](platform-linux-wayland.md) **2.57** |
| Gallery refresh | **System integration** · **FileDropZone** · **Pitfalls** **2.57** |

---

## App checklist

- [ ] Always pass **`Window.window`** to **`FilePicker.open*`** / **`saveFile`** / **`openFolder`**
- [ ] After save: **`WindowHelper.revealFileInFolder(path, Window.window)`**
- [ ] **`FileDropZone`**: set **`acceptExtensions`** + **`acceptMimeTypes`**; handle **`dragRejected`**
- [ ] Same ingest function for drop and browse — [drag-drop.md](drag-drop.md)
- [ ] Bootstrap: **`QWinUI3::configureEnvironment`** before **`QGuiApplication`**
- [ ] Field soak: KDE Plasma Wayland + GNOME — [platform-linux-wayland.md](platform-linux-wayland.md) regression suite

**Next:** **2.58** OSK in apps · **2.59** named slow flows
