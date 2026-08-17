# Mid-2.x horizon checkpoint (2.30)

Second tranche audit at product version **2.30** — verdict on **2.21…2.30** (new controls + recipes + perf/a11y waves); parking-lot triage for **2.31…2.50**. **3.00 prep** continues at **2.50**, not here. Prior audit: [checkpoint-220.md](checkpoint-220.md) (**2.20 shipped**).

Scope: **no breaking code** in this tag.

Earlier: [checkpoint-220.md](checkpoint-220.md) · [checkpoint-210.md](checkpoint-210.md) · [friction-log.md](planning/friction-log.md) · [stable-api.md](stable-api.md) · [ROADMAP.md](../ROADMAP.md).

---

## Verdict

| Question | Answer (2.30) |
|----------|----------------|
| **Checkpoint done?** | **Yes** — **2.21…2.30** field slices shipped; docs-only audit tag |
| **New controls tranche?** | **Yes** — **`TreeDataGrid`** (2.21), **`ItemsWrapGrid`** (2.24), **`NotificationCenter`** experimental (2.27); **Hub withdrawn** |
| **Perf + a11y sign-off?** | **Yes** — wave 6 (**2.28**) shell trim + wave 5 (**2.29**) tree/wrap/breadcrumb a11y |
| **Weak slices dropped?** | **None** — all ten slices land; **2.31+** stays conditional per friction |
| **2.00 breaking baseline?** | **Still planned — Next** — [1.xx freeze](compatibility-1xx.md) **active** |
| **Next tag posture?** | **2.31** conditional **`CalendarView`** unless friction gate fails |

---

## Audit snapshot (2.30)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP links | **OK** (`python scripts/check_docs_links.py`) |
| Gallery catalog | **203** entries · **11** categories (`python scripts/smoke_catalog.py`) |
| Critical smoke pages | **20** (synced: `main.cpp` · `ControlCatalog` · `smoke_catalog.py`) |
| Translation catalogs | **3647** msgs × 4 locales + wiring (`python scripts/check_gallery_translations.py`) |
| Component docs (`docs/components.json`) | **225** public types |
| Slice validators **2.21…2.29** | **OK** (`check_tree_data_grid` … `check_accessibility_wave5`) |
| Product version | **2.30** |
| Starter path | **`examples/gallery-shell`** (+ **`examples/dashboard`**, **`examples/multi-window`**) |
| Freeze accurate | **Yes** — **2.00** still the lift |

---

## Slice posture (2.21…2.30)

| Slice | Theme | Status (2.30) |
|-------|--------|---------------|
| **2.21** | **`TreeDataGrid`** (conditional) | **Shipped** — experimental hierarchical grid |
| **2.22** | Dashboard layout recipes | **Shipped** — responsive breakpoints + Gallery readout |
| **2.23** | **BreadcrumbBar** + NavigationView sync | **Shipped** — path helpers + live demo |
| **2.24** | **`ItemsWrapGrid`** (conditional) | **Shipped** — variable-size wrap + filter |
| **2.25** | Forms / Settings industry templates | **Shipped** — registration / CRUD / preferences pages |
| **2.26** | Charts recipe wave | **Shipped** — deferred sibling compose table |
| **2.27** | **`NotificationCenter`** + feedback (conditional) | **Shipped** — experimental drawer (**FL-007**) |
| **2.28** | Performance wave 6 | **Shipped** — shell + navigation trim checklist |
| **2.29** | Accessibility wave 5 | **Shipped** — tree / wrap / breadcrumb keyboard names |
| **2.30** | This checkpoint | **Shipped** |

---

## Friction queue (checkpoint triage for 2.31…2.50)

| ID | Pain | 2.30 disposition |
|----|------|------------------|
| **FL-007** | Notification center | **Closed** — **2.27** experimental `NotificationCenter` |
| **FL-008** | Collection sluggish at scale | **Partial** — **2.18** wave 5 + **2.28** wave 6; **2.64** if field metrics return |
| **FL-009** | Dashboard / chart compose | **Partial** — **2.08** + **2.22** + **2.26** recipes shipped |
| **FL-010** | Forms industry templates | **Closed** — **2.25** Gallery LoB template pages |
| **FL-003** | Consumer CMake / import | **Open** — **2.02** still scheduled; **2.11** partial |
| **FL-004** | Experimental vs stable | **Open** → **2.45** sweep at tranche-1 close |
| **FL-005** | Rich text | **Open** — **2.61** conditional; needs named app |
| **FL-006** | SemanticZoom / contacts | **Open** — **2.62** conditional |
| **FL-011** | Python / PySide6 | **Open** — **2.71…2.73** tranche |

**Reschedule notes:** **2.31 CalendarView** stays **conditional** — no friction row yet; defer if no month-grid app cites pickers-only failure. **2.35 Localization wave 4** unchanged — **ja_JP** / **ko_KR** seed-only until Linguist pass. **2.39 Gallery catalog expansion** — most **2.21…2.30** pages already in catalog; sweep at **2.39** or **2.50**. No **2.31…2.50** slices **dropped** at this checkpoint.

---

## Posture for `2.31+`

1. **Do not bundle 2.00 breaks** into control or recipe slices.
2. **Ship on stable** — Theme, shells, [stable-api.md](stable-api.md) types remain the contract.
3. **Conditional controls** — **CalendarView (2.31)**, **PipsPager deepen (2.37)**, **2.61…2.63** need friction proof or checkpoint green-light.
4. **Perf + a11y** — tranche-1 arc extended at **2.28** / **2.29**; next collection perf at **2.64** if **FL-008** reopens.
5. **Next horizon audit** — [checkpoint-250.md](checkpoint-250.md) at **2.50**.

---

## Consumer checklist

- [ ] Pin / rebuild **2.30** Release (no API breaks vs **2.29**)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) **2.29 → 2.30**
- [ ] New experimental types: **`TreeDataGrid`**, **`ItemsWrapGrid`**, **`NotificationCenter`** — see [stable-api.md](stable-api.md)
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Re-run audits

```bat
python scripts/check_checkpoint_230.py
python scripts/check_docs_links.py
python scripts/smoke_catalog.py
python scripts/check_catalog_refresh.py
python scripts/check_gallery_translations.py
python scripts/smoke_gallery.py --build-dir build
```
