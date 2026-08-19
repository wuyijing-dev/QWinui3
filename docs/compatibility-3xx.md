# 3.xx compatibility freeze (3.00)

**Status:** **Draft placeholder** — lands with product version **3.00**. Mirrors [compatibility-1xx.md](compatibility-1xx.md) for the **3.xx** line.

**2.xx freeze:** Active through **2.73** — lifts at **3.00** with documented remaps in [upgrade-notes.md](upgrade-notes.md).

---

## Promise (3.xx)

| Class | Promise |
|-------|---------|
| **Stable** | Types on [stable-api.md](stable-api.md) after the **3.00** promote/cleanup pass — no silent renames in **3.xx** without a roadmap note. |
| **Experimental** | May change in **3.xx** with docs callouts; prefer explicit `QWinUI3.Experimental` import if shipped in **3.00**. |
| **Removed at 3.00** | **Permanent defer** sibling charts/gauges, withdrawn Hub, and undocumented aliases — see **Upgrade 2.73 → 3.00** in [upgrade-notes.md](upgrade-notes.md). |

---

## Will not break in 3.xx (draft — finalize at 3.00 tag)

Same categories as [compatibility-1xx.md](compatibility-1xx.md), post-**3.00** inventory:

- **Theme** tokens on stable-api (after alias cleanup)
- **Shells:** `StandardWindow`, `NavigationWindow`, `ShellWindow`, documented Extras shells
- **Stable six** charts: `LineChart`, `BarChart`, `DonutChart`, `RingGauge`, `KpiTile`, `ChartCard`
- **NavigationView** / **TabView** (non–tear-out APIs)
- **Platform** `WindowHelper` contract documented in **2.x**

Fill exact type list when checkpoint-300 audits **2.73**.

---

## Related

| Doc | Role |
|-----|------|
| checkpoint-300 | 3.00 gate audit |
| [roadmap.md](roadmap.md) | Full plan through **3.00** |
| [stable-api.md](stable-api.md) | Stable vs experimental map |
