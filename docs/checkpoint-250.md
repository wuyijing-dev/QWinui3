# Tranche-1 checkpoint (2.50)

**Status:** **Shipped** — audit **2.00…2.50** (tranche 1 close-out). **Does not** close the full 2.x line — **2.51…2.60** friction tranche and [checkpoint-260.md](checkpoint-260.md) follow.

Scope: **no breaking code** in this tag (docs-only audit). Drop **conditional** control ideas without [friction-log.md](planning/friction-log.md) proof; queue **2.51+** from open pains only.

Earlier: [checkpoint-230.md](checkpoint-230.md) · [perf-signoff-2xx.md](perf-signoff-2xx.md) (**2.49**) · [experimental-sweep.md](experimental-sweep.md) (**2.45**) · [ROADMAP.md](../ROADMAP.md).

Validation: `python scripts/check_checkpoint_250.py`

---

## Verdict

| Question | Answer (2.50) |
|----------|----------------|
| **Tranche 1 done?** | **Yes** — **2.00…2.50** slices audited; close-out **2.44…2.49** shipped |
| **New controls justified?** | **Yes** — conditional types cite friction rows (**FileTree** **2.06**, **TreeDataGrid** **2.21**, **ItemsWrapGrid** **2.24**, **NotificationCenter** **2.27**, **CalendarView** **2.31**, **SwipeControl** **2.42**); **Hub withdrawn** |
| **Close-out arc?** | **Yes** — diagnostics **2.44**, experimental sweep **2.45**, docs IA **2.46**, field buffer **2.47**, friction slot **2.48**, perf sign-off **2.49** |
| **Weak slices dropped?** | **None retroactive** — post-**2.50** conditional controls **require friction row** |
| **2.00 breaking baseline?** | **Still planned — Next** — [compatibility-1xx.md](compatibility-1xx.md) freeze posture unchanged |
| **Next tag posture?** | **2.51+** **friction-only** — skip tag if no open **P0/P1** |

---

## Audit snapshot (2.50)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP links | **OK** (`python scripts/check_docs_links.py`) |
| Gallery catalog | **204** entries · **11** categories (`python scripts/smoke_catalog.py`) |
| Critical smoke pages | **22** (synced: `main.cpp` · `ControlCatalog` · `smoke_catalog.py`) |
| Translation catalogs | **4100+** msgs × 5 locales + wiring (`python scripts/check_gallery_translations.py`) |
| Component docs (`docs/components.json`) | **226** public types |
| Close-out validators **2.44…2.49** | **OK** (`check_developer_diagnostics` … `check_performance_wave8`) |
| Product version | **2.50** |
| Starter path | **`examples/gallery-shell`** (+ **`examples/dashboard`**, **`examples/multi-window`**) |
| Tranche-1 perf | **Signed off** — [perf-signoff-2xx.md](perf-signoff-2xx.md) (**2.49**) |

---

## Slice posture (2.44…2.50 close-out)

| Slice | Theme | Status (2.50) |
|-------|--------|---------------|
| **2.44** | Developer diagnostics productize | **Shipped** — `applyRetailProfile()` + [developer-diagnostics.md](developer-diagnostics.md) |
| **2.45** | Experimental → stable sweep | **Shipped** — FL-004 badges + [experimental-sweep.md](experimental-sweep.md) |
| **2.46** | Docs IA v2 | **Shipped** — MkDocs **2.xx** regroup + recipes hub |
| **2.47** | Field harden buffer | **Shipped** — FL-003/004 docs + smoke bump |
| **2.48** | Friction-only slot | **Shipped** — FL-009 [dashboard-compose-decision.md](dashboard-compose-decision.md) |
| **2.49** | Performance wave 8 | **Shipped** — tranche-1 perf sign-off |
| **2.50** | This checkpoint | **Shipped** |

---

## Friction queue (checkpoint triage for 2.51…2.60)

| ID | Pain | 2.50 disposition |
|----|------|------------------|
| **FL-003** | Consumer CMake / import | **Partial** — **2.47** path picker; **2.02** productize Path C; **2.68** residual |
| **FL-004** | Experimental vs stable | **Partial** — **2.45** sweep + **2.47** import guard → **2.51** clarity queue |
| **FL-008** | Collection sluggish at scale | **Partial** — waves **5–8** + **2.49** sign-off; **2.64** if field metrics return |
| **FL-009** | Dashboard / chart compose | **Partial** — **2.48** decision tree; **2.65** icon semantics pack |
| **FL-002** | Linux shell vs DWM | **Partial** — **2.03** + **2.68** if gaps remain |
| **FL-005** | Rich text | **Open** — **2.61** conditional; needs named app |
| **FL-006** | SemanticZoom / contacts | **Open** — **2.62** conditional |
| **FL-011** | Python / PySide6 | **Open** — **2.71…2.73** tranche |

**Reschedule notes:** **2.51…2.59** ship **only** with friction-log **P0/P1** proof. **2.60** = [checkpoint-260.md](checkpoint-260.md). **2.02** / **2.01** remain on roadmap but **not** bundled into friction tags. **3.00** prep continues at **2.60** / **2.73**, not here.

---

## Posture for `2.51+`

1. **Friction gate** — no open **P0/P1** → **skip the tag**.
2. **Ship on stable** — Theme, shells, [stable-api.md](stable-api.md) types remain the contract.
3. **No catalog shopping** — conditional controls (**2.61…2.63**) need named apps in friction-log.
4. **Perf + a11y** — tranche-1 signed off at **2.49**; reopen **FL-008** only with field metrics.
5. **Next horizon audit** — [checkpoint-260.md](checkpoint-260.md) at **2.60**.

---

## Consumer checklist

- [ ] Pin / rebuild **2.50** Release (no API breaks vs **2.49**)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) **2.49 → 2.50**
- [ ] Review [experimental-sweep.md](experimental-sweep.md) + Gallery badges before copying demos
- [ ] Plan upgrades: **2.00** breaking baseline still **Next** — not shipped in tranche 1
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Re-run audits

```bat
python scripts/check_checkpoint_250.py
python scripts/check_docs_links.py
python scripts/smoke_catalog.py
python scripts/check_catalog_refresh.py
python scripts/check_gallery_translations.py
python scripts/smoke_gallery.py --build-dir build
```
