# QWinUI3 Roadmap

**Current:** [v1.0.0](https://github.com/wuyijing-dev/QWinui3/releases/tag/v1.0.0)  
**Qt:** 6.5+ (recommended 6.8 LTS) — [qt-version-compat.md](docs/qt-version-compat.md)

This plan starts from **what 1.0 already is**, then walks **small 1.x minors**. Stay on **1.x for a long time**. **2.0 is not next**—only when we truly need breaking changes.

---

## What you already have (v1.0 baseline)

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

## How we version (adjusted)

| Kind | Meaning |
|------|---------|
| **Patch** `1.0.x` | Bugs, packaging, docs, CI. Anytime. |
| **Minor** `1.y.0` | **One focused slice**—small enough to finish, clear enough to name. Prefer several modest minors over one “epic.” |
| **Major** `2.0.0` | **Far future.** Only for intentional breaking API/ABI or support-floor cuts, with a migration guide. Not on the near path. |

**Rules of thumb**

- One minor ≈ one primary outcome (e.g. “a11y on Style + nav/settings path”), not five themes at once.
- Still avoid empty releases (one random control + changelog spam)—but **do not** wait until you can ship “enterprise platform + forms + CI matrix” in a single tag.
- New controls only when they serve that minor’s slice; otherwise park them.
- After each ship: update this file (mark done, keep the next 2–3 minors concrete).

---

## Near path — small 1.x minors

### v1.1 — Docs & “what’s stable”

**Why first:** Catalog is huge; consumers need a clear map before more features.

- Publish a short **stable vs experimental** list for the types apps actually copy (shells, NavigationView, settings cards, ContentDialog, InfoBar/Toast, DataTable basics).
- Tighten README / Creator / packaging docs so 6.5+ floor and Release CI match reality.
- Gallery/docs lint: generate + `--lint` clean for public API comments.

**Not in 1.1:** Linux overhaul, WebView2 rewrite, new control families.

---

### v1.2 — Accessibility (high-traffic path)

**Why:** Conventions already exist; apply them where product apps start.

- Style controls + examples path: `NavigationView`, settings cards, `ContentDialog`, `InfoBar` / `Toast`.
- Keyboard / `Accessible` / reduced-motion gaps fixed or severity-tracked.
- Gallery Accessibility page stays the checklist.

**Not in 1.2:** Full audit of every chart/gauge; new Extras.

---

### v1.3 — Linux shells (practical)

**Why:** Gallery/CI already build Linux; chrome gaps still trip people.

- Document X11 / Wayland: works / limited / unsupported for title bar & backdrop.
- Fix the worst blockers for nav + settings style apps on Linux.
- Keep `run-gallery` / packaging notes accurate.

**Not in 1.3:** macOS; full Mica/frost parity with Windows.

---

### v1.4 — Window chrome polish (Windows-first)

**Why:** Platform already claims backdrop / snap / DPI—make the claimed path reliable.

- Tighten `StandardWindow` / `NavigationWindow` / dialog shells for common DPI & backdrop cases.
- Document failure modes; align **examples** with Gallery patterns.

**Not in 1.4:** New shell paradigms; WebView2 deep dive (see 1.5).

---

### v1.5 — WebView2 (Windows) productize

**Why:** Host exists; treat it as a real integration, not a demo HWND.

- Lifecycle, scroll/clip sync, focus, missing-Runtime UX.
- One clear integration recipe in docs + Gallery page matching behavior.

**Not in 1.5:** Qt WebEngine; non-Windows embedding.

---

### v1.6 — CI smoke (lightweight)

**Why:** Release packages exist; need a cheap regression gate.

- Windows + Linux: configure Release, build Gallery (or shared preset), minimal “binary starts / modules load” smoke.
- Keep scope small—no full screenshot suite.

**Not in 1.6:** Multi-Qt version matrix in CI (later, still under 1.x if needed).

---

### v1.7 — DataTable / master–detail (deepen, don’t expand)

**Why:** Controls exist; LoB apps need predictable behavior.

- Harden sort / filter / keyboard / docs for `DataTable` + `ListDetailsView` / `ItemsView` recipes.
- Performance notes; Gallery recipes only—no new table product.

**Not in 1.7:** New chart engines; virtualization rewrite unless required to fix bugs.

---

### v1.8 — Forms & settings consistency

**Why:** `FormLayout` / headered fields / settings cards already there.

- End-to-end validation / `errorMessage` patterns; align settings expanders/cards.
- Short forms recipe doc.

**Not in 1.8:** Brand theme editor; token rename breakages.

---

### v1.9 — Branding & Theme overrides (docs + sample)

**Why:** Theme tokens exist; apps need a supported override path.

- Document accent / density / token overrides.
- One small “branded” sample (Gallery page or example)—no Style fork.

**Not in 1.9:** Fluent 2 full restyle of all Style controls.

---

### Later 1.x (only when the above are mostly done)

Parked as **optional further minors**, still not 2.0:

- Tray / file picker / notification bridge consistency  
- i18n / RTL baseline for samples  
- Chart/gauge API consistency pass (stabilize set; mark experimental)  
- Qt 6.5 / 6.8 / 6.10 **compat verification** as an extra CI job  
- On-demand packaging docs aligned with consumer CMake  

Add these as `1.10+` only when scheduled—one slice per minor.

---

## Far future — v2.0 (not scheduled)

**Do not start 2.0 work while 1.x still absorbs polish.**

Consider 2.0 only if several of these become true:

- Need breaking Theme/API renames that cannot stay compatible in 1.x  
- Need a new packaging/ABI contract that breaks 1.x consumers  
- Need to drop an old Qt floor or OS policy in a breaking way  

Until then: **stay on 1.x**, use patches freely, keep minors small.

---

## Parking lot

Unscheduled; pick up only inside a named 1.x minor:

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
