# Checkpoint 310 — Application platform audit (3.01…3.10)

**Status:** green — **2026-08-27** (`QWINUI3_VERSION` **3.10**)  
**Scope:** Tranche 9 — shell 2.0 (**W2–W8**) · command (**R1–R3**) · workspace (**W5–W6**) · navigation pro (**N1–N3**) · dashboard live (**G1–G3**) · vertical kits (**V1–V3**) · platform extras (**P1–P3**)

**Roadmap:** [ROADMAP.md](../ROADMAP.md) · **3.10** is the sign-off slice, not a feature dump.

**Note:** Formal [checkpoint-300](checkpoint-300.md) (**3.00** breaking close-out) remains scheduled; tranche 9 landed on the current **3.xx** line ahead of that tag (same pattern as early **3.01+** ship).

---

## Slices (incremental landing)

| Tag | Theme | IDs | Verdict |
|-----|-------|-----|---------|
| **3.01** | Shell 2.0 | **W2–W4** | Shipped |
| **3.02** | Command system | **R1–R3** | Shipped |
| **3.03** | Workspace layout | **W5–W6** | Shipped |
| **3.04** | Navigation pro | **N1–N3** | Shipped |
| **3.05** | Dashboard live | **G1–G2** | Shipped |
| **3.06** | Charts wave B | **G3** | Shipped |
| **3.07** | Vertical app kits | **V1–V3** | Shipped |
| **3.08** | Multi-window & panels | **W7–W8** | Shipped |
| **3.09** | Platform desktop extras | **P1–P3** | Shipped |
| **3.10** | Soft **checkpoint-310** | Audit matrix below | Shipped |

---

## Exit criteria

- [x] **W2–W8**, **R1–R3**, **N1–N3**, **G1–G3**, **V1–V3**, **P1–P3** shipped (or deferred with friction-log row + target slice)
- [x] Gallery `--smoke` green on **3.xx** stable imports (no L1–L5 bundled)
- [x] Vertical examples **V1–V3** in monorepo CMake (`qwinui3_example_admin_settings` / `_master_detail_crm` / `_ops_console`)
- [x] [title-bar-cookbook.md](title-bar-cookbook.md) + [commands.md](commands.md) + [window-shells.md](window-shells.md) cover **3.01–3.04**; [app-platform-3xx.md](app-platform-3xx.md) + [file-association.md](file-association.md) cover **3.07–3.09**
- [x] **FL-014** / **FL-015** closed (3.05 / 3.06)
- [x] No **L1–L5** micro-interaction wave bundled into **3.01–3.10**

---

## Demo map

| Capability | Gallery / example | Verified |
|------------|-------------------|----------|
| TitleBarCommand + SessionRestore | Gallery Main · gallery-shell | Yes |
| CommandRegistry + conflict UI | Gallery Commands / Settings | Yes |
| SplitWorkspace + LayoutPreset | `examples/ops-console` | Yes |
| Pinned nav + Jump list | NavigationView demo | Yes |
| LiveMetricStrip | Ops console / `examples/dashboard` | Yes |
| Vertical kit — admin | `examples/admin-settings` | Yes |
| Vertical kit — CRM | `examples/master-detail-crm` | Yes |
| Vertical kit — ops | `examples/ops-console` | Yes |
| Panel float + bus sync | `examples/multi-window` | Yes |
| File association + RecentFiles | [file-association.md](file-association.md) · Gallery RecentFiles | Yes |

---

## Out of checkpoint

- **L1–L5** micro-interaction / pointer polish wave
- Full **dockable panel** framework (**3.11+**)
- **Undo/redo** framework · schema-driven forms · audit log UI
- Gallery “version done” checklists

---

## Next

**3.00** breaking close-out ([checkpoint-300](checkpoint-300.md)), then **3.11+** friction-only or [micro-interaction backlog](../ROADMAP.md#micro-interaction--visual-polish--deferred-last).
