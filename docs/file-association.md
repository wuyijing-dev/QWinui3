# File association helper (3.09 · P3)

Opt-in registration so a product app can own an extension without shipping installer MSI logic for every soak.

**API:** `WindowHelper.registerFileAssociation` / `unregisterFileAssociation` — [WindowHelper](components/WindowHelper.md)

## Windows (HKCU)

Writes under `HKEY_CURRENT_USER\Software\Classes` (no elevation):

| Key | Value |
|-----|--------|
| `.ext` | `progId` |
| `progId` (default) | friendly name |
| `progId\shell\open\command` | `"path\to\app.exe" "%1"` (or your `openCommand`) |

```qml
WindowHelper.registerFileAssociation(
    ".qwinnote",
    "QWinUI3.Note",
    qsTr("QWinUI3 note"),
    "")  // empty → applicationFilePath + " \"%1\""
WindowHelper.unregisterFileAssociation(".qwinnote", "QWinUI3.Note")
```

Pair with **RecentFiles** + `WindowHelper.addToRecentDocuments` for Jump List / recent docs (**P2**).

## Linux

Writes `~/.local/share/applications/<progId>.desktop` with a synthetic `MimeType=application/x-extension-<ext>` and best-effort `xdg-mime default …`. Portals and desktop environments vary — treat as a **recipe**, not a guarantee of every file manager.

Also set `WindowHelper.setDesktopFileName(appId)` / `Bootstrap` app id so Wayland `app_id` matches the desktop file stem.

## MenuStatusWindow (**P1**)

Native menu bridge is the existing **MenuStatusWindow** shell (`menusInTitleBar`, **MenuBar**, **StatusBar`). Gallery **Window shells** page demos it. On Linux, prefer `BackdropSolid` and soak menu open/close under Wayland — see [window-shells.md](window-shells.md).

## Out of scope

- Machine-wide (HKLM) registration
- Auto-update SaaS
- macOS Launch Services
