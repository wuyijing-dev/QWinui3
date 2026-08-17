# Mid-horizon checkpoint (1.60)

Halfway audit of the **1.49…1.70** arc. **Still 1.xx — not 2.00.**

Related: [maturity-1xx.md](maturity-1xx.md) (1.51) · [compatibility-1xx.md](compatibility-1xx.md) · [stable-api.md](stable-api.md) · [upgrade-notes.md](upgrade-notes.md) · [ROADMAP.md](../ROADMAP.md) · Gallery **Pitfalls**.

---

## Verdict

| Question | Answer (1.60) |
|----------|----------------|
| Stay on **1.xx** through **1.70**? | **Yes** — no 2.00 draft |
| Posture for **1.61…1.70**? | **Unchanged** — harden / docs / recipes first; promote only in named minors |
| Reorder **1.61+**? | **No** — next remains CMake `find_package` sketch (**1.61**), then visual smoke subset (**1.62**) |
| Experimental defer list? | **Unchanged** — Media, ConnectedAnimation, niche charts, Snap Layouts, TabView tear-out, WebView2 multi-profile ([stable-api 1.37 defer](stable-api.md#137-defer--wont-promote-for-now)); thin `AnimatedIcon` stays experimental (**1.53**) |

---

## Audit snapshot (1.60)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP `docs/*.md` links | **0 broken** (`python scripts/check_docs_links.py`) |
| Gallery catalog entries | **~190** |
| Component docs (`docs/components/*.md`) | **~220** |
| Product version | **1.60** |
| Starter path | Still **`examples/gallery-shell`** (+ **`examples/multi-window`** for secondary shells) |
| Freeze (1.40) | **Active** — no silent Theme / shell / stable renames in `1.52`…`1.59` |

### Absorbed since 1.51 (theme summary)

| Slice | Theme |
|-------|--------|
| **1.52** | CI/docs harden (docs links in smoke) |
| **1.53** | Thin `AnimatedIcon` (experimental) |
| **1.54** | Extra locale `ja_JP` |
| **1.55** | TeachingTip onboarding coach |
| **1.56** | Multi-window secondary shells |
| **1.57** | Touch / pen cookbook |
| **1.58** | High-DPI matrix + restore `setScreen` |
| **1.59** | In-app search / AutoSuggest recipes |

All additive under the freeze. Field P0s still trump new families.

---

## Parking lot (trimmed notes)

Unscheduled items remain in [ROADMAP parking lot](../ROADMAP.md#parking-lot). **Not** removed — only clarified:

| Keep parked | Why |
|-------------|-----|
| macOS first-class / Figma / Fluent 2 fork | Deliberate products, not free polish |
| Full Lottie dependency | Thin glyph path already in **1.53**; full runtime stays optional |
| Official vcpkg/Conan ports | **1.61** may ship a *sketch* only — ports stay unsupported products |
| Every-page screenshot CI | **1.62** aims at a **subset** only |
| Community translation portal | Seeds (`zh_CN` / `ja_JP`) are enough for 1.xx |
| Custom ink / cloud roaming backends | Explicitly out of **1.57** / **1.65** scope |

---

## Smoke coverage bump (1.60)

Critical Gallery page instantiate list also loads:

- `SearchRecipesPage` (**1.59** cookbook)
- `HighDpiPage` (**1.58** matrix readout)

Keep in sync: `src/gallery/main.cpp` · `ControlCatalog.smokeCriticalComponents()` · `scripts/smoke_catalog.py` · [ci-smoke.md](ci-smoke.md).

---

## Confirmed plan **1.61…1.70**

Order confirmed (flex only for field P0s):

1. **1.61** — CMake package / `find_package` sketch  
2. **1.62** — Gallery visual smoke (subset)  
3. **1.63** — Print / share / export recipes  
4. **1.64** — Security & trust boundaries  
5. **1.65** — Settings persistence & roaming recipes  
6. **1.66** — Charts & dashboard polish (wave 3)  
7. **1.67** — Media soak or honest defer  
8. **1.68** — Linux portal & file-dialog harden  
9. **1.69** — (as roadmap)  
10. **1.70** — Long-horizon 1.xx checkpoint  

---

## Consumer checklist

- [ ] Pin / rebuild **1.60** Release  
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) `1.59` → `1.60`  
- [ ] Prefer [stable-api.md](stable-api.md) + `examples/gallery-shell`  
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Re-run audits

```bat
python scripts/check_docs_links.py
python scripts/checkpoint_1_60_audit.py
```
