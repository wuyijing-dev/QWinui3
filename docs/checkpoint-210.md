# 2.x mid-horizon checkpoint (2.10)

First audit of the **2.x tranche-1 opening** — **2.03…2.09** shipped on the **1.xx Qt floor** (6.5+); **2.00 / 2.01 / 2.02** remain **planned** (work jumped to field slices first). **No breaking code** in this tag.

Earlier: [checkpoint-190.md](checkpoint-190.md) (1.xx close-out) · [compatibility-1xx.md](compatibility-1xx.md) · [friction-log.md](planning/friction-log.md) · [stable-api.md](stable-api.md) · [ROADMAP.md](../ROADMAP.md).

---

## Verdict

| Question | Answer (2.10) |
|----------|----------------|
| **Checkpoint done?** | **Yes** — docs-only audit; product version **2.10** |
| **2.00 breaking baseline?** | **Not shipped** — still **Next**; [1.xx freeze](compatibility-1xx.md) **active** |
| **OSK / IME promote (2.01)?** | **Rescheduled** — still **experimental**; soak not green |
| **Packaging productize (2.02)?** | **Rescheduled** — **FL-003** open; Path C sketch only |
| **First conditional control (2.06 FileTree)?** | **Shipped** — **FL-012** justified; stays **experimental** |
| **Weak slices dropped?** | **None** — 2.03…2.09 all land with docs; no catalog-only churn |
| **Next tag posture?** | **2.12+** per roadmap (vcpkg/Conan **2.11** shipped) |

---

## Audit snapshot (2.10)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP `docs/*.md` links | **OK** (`python scripts/check_docs_links.py`) |
| Gallery catalog entries | **196** (`python scripts/smoke_catalog.py`) |
| Critical smoke pages | **18** (synced: `main.cpp` · `ControlCatalog` · `smoke_catalog.py`) |
| Component docs (`docs/components.json`) | **226** public types |
| Product version | **2.10** |
| Starter path | **`examples/gallery-shell`** (+ **`examples/multi-window`**, **`examples/floating-osk`** experimental) |
| Freeze accurate | **Yes** — [compatibility-1xx.md](compatibility-1xx.md) + [stable-api.md](stable-api.md); **2.00** still the lift |

---

## Slice posture (2.00…2.10)

| Slice | Theme | Status (2.10) |
|-------|--------|---------------|
| **2.00** | Breaking baseline (Qt **6.8** floor, freeze lift) | **Planned — Next** |
| **2.01** | OSK / IME promote | **Planned** — experimental retained |
| **2.02** | `find_package` productize (**FL-003**) | **Planned** |
| **2.03** | Linux Wayland shell wave 2 | **Shipped** |
| **2.04** | Runtime diagnostics (`showRhi`, CLI) | **Shipped** |
| **2.05** | Title-bar cookbook | **Shipped** |
| **2.06** | **(conditional)** FileTree (**FL-012**) | **Shipped** (experimental) |
| **2.07** | Accessibility wave 4 | **Shipped** |
| **2.08** | Charts compose + permanent defer table | **Shipped** — stable six unchanged |
| **2.09** | Media final promote or defer | **Shipped** — **permanent defer** |
| **2.10** | This checkpoint | **Shipped** |

**Note:** Tranche-1 table order is not ship order. Field slices **2.03…2.09** landed before **2.00** without lifting the 1.xx freeze — intentional; breaking work stays gated on **2.00**.

---

## Friction queue (checkpoint triage)

| ID | Pain | 2.10 disposition |
|----|------|------------------|
| **FL-001** | Title-bar FPS badge | Partially addressed in **2.04** diagnostics; badge opt-in unchanged |
| **FL-002** | Linux shell vs DWM | **2.03** wave 2 — field matrix updated; not closed |
| **FL-003** | Consumer CMake / import | **Open** → **2.02** |
| **FL-004** | Experimental vs stable confusion | Partial — **2.09** media defer doc; stable-api aligned |
| **FL-009** | Dashboard / chart compose | Partial — **2.08** recipes + defer table |
| **FL-012** | Explorer tree + metadata | **Closed** for conditional gate — **2.06** FileTree shipped experimental |

No new friction rows opened in **2.10**. **2.11+** continues tranche-1 table unless checkpoint **2.20** reschedules.

---

## Posture for `2.11+`

1. **Do not mix 2.00 breaks** into packaging or vcpkg slices — one named **2.00** tag first when ready.
2. **Ship on stable** — Theme, shells, and [stable-api.md](stable-api.md) types remain the contract through **2.10**.
3. **OSK promote** — explicit green soak in **2.01**, not bundled into vcpkg or Wayland work.
4. **Conditional controls** — need [friction-log.md](planning/friction-log.md) proof or checkpoint green-light (**2.06** is the template).
5. **Next horizon audit** — [checkpoint-220.md](checkpoint-220.md) at **2.20** reviews **2.00…2.20** and tranche-1 parking lot.

---

## Consumer checklist

- [ ] Pin / rebuild **2.10** Release (no API breaks vs **2.09**)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) **2.09 → 2.10** and draft **1.90 → 2.00** (still future)
- [ ] Prefer [stable-api.md](stable-api.md) + `examples/gallery-shell`
- [ ] Treat `OnScreenKeyboard` / `FileTree` / charts extras as **experimental** until promote slices
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Re-run audits

```bat
python scripts/check_docs_links.py
python scripts/smoke_catalog.py
python scripts/smoke_gallery.py --build-dir build
```
