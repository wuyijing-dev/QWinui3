# Security & trust boundaries (1.64 · wave 2 **2.13** · wave 3 **2.36**)

What QWinUI3 **hosts** versus what **your app must own**. This is a trust-boundary cookbook — **not** a claim that the kit is a hardened sandbox product.

| Surface | Kit provides | App must own |
|---------|--------------|--------------|
| [`WebView2Host`](webview2.md) | HWND Edge host + user-data folder under app local data | Which URLs load; Runtime install; no multi-profile / custom Environment yet |
| [`FileDropZone`](drag-drop.md) | Suffix filter (`acceptExtensions`) + optional MIME filter (`acceptMimeTypes`, **2.13**) | Empty filters = accept all; never execute dropped paths; normalize URLs |
| [`FilePicker`](system-integration.md) | Native open/save/folder + parent window ownership | Validate paths; pass `Window.window`; treat cancel as empty |
| [`FileTree`](tree-data.md) / [`TreeDataGrid`](tree-data.md) (**2.36**) | Renders folder labels + row objects you supply | Path validation before open/reveal/execute; row text is not a security fence |
| Clipboard / reveal | `WindowHelper` / `CopyButton` / `revealFileInFolder` | Don’t put secrets in clipboard without user intent |

Gallery: **Security & trust** · **Pitfalls** · **WebView2** · **FileDropZone** · **FileTree** · **TreeDataGrid** · **System integration**.

Related: [webview2.md](webview2.md) · [drag-drop.md](drag-drop.md) · [system-integration.md](system-integration.md) · [print-share.md](print-share.md) · [stable-api.md](stable-api.md).

**Out of scope (1.64 / 2.13):** rewriting WebView2Host into a built-in allowlist API; claiming OS-level sandboxing; encrypted vault / DRM products; content sniffing / AV inside the kit.

---

## Wave 2 summary (**2.13**)

| Area | Deliverable |
|------|-------------|
| **WebView2** | Three app-side navigation policy patterns (fixed URL, https-only, host allowlist) |
| **FileDropZone** | `acceptMimeTypes` — MIME / wildcard filter when the OS reports formats |
| **Wayland FilePicker** | Portal `parent_window` regression checklist — [platform-linux-wayland.md](platform-linux-wayland.md) |

## Wave 3 summary (**2.36**)

| Area | Deliverable |
|------|-------------|
| **FileTree / TreeDataGrid** | Path & row trust notes for Explorer-style data surfaces — [tree-data.md](tree-data.md) |
| **WebView2 downloads** | App-side download policy patterns D/E/F (kit does not intercept `DownloadStarting`) — [webview2.md](webview2.md) |

**Out:** Code signing service; built-in WebView download API in the kit.

## Promise summary

| We will | We will not |
|---------|-------------|
| Document where WebView2 user data lives and how FilePicker/Drop filter | Block every unsafe navigation for you |
| Keep `clip: true` HWND geometry recipes honest | Ship a “secure browser” control |
| Treat cancel / empty drop as non-events | Auto-open or run dropped files |

---

## WebView2 — navigation & user data

### User-data directory

On attach, the host creates Edge user data under:

`QStandardPaths::AppLocalDataLocation` + `/WebView2Host/p` + `<pid>`

(typically `%LOCALAPPDATA%/<org>/<app>/WebView2Host/p12345` on Windows).

Each process gets its own folder so **Gallery and apps built on the kit can run multiple exe instances** without Edge locking a shared profile. Override with `WebView2Host.userDataFolder` when you deliberately want one shared profile (then keep a single instance yourself).

| Implication | Guidance |
|-------------|----------|
| Cookies / cache / local storage | Bound to **your** org/app id from `QCoreApplication`, then per-process by default |
| Multi-instance / multi-exe | Default path is safe — no kit single-instance lock |
| Shared profile (optional) | Set `userDataFolder` to a fixed path; do not open two processes against it |
| Multi-user kiosk | Different app names / data roots, or wipe the folder on logout (app policy) |
| Custom Environment / multi-profile API | **Experimental / deferred** — [stable-api.md](stable-api.md) |

### Navigation allowlists (app-side)

`WebView2Host` does **not** cancel navigations. `NavigationStarting` only flips `loading`. Users (and pages) can navigate wherever Edge allows once a document is loaded.

**App checklist:**

1. Only assign `source` / call `navigate()` with URLs you trust (allowlist hosts or `https` + known origins).
2. Do **not** bind a free-form address bar to `source` in production without validation.
3. Treat `navigationCompleted(success)` as completion, not authorization.
4. Missing Runtime → EmptyState + Evergreen link — [webview2.md](webview2.md); do not silently fall back to embedding arbitrary HTML via other engines.

```qml
readonly property var allowedHosts: ["docs.example.com", "intranet.example"]

function navigateSafe(urlString) {
    var u = Qt.resolvedUrl(urlString)
    var host = String(u.hostname || "").toLowerCase()
    if (allowedHosts.indexOf(host) < 0) {
        console.warn("blocked navigation", host)
        return
    }
    web.source = u
}
```

(Host extraction may need a small C++/JS helper for opaque URLs — keep validation in one place.)

### Navigation policy patterns (**2.13**)

`WebView2Host` still does **not** cancel navigations inside the control — copy one pattern into your shell.

**Pattern A — fixed document (safest demo / help viewer):**

```qml
WebView2Host {
    source: "https://docs.example.com/help/index.html"
    // No address bar; no navigate() from user input
}
```

**Pattern B — https-only (block `file:` / custom schemes):**

```qml
function navigateHttpsOnly(urlString) {
    var u = Qt.resolvedUrl(urlString)
    if (String(u).toLowerCase().indexOf("https://") !== 0) {
        console.warn("blocked non-https", urlString)
        return
    }
    web.source = u
}
```

**Pattern C — host allowlist (intranet + docs):**

```qml
readonly property var allowedHosts: ["docs.example.com", "intranet.example"]

function hostAllowed(urlString) {
    var s = String(urlString)
    var m = s.match(/^https?:\/\/([^/?#]+)/i)
    if (!m)
        return false
    var host = m[1].toLowerCase().replace(/^www\./, "")
    for (var i = 0; i < allowedHosts.length; ++i) {
        var h = String(allowedHosts[i]).toLowerCase()
        if (host === h || host.endsWith("." + h))
            return true
    }
    return false
}

function navigateSafe(urlString) {
    if (!hostAllowed(urlString)) {
        console.warn("blocked navigation", urlString)
        return
    }
    web.source = Qt.resolvedUrl(urlString)
}
```

Gallery **WebView2** demo uses Pattern C for its URL field (Microsoft hosts only). **Security & trust** page links here. **2.32** expands recipes in [webview2.md](webview2.md) **Navigation policy recipes**.

**New window / `target=_blank`:** Edge may open external content — treat in-app navigation the same as `source` changes; do not assume the host blocks pop-ups for you.

### Download policy (app-side, **2.36**)

`WebView2Host` does **not** expose `DownloadStarting` or cancel downloads. Edge may still offer save/open for navigations you allow.

**Policy D — prevent drive-by downloads (preferred):**

Use Pattern A (fixed URL) or Pattern C (host allowlist) so users cannot reach arbitrary download hosts inside the embedded view.

**Policy E — explicit user gesture for external fetch:**

```qml
Button {
    text: qsTr("Download release notes (browser)")
    onClicked: {
        if (!hostAllowed(trustedUrl))
            return
        Qt.openUrlExternally(trustedUrl)  // still validate — same as navigateSafe
    }
}
```

**Policy F — save only under app data with confirm (native extension):**

Until you wire CoreWebView2 `DownloadStarting` in **your** C++ layer, do not silently save to `%USERPROFILE%\\Downloads`. If you add a native handler later:

1. Restrict destinations to `QStandardPaths::AppDataLocation` / a subfolder you create.
2. Show filename + size before write; log blocked attempts.
3. Scan or block executable extensions even from allowlisted hosts.

Gallery **WebView2** documents these patterns; the demo does not intercept downloads — tight navigation policy is the fence.

See [webview2.md](webview2.md) **Download policy (2.36)** for the field matrix cross-link.

### HWND / clip

Unclipped hosts leak pixels over Fluent chrome — always nest in `clip: true` (Gallery does). This is UI integrity, not a security boundary, but mixed focus/HWND stacks confuse users into trusting the wrong chrome.

---

## FileDropZone — drop validation

| Setting | Trust effect |
|---------|----------------|
| `acceptExtensions: [".png", ".jpg"]` | Non-matching drops ignored (no `filesDropped`) |
| `acceptExtensions: []` (default) | **Accepts all** `text/uri-list` URLs — treat as open |
| `acceptMimeTypes: ["image/png", "image/jpeg"]` (**2.13**) | Rejects drags whose reported MIME formats don't match; supports `image/*` wildcards |
| Both set | Extension filter always applies on drop; MIME filter applies when OS reports formats beyond lone `text/uri-list` |

**MIME notes (2.13):**

- Many file managers only expose `text/uri-list` — suffix filtering remains the primary fence; MIME is defense-in-depth when the compositor reports types.
- Renamed `.exe` → `.png` may pass suffix checks — MIME helps when the OS sends `application/x-msdownload` etc.; **never execute** dropped paths regardless.
- `DropArea.keys` includes your MIME types + `text/uri-list`.

```qml
FileDropZone {
    acceptExtensions: [".png", ".jpg", ".webp"]
    acceptMimeTypes: ["image/png", "image/jpeg", "image/webp", "image/*"]
    onFilesDropped: ingestImages
}
```

**App checklist:**

1. Prefer a **non-empty** `acceptExtensions` list that matches your FilePicker filters.
2. Always offer **Browse** (`FilePicker`) for keyboard / a11y — [drag-drop.md](drag-drop.md).
3. Normalize `file:` URLs → local paths before `QFile` / processors; do not assume stripping `file://` is enough on Windows.
4. **Never** `QProcess::start` / shell-execute a dropped path without an explicit, confirmed user gesture and policy.
5. Size / MIME / content scanning stays in **your** ingest pipeline — the zone filters by suffix + optional MIME only.

---

## FilePicker — ownership & paths

| Host | Ownership |
|------|-----------|
| Windows | Pass `Window.window` so `IFileDialog` is HWND-owned (modal / Z-order). |
| Linux X11 | Portal gets `parent_window` when possible. |
| Linux Wayland | Parent via Qt xdg-foreign export when available (**1.79**); may still be empty — [platform-linux-wayland.md](platform-linux-wayland.md). |

### Wayland portal regression (**2.13**)

After shell / platform changes, re-smoke FilePicker modal stacking on **pure Wayland** (not only XWayland):

| Step | Pass criteria |
|------|----------------|
| Open FilePicker from app window | Dialog is modal to your app; not orphaned behind shell |
| Gallery **System integration** readout | `portal parent_window=` non-empty when xdg-foreign export works |
| Cancel | Returns empty — no stale path |
| Save dialog | Same parent as open |

Checklist lives in [platform-linux-wayland.md](platform-linux-wayland.md) · Gallery **System integration** live readout. **2.13** does not add new portal APIs — regression documentation only. **2.33** expands the suite to FilePicker + tray + idle inhibit — see **Portal & tray wave 3 regression suite**.

**App checklist:**

1. Cancel → `""` / `[]` — never treat as a path.
2. Validate extensions / directories after save/open (picker filters are UX, not a security fence).
3. After export, prefer `revealFileInFolder` over auto-opening with the shell default handler for untrusted types — [print-share.md](print-share.md).
4. Do not re-prompt into a path the user did not pick (path injection via spoofed callbacks is an app bug if you invent paths).

---

## FileTree / TreeDataGrid — path & row trust (**2.36**)

Explorer-style controls **display** folder labels and row objects from **your** model — they do not read the OS file system unless you bind one.

| Surface | Kit provides | App must own |
|---------|--------------|--------------|
| **FileTree** | Tree + table compose; `fileCatalog` keys match folder **display text** | Canonical paths before `QFile` / `QProcess` / `revealFileInFolder`; block `..` / UNC / symlink surprises in C++ |
| **TreeDataGrid** | Nested `children` rows + column roles; sort/filter | Treat cell text (`name`, `path`, …) as **untrusted display** until validated |

**App checklist:**

1. **`onFileActivated` / `onRowActivated`** — never `QProcess::start` / shell-execute on `row.name` without extension policy + explicit confirm (same rule as [FileDropZone](#filedropzone--drop-validation)).
2. **`fileCatalog` / `files` / `rows`** — demo data may include `installer.exe` under **Downloads** to show risky names in UI; production ingest must filter or confirm.
3. **`onFolderChanged`** — when backed by `QFileSystemModel` or custom indexing, resolve to absolute paths in C++; reject escapes outside allowed roots.
4. **Reveal / open** — prefer `WindowHelper.revealFileInFolder` on validated paths; do not pass user-typed paths straight to the shell.
5. **Sort/filter** — TreeDataGrid visibility is not sanitization; hidden rows can still be activated if your handler skips checks.

```qml
FileTree {
    onFileActivated: function (index, row) {
        var path = appModel.resolvePath(currentFolderLabel, row.name)  // app-owned
        if (!appPolicy.mayOpen(path))
            return
        openDocument(path)  // never shell-execute dropped/listed paths silently
    }
}
```

Recipe detail: [tree-data.md](tree-data.md) **Path trust (2.36)**. Gallery: **FileTree** · **TreeDataGrid** · **Security & trust**.

---

## Clipboard & secrets

- `CopyButton` / `WindowHelper.copyText` put plaintext on the system clipboard — visible to other apps until overwritten.
- Prefer short-lived copy of tokens with UI that makes the action obvious; avoid copying passwords by default.

---

## Threat model (honest)

| Threat | Kit stance |
|--------|------------|
| Malicious web content inside WebView2 | Edge process model applies; **you** choose the URL |
| User drops a `.exe` / script | Filter with `acceptExtensions` + `acceptMimeTypes`; still don’t execute |
| Explorer row shows `installer.exe` | UI label only — validate path + extension before open (**2.36**) |
| WebView download / save-as | Not intercepted by kit — allowlist navigation; confirm external fetch (**2.36**) |
| Confused deputy FilePicker | Always pass parent Window; validate returned paths |
| Supply-chain / Runtime missing | Probe + EmptyState; don’t ship a fake browser |

---

## Checklist

- [ ] WebView2 navigation uses Pattern A/B/C — not a raw production URL bar
- [ ] Org/app name set before WebView2 user-data creation
- [ ] FileDropZone `acceptExtensions` non-empty for production ingest
- [ ] Optional `acceptMimeTypes` when OS reports MIME (**2.13**)
- [ ] Drop + Browse share one ingest function; no auto-execute
- [ ] FilePicker always gets `Window.window`; cancel handled
- [ ] Wayland: portal parent_window regression after shell changes (**2.13**)
- [ ] FileTree / TreeDataGrid: validate paths before open/reveal/execute (**2.36**)
- [ ] WebView2: download policy D/E/F — no silent saves (**2.36**)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) for this minor

---

## Related Gallery

| Page | Role |
|------|------|
| **Security & trust** | Checklist + pointers (**1.64** · wave 2 **2.13** · wave 3 **2.36**) |
| **Pitfalls** | Anti-patterns including trust callouts |
| **WebView2** | Host recipe + download policy (**2.36**) |
| **FileDropZone** | Drop + Browse |
| **FileTree** / **TreeDataGrid** | Path trust callouts (**2.36**) |
| **System integration** | FilePicker / reveal |
