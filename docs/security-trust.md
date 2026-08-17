# Security & trust boundaries (1.64)

What QWinUI3 **hosts** versus what **your app must own**. This is a trust-boundary cookbook — **not** a claim that the kit is a hardened sandbox product.

| Surface | Kit provides | App must own |
|---------|--------------|--------------|
| [`WebView2Host`](webview2.md) | HWND Edge host + user-data folder under app local data | Which URLs load; Runtime install; no multi-profile / custom Environment yet |
| [`FileDropZone`](drag-drop.md) | Suffix filter (`acceptExtensions`) | Empty filter = accept all; never execute dropped paths; normalize URLs |
| [`FilePicker`](system-integration.md) | Native open/save/folder + parent window ownership | Validate paths; pass `Window.window`; treat cancel as empty |
| Clipboard / reveal | `WindowHelper` / `CopyButton` / `revealFileInFolder` | Don’t put secrets in clipboard without user intent |

Gallery: **Security & trust** · **Pitfalls** · **WebView2** · **FileDropZone** · **System integration**.

Related: [webview2.md](webview2.md) · [drag-drop.md](drag-drop.md) · [system-integration.md](system-integration.md) · [print-share.md](print-share.md) · [stable-api.md](stable-api.md).

**Out of scope (1.64):** rewriting WebView2Host into an allowlist API; claiming OS-level sandboxing; encrypted vault / DRM products.

---

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

`QStandardPaths::AppLocalDataLocation` + `/WebView2Host`

(typically `%LOCALAPPDATA%/<org>/<app>/WebView2Host` on Windows).

| Implication | Guidance |
|-------------|----------|
| Cookies / cache / local storage | Bound to **your** org/app id from `QCoreApplication` — set those before `configureApplication` |
| Multi-user kiosk | Different app names / data roots, or wipe the folder on logout (app policy) |
| Custom Environment / multi-profile | **Experimental / deferred** — [stable-api.md](stable-api.md) |

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

### HWND / clip

Unclipped hosts leak pixels over Fluent chrome — always nest in `clip: true` (Gallery does). This is UI integrity, not a security boundary, but mixed focus/HWND stacks confuse users into trusting the wrong chrome.

---

## FileDropZone — drop validation

| Setting | Trust effect |
|---------|----------------|
| `acceptExtensions: [".png", ".jpg"]` | Non-matching drops ignored (no `filesDropped`) |
| `acceptExtensions: []` (default) | **Accepts all** `text/uri-list` URLs — treat as open |

**App checklist:**

1. Prefer a **non-empty** `acceptExtensions` list that matches your FilePicker filters.
2. Always offer **Browse** (`FilePicker`) for keyboard / a11y — [drag-drop.md](drag-drop.md).
3. Normalize `file:` URLs → local paths before `QFile` / processors; do not assume stripping `file://` is enough on Windows.
4. **Never** `QProcess::start` / shell-execute a dropped path without an explicit, confirmed user gesture and policy.
5. Size / MIME / content scanning stays in **your** ingest pipeline — the zone only filters by suffix.

---

## FilePicker — ownership & paths

| Host | Ownership |
|------|-----------|
| Windows | Pass `Window.window` so `IFileDialog` is HWND-owned (modal / Z-order). |
| Linux X11 | Portal gets `parent_window` when possible. |
| Linux Wayland | Parent may be empty unless Qt exports xdg-foreign — still pass the Window; [platform-linux-wayland.md](platform-linux-wayland.md) (**1.68**). |

**App checklist:**

1. Cancel → `""` / `[]` — never treat as a path.
2. Validate extensions / directories after save/open (picker filters are UX, not a security fence).
3. After export, prefer `revealFileInFolder` over auto-opening with the shell default handler for untrusted types — [print-share.md](print-share.md).
4. Do not re-prompt into a path the user did not pick (path injection via spoofed callbacks is an app bug if you invent paths).

---

## Clipboard & secrets

- `CopyButton` / `WindowHelper.copyText` put plaintext on the system clipboard — visible to other apps until overwritten.
- Prefer short-lived copy of tokens with UI that makes the action obvious; avoid copying passwords by default.

---

## Threat model (honest)

| Threat | Kit stance |
|--------|------------|
| Malicious web content inside WebView2 | Edge process model applies; **you** choose the URL |
| User drops a `.exe` / script | Filter with `acceptExtensions`; still don’t execute |
| Confused deputy FilePicker | Always pass parent Window; validate returned paths |
| Supply-chain / Runtime missing | Probe + EmptyState; don’t ship a fake browser |

---

## Checklist

- [ ] WebView2 `source` / address bar gated by an allowlist (or fixed URL)
- [ ] Org/app name set before WebView2 user-data creation
- [ ] FileDropZone `acceptExtensions` non-empty for production ingest
- [ ] Drop + Browse share one ingest function; no auto-execute
- [ ] FilePicker always gets `Window.window`; cancel handled
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) for this minor

---

## Related Gallery

| Page | Role |
|------|------|
| **Security & trust** | Checklist + pointers (**1.64**) |
| **Pitfalls** | Anti-patterns including trust callouts |
| **WebView2** | Host recipe |
| **FileDropZone** | Drop + Browse |
| **System integration** | FilePicker / reveal |
