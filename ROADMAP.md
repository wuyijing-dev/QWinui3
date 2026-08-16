# QWinUI3 Roadmap

**Current:** **1.09**  
**Qt:** 6.5+ (recommended 6.8 LTS) — [qt-version-compat.md](docs/qt-version-compat.md)

This plan starts from **what 1.00 already was**, then walks **small `1.xx` minors**. Stay on **1.xx for a long time**. **2.00 is not next**—only when we truly need breaking changes.

---

## Version format: `X.YY`

| Field | Meaning |
|-------|---------|
| **X** | Major line (`1` = current kit; `2` = future breaking line) |
| **YY** | Two-digit minor (`00`, `01`, … `99`) — one focused slice each |

Examples: `1.00` → `1.01` → `1.02` → … → `1.10` → `1.11`.

- **Tags / packages:** `v1.01`, archives `qwinui3-1.01-…`
- **CMake:** `QWINUI3_VERSION` in root `CMakeLists.txt` (maps to `major.minor.0` for CMake’s numeric VERSION)
- **No third digit** for product releases. Hotfixes either rebuild the same `X.YY` or bump `YY`.

---

## What you already have (1.00 baseline)

Do not plan as if the kit is empty. Rough inventory today:

| Surface | Rough size |
|---------|------------|
| Public controls | ~208 |
| Gallery demo pages | ~150+ |
| Style QML (Fluent chrome for Controls) | ~55 |
| Extras QML | ~150 |
| Modules | Theme · Style · Platform · Extras |
| Docs | MkDocs + generated component API |
| Ship | LGPL-3.0 · CI Release (Win + Linux) · shared/gallery packaging · Qt compat shims |

**Implication:** Near-term work is mostly **finish, fix, document, and deepen** existing surfaces—not invent a second catalog or jump to a major rewrite.

---

## How we version

| Kind | Meaning |
|------|---------|
| **Same `X.YY` rebuild** | Urgent packaging/docs/CI fixes when needed |
| **Next `X.YY`** | **One focused slice**—small enough to finish, clear enough to name |
| **`2.00`** | **Far future.** Breaking API/ABI or support-floor cuts only |

**Rules of thumb**

- One `X.YY` ≈ one primary outcome, not five themes at once.
- Avoid empty releases—but do not wait for “epic” bundles either.
- New controls only when they serve that minor’s slice; otherwise park them.
- After each ship: bump `QWINUI3_VERSION`, update this file.

---

## Near path — small `1.xx` minors

### 1.01 — Docs & “what’s stable” (shipped)

**Shipped:** [stable-api.md](docs/stable-api.md) (stable vs experimental map), docs/Creator/packaging pointers, component docs lint clean, product version `1.01`.

---

### 1.02 — Accessibility (high-traffic path) (shipped)

**Shipped:** Settings toggle rows as one CheckBox focus target; NavigationView item/footer/Back names; InfoBar/Toast severity + Close keyboard; [accessibility.md](docs/accessibility.md) + Gallery Accessibility checklist; product version `1.02`. Remaining gaps severity-tracked in that doc.

---

### 1.03 — Linux shells (practical) (shipped)

**Shipped:** [platform-linux-wayland.md](docs/platform-linux-wayland.md) works/limited/unsupported matrix for title bar & backdrop; `WindowHelper.resolveBackdrop` coerces Mica/Acrylic → Solid on Linux; shells paint `effectiveBackdrop`; Gallery `run-gallery.sh` no longer forces `xcb`; nav-settings / packaging notes; product version `1.03`.

---

### 1.04 — Window chrome polish (Windows-first) (shipped)

**Shipped:** `StandardWindow` runtime backdrop/paradigm + show `reapply`; DPI hit-test refresh; DWM backdrop reapply on `WM_DPICHANGED`; `DialogWindow` / `DialogShellWindow.openDialog(owner)`; [window-chrome.md](docs/window-chrome.md) failure modes; nav-settings aligned with Gallery chrome; product version `1.04`.

---

### 1.05 — WebView2 (Windows) productize (shipped)

**Shipped:** Runtime probe + missing-Runtime EmptyState; user-data folder lifecycle; focus hand-off; scroll/clip/DPI sync retained; [webview2.md](docs/webview2.md) + Gallery page recipe; product version `1.05`.

---

### 1.06 — CI smoke (lightweight) (shipped)

**Shipped:** [`.github/workflows/smoke.yml`](.github/workflows/smoke.yml) on Windows + Linux (Release Gallery build); `qwinui3_gallery --smoke` + [`scripts/smoke_gallery.py`](scripts/smoke_gallery.py); Windows QPA coerce for inherited `offscreen` (Cursor/CI) + Qt PATH pin; [ci-smoke.md](docs/ci-smoke.md); product version `1.06`.

---

### 1.07 — DataTable / master–detail (deepen, don’t expand) (shipped)

**Shipped:** DataTable stable selection across sort/filter + filter→table keyboard; ListDetailsView arrows/Enter + SinglePane Back/Esc (`showList`); ItemsView PageUp/Down + `reuseItems` + filter-above Gallery recipe; [data-collections.md](docs/data-collections.md); product version `1.07`.

---

### 1.08 — Forms & settings consistency (shipped)

**Shipped:** FormLayout `clearErrors`/`collectErrors` tree parity; HeaderedComboBox + RadioButtons `errorMessage` chrome; TokenizingTextBox `formBound`; SettingsExpander `header` / ColumnLayout host / `cornerRadius`; Gallery Form validation + combo error demos; [forms.md](docs/forms.md); product version `1.08`.

---

### 1.09 — Branding & Theme overrides (docs + sample) (shipped)

**Shipped:** [theme-overrides.md](docs/theme-overrides.md) (writable knobs vs readonly tokens); Gallery **Theme overrides** page (presets + customAccent + density; restores Theme on leave); Settings **Custom accent**; product version `1.09`.

---

### Later `1.xx` (only when the above are mostly done)

Parked as **optional further minors**, still not `2.00`:

- Tray / file picker / notification bridge consistency  
- i18n / RTL baseline for samples  
- Chart/gauge API consistency pass (stabilize set; mark experimental)  
- Qt 6.5 / 6.8 / 6.10 **compat verification** as an extra CI job  
- On-demand packaging docs aligned with consumer CMake  

Schedule as `1.10`, `1.11`, … — one slice per minor.

---

## Far future — 2.00 (not scheduled)

**Do not start 2.00 work while 1.xx still absorbs polish.**

Consider 2.00 only if several of these become true:

- Need breaking Theme/API renames that cannot stay compatible in 1.xx  
- Need a new packaging/ABI contract that breaks 1.xx consumers  
- Need to drop an old Qt floor or OS policy in a breaking way  

Until then: **stay on 1.xx**, bump `YY` for each slice.

---

## Parking lot

Unscheduled; pick up only inside a named `1.xx` minor:

- macOS first-class  
- Figma / design-token pipeline  
- Full Fluent visual redesign  
- Screenshot diffs for every Gallery page  
- Extra Gallery languages  

---

## Related

| Doc | Role |
|-----|------|
| [README.md](README.md) | Overview |
| [docs/components.md](docs/components.md) | Control index |
| [docs/conventions.md](docs/conventions.md) | A11y / QML rules |
| [docs/qt-version-compat.md](docs/qt-version-compat.md) | Qt multi-version shims |
