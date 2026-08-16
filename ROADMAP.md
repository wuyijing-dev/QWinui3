# QWinUI3 Roadmap

This roadmap is the **product plan**, not a wish list. Releases are infrequent and each one must ship a **coherent, substantial** increment—not a handful of opportunistic controls or drive-by fixes dressed up as a version bump.

**Current release:** [v1.0.0](https://github.com/wuyijing-dev/QWinui3/releases/tag/v1.0.0)  
**Support floor:** Qt **6.5+** (recommended **6.8 LTS**; forward **6.10+**) — see [qt-version-compat.md](docs/qt-version-compat.md)

---

## Release principles

1. **Theme before tickets** — Every version has one primary theme (quality, platform, data, architecture). Features that do not serve that theme wait.
2. **Substance bar** — A numbered release must clear **all** of:
   - A user-visible capability area completed end-to-end (API + Gallery + docs), **or** a cross-cutting hardening effort with measurable exit criteria.
   - Docs site / component catalog updated for every public API change.
   - CI Release packages still build for the supported OS matrix.
   - No “tiny dump”: avoid shipping a release whose changelog is mostly typo fixes, one new control, or incomplete experiments.
3. **Stability bias after 1.0** — Prefer finishing, hardening, and documenting existing surfaces over adding parallel half-finished controls.
4. **Patch releases (`1.0.x`)** — Bug fixes, security, packaging, docs-only, and CI. Patches do **not** invent new product themes.
5. **Explicit deferral** — Items listed under “Out of scope” for a version are deferred on purpose; do not sneak them in mid-cycle just because they are easy.

Versioning intent:

| Kind | When |
|------|------|
| **Patch** `x.y.Z` | Fixes and packaging; no new major surfaces |
| **Minor** `x.Y.0` | One finished theme; may add controls/APIs that serve that theme |
| **Major** `X.0.0` | Breaking architecture or support-floor changes, with a migration story |

---

## v1.0.0 — Foundation (shipped)

**Theme:** Ship a usable Fluent / WinUI-inspired Qt Quick kit.

| Area | What landed |
|------|-------------|
| Modules | Theme, Style (`QWinUI3`), Platform, Extras |
| Catalog | 200+ public controls; Gallery demos for most |
| Shells | Title bar / NavigationView / window helpers; optional WebView2 |
| Docs | MkDocs site, generated component API, conventions |
| License | LGPL-3.0 |
| Build | Release-default CMake; shared packaging scripts; CI Release (Win + Linux) |
| Compat | C++ shim floor for Qt 6.5 / 6.8 / 6.10+ |

**Exit status:** Done. Treat 1.0 as the baseline for compatibility promises in 1.x.

---

## v1.1 — Production hardening

**Theme:** Make 1.0 **safe to bet a product on**—quality, accessibility, Linux parity, and API clarity—before growing the catalog again.

### In scope (must ship as a set)

1. **Accessibility pass (Style + high-traffic Extras)**  
   Systematic audit against [conventions.md](docs/conventions.md): roles, names, keyboard, reduced motion / high contrast. Fix gaps on Style controls and the Extras used by examples (`NavigationView`, settings cards, `ContentDialog`, `DataTable`, `InfoBar` / `Toast`). Gallery **Accessibility** page stays the living checklist.

2. **API & behavior freeze for 1.x “stable surface”**  
   Publish a short **stable API list** (what apps can rely on without surprise renames). Mark experimental types in docs. No silent signature changes on stable types in 1.1+.

3. **Linux desktop parity for shells**  
   Documented, tested path for X11/Wayland: title chrome, backdrop limitations, Gallery launcher, known gaps. Fix the highest-impact Linux bugs that block “nav + settings” style apps.

4. **Automated smoke**  
   At least: Release configure + Gallery link on CI for Windows and Linux; a minimal QML/offscreen or process smoke that the Gallery binary starts (or module loads) without crash. Expand only as far as needed for regression confidence—not a full UI automation suite.

5. **Packaging & onboarding polish**  
   Shared-lib and Gallery packages verified; README / Creator docs aligned with 6.5+ floor; `package_release_*` paths documented as the supported redistributable story.

### Out of scope for 1.1

- Large new control families (new chart types, new shell paradigms).
- Breaking Theme token renames.
- macOS as a first-class target.
- Rewriting WebView2 or replacing it with WebEngine.

### Exit criteria

- Stable-surface doc published; a11y audit issues for in-scope controls either fixed or explicitly tracked with severity.
- Linux shell path documented with “works / limited / unsupported” matrix.
- CI green for Release packages + smoke; no known Gallery startup regressions on Win/Linux Release.

---

## v1.2 — Platform & app chrome depth

**Theme:** Make **real Windows (and capable Linux) apps** feel finished—windowing, embedding, and chrome—not more demo widgets.

### In scope (must ship as a set)

1. **Window / shell maturity**  
   Coherent behavior for backdrop / frost / snap layouts / multi-monitor DPI where Platform already claims support; document failure modes. Reduce “works in Gallery but not in a copied example” gaps for `StandardWindow` / `NavigationWindow` / dialog shells.

2. **WebView2 productization (Windows)**  
   Lifecycle, clipping/scroll sync, focus, and error UI treated as product features; Gallery + docs cover integration patterns; clear unsupported cases (non-Windows, missing Runtime). No WebEngine packaging.

3. **Input & system integration**  
   Tray, file pickers, notifications bridge: consistent APIs, Gallery coverage, and failure handling on Win/Linux where applicable.

4. **Internationalization baseline**  
   Layout-ready patterns for RTL where feasible; docs for `qsTr` / string extraction in Extras/Style samples; Gallery language switch or documented hook if practical.

5. **Example apps as templates**  
   Nav / settings / dashboard examples updated to match Platform best practices from this release (copy-paste ready, same flags as Gallery).

### Out of scope for 1.2

- New chart/gauge families.
- Full Fluent 2 redesign of every Style control.
- Mobile / embedded form factors.

### Exit criteria

- Platform chapter in docs describes supported chrome/backends with test notes.
- WebView2 (Win) has a documented integration recipe and Gallery page that matches current behavior.
- Examples build and demonstrate the same shell patterns as docs—not stale screenshots of intent.

---

## v1.3 — Data, forms, and brandable apps

**Theme:** Support **line-of-business** UIs: dense data, forms, and brand theming—still without a random control explosion.

### In scope (must ship as a set)

1. **DataTable & collections depth**  
   Sort / filter / resize / keyboard / virtualization behavior hardened; documented models and performance guidance; Gallery recipes for master–detail with `ListDetailsView` / `ItemsView`.

2. **Forms system**  
   `FormLayout` + headered fields + validation/`errorMessage` end-to-end; settings card patterns aligned; Accessibility for form flows verified.

3. **Theme branding kit**  
   Documented accent / density / token override path for product apps; optional sample “brand theme” in Gallery or examples—without forking the Style module.

4. **Charts used in apps**  
   Stabilize the existing chart/gauge set (API consistency, reduced motion, a11y names)—**not** a large new chart taxonomy. Drop or mark experimental any half-maintained chart types.

5. **Designer / Creator ergonomics**  
   Kit/presets, QML import docs, and common pitfalls updated so Creator users hit fewer dead ends (ties to [qt-creator.md](docs/qt-creator.md)).

### Out of scope for 1.3

- Replacing Qt Charts / Graphs with a second engine.
- Plugin marketplace or visual theme editor product.
- Breaking Style URI changes.

### Exit criteria

- Data + forms docs with recipes; branding guide with a working sample.
- Chart/gauge public set is consistent (or explicitly experimental); Gallery demos match docs.
- No net growth of “undocumented public types.”

---

## v2.0 — Architecture & long-term contract

**Theme:** A **major** release that earns the version number: clearer module boundaries, stronger multi-Qt story, and intentional breaking changes with a migration guide.

### In scope (must ship as a set)

1. **Module / packaging contract**  
   Clear redistributable layout (what goes in shared packages, plugin vs QML tree, versioned ABI expectations). Align on-demand packaging (`--modules` / presets) with documented consumer CMake.

2. **Compat & Qt matrix as first-class**  
   CI (or documented matrix) covering declared Qt floors (6.5 / 6.8 / current 6.10+); `qwinui3_qtcompat` expanded only for real breakages; drop accidental reliance on kit-private details.

3. **Breaking cleanups (batched)**  
   Rename/remove experimental APIs marked in 1.x; fix long-standing FINAL/Page/Catalog constraints with a supported pattern; Theme token renames **only** with a migration table.

4. **Quality bar raise**  
   Broader automated tests for Theme/Platform entry points; Gallery catalog generation + lint in CI as a gate.

5. **Platform policy**  
   Explicit statement of Windows-first vs Linux support level for 2.x; macOS only if someone owns it end-to-end (otherwise remains best-effort / undocumented).

### Out of scope for 2.0

- Rewriting the kit in Widgets or C++-only controls.
- Bundling Qt WebEngine.
- Guaranteeing binary compatibility with 1.x shared libs (source migration guide instead).

### Exit criteria

- Migration guide 1.x → 2.0 published before tagging.
- CI matrix matches the support statement in README.
- Shared packages and module presets match the architecture docs—no “secret” layout known only to release scripts.

---

## Parking lot (not scheduled)

These may enter a future theme only when they justify a full release slice:

- macOS first-class shells and packaging  
- Full visual redesign to a newer Fluent language across all Style controls  
- Design-to-code / Figma token pipeline  
- Extensive UI automation (screenshot diffs for every Gallery page)  
- Additional languages beyond a small set for Gallery itself  

---

## How we change this document

- Update **after** a release ships (move theme to “shipped” with a short outcome note).
- Changing the **next** version’s theme requires replacing its in/out/exit sections—not appending random bullets.
- Patch work does not need a roadmap rewrite; link notable patches from the GitHub Release notes instead.

---

## Related docs

| Doc | Role |
|-----|------|
| [README.md](README.md) | Product overview & quick start |
| [docs/qt-version-compat.md](docs/qt-version-compat.md) | Qt 6.5 / 6.8 / 6.10+ C++ shims |
| [docs/conventions.md](docs/conventions.md) | QML / a11y authoring rules |
| [docs/components.md](docs/components.md) | Public control index |
