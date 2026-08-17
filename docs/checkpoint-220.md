# First 2.x horizon checkpoint (2.20)

First tranche audit at product version **2.20** — verdict on **2.00…2.20**; parking-lot triage for **2.21…2.50**; perf + a11y sign-off for tranche 1. **3.00 prep** continues at **2.50**, not here. Prior mid audit: [checkpoint-210.md](checkpoint-210.md) (**2.10 shipped**).

Scope: **no breaking code** in this tag.

Earlier: [checkpoint-210.md](checkpoint-210.md) · [checkpoint-190.md](checkpoint-190.md) · [friction-log.md](planning/friction-log.md) · [stable-api.md](stable-api.md) · [ROADMAP.md](../ROADMAP.md).

---

## Verdict

| Question | Answer (2.20) |
|----------|----------------|
| **Tranche 1 done?** | **Yes for field slices 2.03…2.20** — docs-only checkpoint + Gallery full locale switch |
| **2.00 breaking baseline?** | **Still planned — Next** — [1.xx freeze](compatibility-1xx.md) **active** |
| **2.01 OSK / 2.02 packaging?** | **Rescheduled** — experimental OSK; **FL-003** partial via **2.11** vcpkg/Conan |
| **Perf wave 5 (2.18)?** | **Shipped** — collection debounce + cache hits; animations stay |
| **A11y wave 4 (2.07)?** | **Shipped** — DataTable / ListDetailsView / NavigationView live regions |
| **Localization (2.12 + 2.20)?** | **Shipped** — seed catalogs + **live Gallery switch** (~3647 strings, `GalleryLanguage`) |
| **Weak slices dropped?** | **None** — **2.11…2.19** all land; **2.20** closes horizon with i18n + audit |
| **Next tag posture?** | **2.21** conditional **TreeDataGrid** unless friction gate fails |

---

## Audit snapshot (2.20)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP links | **OK** (`python scripts/check_docs_links.py`) |
| Gallery catalog | **197** entries · **11** categories (`python scripts/smoke_catalog.py`) |
| Critical smoke pages | **20** (synced: `main.cpp` · `ControlCatalog` · `smoke_catalog.py`) |
| Translation catalogs | **3647** msgs × 4 locales + wiring (`python scripts/check_gallery_translations.py`) |
| Component docs (`docs/components.json`) | **222** public types |
| Product version | **2.20** |
| Starter path | **`examples/gallery-shell`** (+ **`examples/multi-window`**, **`examples/floating-osk`** experimental) |
| Freeze accurate | **Yes** — **2.00** still the lift |

---

## Slice posture (2.00…2.20)

| Slice | Theme | Status (2.20) |
|-------|--------|---------------|
| **2.00** | Breaking baseline (Qt **6.8** floor) | **Planned — Next** |
| **2.01** | OSK / IME promote | **Planned** |
| **2.02** | `find_package` productize (**FL-003**) | **Planned** |
| **2.03…2.09** | Wayland · diagnostics · FileTree · a11y · charts · media | **Shipped** (see [checkpoint-210.md](checkpoint-210.md)) |
| **2.10** | Mid-horizon checkpoint | **Shipped** |
| **2.11** | vcpkg / Conan overlay | **Shipped** — **FL-003** partial |
| **2.12** | Localization wave 3 (seed `.ts`) | **Shipped** |
| **2.13** | Security wave 2 | **Shipped** |
| **2.14** | Multi-window harden | **Shipped** |
| **2.15** | High-DPI wave 3 | **Shipped** |
| **2.16** | Command & search | **Shipped** |
| **2.17** | Style polish | **Shipped** |
| **2.18** | Performance wave 5 | **Shipped** |
| **2.19** | Docs & catalog refresh | **Shipped** |
| **2.20** | This checkpoint + Gallery full locale switch | **Shipped** |

---

## Friction queue (checkpoint triage for 2.21…2.50)

| ID | Pain | 2.20 disposition |
|----|------|------------------|
| **FL-001** | Title-bar FPS / diagnostics | Partial — **2.04** RHI readout; opt-in unchanged |
| **FL-002** | Linux shell vs DWM | **Open** — **2.03** not closed |
| **FL-003** | Consumer CMake / import | Partial — **2.11** overlay; **2.02** still needed |
| **FL-004** | Experimental vs stable | Partial — Pitfalls + stable-api; **2.45** sweep queued |
| **FL-007** | Notification center | **Open** → **2.27** conditional |
| **FL-008** | Collection sluggish at scale | Partial — **2.18** wave 5; **2.28** wave 6 queued |
| **FL-009** | Dashboard / chart compose | Partial — **2.08** + **2.22** layout recipes shipped |
| **FL-010** | Forms industry templates | **Open** → **2.25** |
| **FL-012** | Explorer tree + metadata | **Closed** — **2.06 FileTree** experimental |

**Reschedule notes:** **2.21 TreeDataGrid** stays conditional on master-detail friction. **2.35 Localization wave 4** deferred — **2.20** delivers Gallery live switch + `zh_CN` fill; **ja_JP** / **ko_KR** remain seed-only until Linguist work or wave 4.

---

## Posture for `2.21+`

1. **Do not bundle 2.00 breaks** into control or recipe slices.
2. **Ship on stable** — Theme, shells, [stable-api.md](stable-api.md) types remain the contract.
3. **Conditional controls** — **TreeDataGrid (2.21)**, **ItemsWrapGrid (2.24)**, **CalendarView (2.31)** need friction proof or checkpoint green-light.
4. **Perf + a11y** — tranche 1 signed off at **2.07** + **2.18**; next waves at **2.28** / **2.29**.
5. **Next horizon audit** — [checkpoint-230.md](checkpoint-230.md) at **2.30** (**shipped**); [checkpoint-250.md](checkpoint-250.md) at **2.50**.

---

## Consumer checklist

- [ ] Pin / rebuild **2.20** Release (no API breaks vs **2.19**)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) **2.19 → 2.20**
- [ ] Gallery: Settings → **Display language** or `--lang zh_CN` for live locale switch
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Re-run audits

```bat
python scripts/check_docs_links.py
python scripts/smoke_catalog.py
python scripts/check_gallery_translations.py
python scripts/check_catalog_refresh.py
python scripts/smoke_gallery.py --build-dir build
```
