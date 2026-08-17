# Stable vs experimental clarity (2.51)

**FL-004** friction slice — closes the **2.47 import guard** gap with example lint + aligned docs. No new controls.

Related: [stable-api.md](stable-api.md) · [experimental-sweep.md](experimental-sweep.md) · [field-harden-247.md](field-harden-247.md) · [planning/friction-log.md](planning/friction-log.md)

---

## Goal

Teams ship **experimental** or **permanent-defer** Gallery demos in product code because badges and import paths are easy to miss.

**2.51 outcome:** one place to read the rule, Gallery Pitfalls checklist, and a **lint** over `examples/` so stable starters stay clean.

---

## Deliverables

| Item | Location |
|------|----------|
| Import guard (extended) | [stable-api.md](stable-api.md) — **Import guard** + changelog **2.51** |
| Verdict matrix | [experimental-sweep.md](experimental-sweep.md) (unchanged matrix; **2.51** closes FL-004 queue) |
| Example lint | `python scripts/lint_qml_imports.py` — scans `examples/**/*.qml` |
| Gallery checklist | **Pitfalls** — **2.51 / FL-004** block |
| Badges | `ControlCatalog.apiStabilityForComponent` + `ApiStabilityBadge` (shipped **2.45**) |

**Out:** Removing experimental types from the kit (**3.00** cleanup). CI gate on every Gallery page string (use `--smoke` instead).

---

## Lint rules (`lint_qml_imports.py`)

| Rule | Detail |
|------|--------|
| **Permanent defer** | No `AreaChart`, `MediaPlayerElement`, deferred gauges, etc. in any `examples/` QML |
| **Experimental** | No `OnScreenKeyboard*`, `TreeDataGrid`, `CalendarView`, … except **`examples/floating-osk/`** |
| **Stable examples** | May use `QWinUI3.Extras` for **stable** types (`NavigationWindow`, `KpiTile`, …) |

Run locally or in CI beside packaging:

```bash
python scripts/lint_qml_imports.py
python scripts/smoke_gallery.py --build-dir build
```

---

## App checklist

- [ ] Read badge on Gallery page before copy-paste into product tree
- [ ] Product imports match [stable-api.md](stable-api.md) **Stable** table
- [ ] Dashboard uses **stable six** only — [charts.md](charts.md)
- [ ] Run `lint_qml_imports.py` after editing an example starter
- [ ] OSK only via **`examples/floating-osk`** until **2.01** promote

**Next:** **2.52** first app in an hour · **2.67** experimental promote wave 2
