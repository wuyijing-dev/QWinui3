# QWinUI3 Roadmap

**Current:** **1.01**  
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

### 1.02 — Accessibility (high-traffic path)

**Why:** Conventions already exist; apply them where product apps start.

- Style controls + examples path: `NavigationView`, settings cards, `ContentDialog`, `InfoBar` / `Toast`.
- Keyboard / `Accessible` / reduced-motion gaps fixed or severity-tracked.
- Gallery Accessibility page stays the checklist.

**Not in 1.02:** Full audit of every chart/gauge; new Extras.

---

### 1.03 — Linux shells (practical)

**Why:** Gallery/CI already build Linux; chrome gaps still trip people.

- Document X11 / Wayland: works / limited / unsupported for title bar & backdrop.
- Fix the worst blockers for nav + settings style apps on Linux.
- Keep `run-gallery` / packaging notes accurate.

**Not in 1.03:** macOS; full Mica/frost parity with Windows.

---

### 1.04 — Window chrome polish (Windows-first)

**Why:** Platform already claims backdrop / snap / DPI—make the claimed path reliable.

- Tighten `StandardWindow` / `NavigationWindow` / dialog shells for common DPI & backdrop cases.
- Document failure modes; align **examples** with Gallery patterns.

**Not in 1.04:** New shell paradigms; WebView2 deep dive (see 1.05).

---

### 1.05 — WebView2 (Windows) productize

**Why:** Host exists; treat it as a real integration, not a demo HWND.

- Lifecycle, scroll/clip sync, focus, missing-Runtime UX.
- One clear integration recipe in docs + Gallery page matching behavior.

**Not in 1.05:** Qt WebEngine; non-Windows embedding.

---

### 1.06 — CI smoke (lightweight)

**Why:** Release packages exist; need a cheap regression gate.

- Windows + Linux: configure Release, build Gallery (or shared preset), minimal “binary starts / modules load” smoke.
- Keep scope small—no full screenshot suite.

**Not in 1.06:** Multi-Qt version matrix in CI (later, still under 1.xx if needed).

---

### 1.07 — DataTable / master–detail (deepen, don’t expand)

**Why:** Controls exist; LoB apps need predictable behavior.

- Harden sort / filter / keyboard / docs for `DataTable` + `ListDetailsView` / `ItemsView` recipes.
- Performance notes; Gallery recipes only—no new table product.

**Not in 1.07:** New chart engines; virtualization rewrite unless required to fix bugs.

---

### 1.08 — Forms & settings consistency

**Why:** `FormLayout` / headered fields / settings cards already there.

- End-to-end validation / `errorMessage` patterns; align settings expanders/cards.
- Short forms recipe doc.

**Not in 1.08:** Brand theme editor; token rename breakages.

---

### 1.09 — Branding & Theme overrides (docs + sample)

**Why:** Theme tokens exist; apps need a supported override path.

- Document accent / density / token overrides.
- One small “branded” sample (Gallery page or example)—no Style fork.

**Not in 1.09:** Fluent 2 full restyle of all Style controls.

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
