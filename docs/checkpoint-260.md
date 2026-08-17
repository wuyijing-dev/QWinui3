# Friction-line checkpoint (2.60)

**Status:** **Shipped** — audit **2.51…2.60** (friction-only tranche close-out). **Does not** ship **3.00** breaks — [upgrade-notes.md](upgrade-notes.md) **Upgrade 2.60 → 3.00 (draft)** only.

Scope: **no breaking code** in this tag (docs-only audit). Every **2.51…2.59** slice maps to a closed or validated friction row; **2.60** closes the tranche and queues **2.61…2.70**.

Earlier: [checkpoint-250.md](checkpoint-250.md) · [friction-log.md](planning/friction-log.md) · [ROADMAP.md](../ROADMAP.md).

**Platforms:** **Windows + Linux** — macOS / Fluent 2 Style fork / Hub controls **not** reschedule targets.

---

## Verdict

| Question | Answer (2.60) |
|----------|----------------|
| **Friction tranche done?** | **Yes** — **2.51…2.59** shipped; no skipped friction tags in queue |
| **Open P0/P1 blocking tranche?** | **No** — targeted rows closed (**FL-017**, **FL-018**) or partial with honest defer (**FL-003**, **FL-004**, **FL-008**) |
| **3.00 posture?** | **Draft** — [upgrade-notes.md](upgrade-notes.md) **Upgrade 2.60 → 3.00 (draft)** · **Final** at [checkpoint-273.md](checkpoint-273.md) + [checkpoint-300.md](checkpoint-300.md) |
| **2.00 breaking baseline?** | **Still planned — Next** — not bundled into friction tranche |
| **Next tag posture?** | **2.61…2.70** professional surfaces — conditional rows need named apps in friction-log |

---

## Audit snapshot (2.60)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP links | **OK** (`python scripts/check_docs_links.py`) |
| Gallery catalog | **204** entries · **11** categories (`python scripts/smoke_catalog.py`) |
| Critical smoke pages | **22** (synced: `main.cpp` · `ControlCatalog` · `smoke_catalog.py`) |
| Translation catalogs | **4100+** msgs × 5 locales + wiring (`python scripts/check_gallery_translations.py`) |
| Component docs (`docs/components.json`) | **227** public types |
| Example QML lint | **OK** (`python scripts/lint_qml_imports.py`) |
| Product version | **2.60** |
| Starter path | **`examples/first-app`** (+ **`examples/osk-dock`**, **`examples/gallery-shell`**) |

---

## Slice posture (2.51…2.59)

| Slice | Theme | Friction / outcome | Status (2.60) |
|-------|--------|-------------------|-----------------|
| **2.51** | Stable vs experimental clarity | **FL-004** queue | **Shipped** — [stable-clarity-251.md](stable-clarity-251.md) |
| **2.52** | First app in an hour | **FL-003** partial | **Shipped** — [first-app-252.md](first-app-252.md) |
| **2.53** | Linux top-3 parity | **FL-002** partial | **Shipped** — [linux-top3-253.md](linux-top3-253.md) |
| **2.54** | Window chrome footguns | Geometry / hit-test | **Shipped** — [window-chrome-footguns-254.md](window-chrome-footguns-254.md) |
| **2.55** | Forms unlike WinUI | **FL-018** | **Shipped** — [forms-unlike-winui-255.md](forms-unlike-winui-255.md) |
| **2.56** | Navigation mental model | Back / pane / stack | **Shipped** — [navigation-mental-model-256.md](navigation-mental-model-256.md) |
| **2.57** | Files on Linux | Portal pick / drop / reveal | **Shipped** — [files-linux-257.md](files-linux-257.md) |
| **2.58** | OSK / IME in apps | **FL-017** | **Shipped** — [osk-in-apps-258.md](osk-in-apps-258.md) |
| **2.59** | App-level sluggishness | Named slow flows | **Shipped** — [app-sluggishness-259.md](app-sluggishness-259.md) |
| **2.60** | This checkpoint | Tranche close-out + 3.00 prep draft | **Shipped** |

---

## Friction queue (checkpoint triage for 2.61…2.70)

| ID | Pain | 2.60 disposition |
|----|------|------------------|
| **FL-003** | Consumer CMake / import | **Partial** — **2.52** first-app; **2.02** productize Path C; **2.68** residual |
| **FL-004** | Experimental vs stable | **Partial** — **2.51** clarity queue closed; **2.67** wave 2 |
| **FL-008** | Collection sluggish at scale | **Partial** — waves **5–9**; **2.64** if field metrics return |
| **FL-009** | Dashboard / chart compose | **Partial** — **2.65** product wave scheduled |
| **FL-005** | Rich text | **Open conditional** — **2.61** needs named app |
| **FL-006** | SemanticZoom | **Open conditional** — **2.62** needs named app |
| **FL-011** | Python / PySide6 | **Open** — **2.71…2.73** after **2.02** |
| **FL-014** / **FL-015** | Analytics / bins | **Open conditional** — **2.65** / **2.69** |
| **FL-016** | DataTable pin/group | **Open** — **2.64** collection wave 9 |

**Reschedule notes:** **2.61…2.63** ship only with friction-log proof. **2.02** / **2.01** remain on roadmap, not friction tags. **3.00** breaks finalize at **2.73** + [checkpoint-300.md](checkpoint-300.md).

---

## Posture for `2.61+`

1. **Professional tranche** — [ROADMAP.md](../ROADMAP.md) **2.61…2.70**; conditional controls need named apps.
2. **Friction gate** — still applies to friction-only minors if re-opened; **skip tag** if no **P0/P1**.
3. **Ship on stable** — Theme, shells, [stable-api.md](stable-api.md) remain the contract through **2.73**.
4. **Perf** — app-level wave **9** (**2.59**) + collection waves **5–8**; reopen **FL-008** only with field metrics.
5. **Next horizon audit** — [checkpoint-270.md](checkpoint-270.md) at **2.70**.

---

## Consumer checklist

- [ ] Pin / rebuild **2.60** Release (no API breaks vs **2.59**)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) **2.59 → 2.60**
- [ ] Read slice recipes **2.51…2.59** if upgrading from **2.50**
- [ ] Plan **3.00** using **Upgrade 2.60 → 3.00 (draft)** — breaks **not** in **2.60**
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Re-run audits

```bat
python scripts/check_docs_links.py
python scripts/smoke_catalog.py
python scripts/check_catalog_refresh.py
python scripts/check_gallery_translations.py
python scripts/lint_qml_imports.py
python scripts/smoke_gallery.py --build-dir build
```
