# Checkpoint 400 — 3.x line close-out (4.00)

**Status:** **planned** — opens after [checkpoint-390](checkpoint-390.md) green  
**Scope:** Breaking **4.00** major — Qt floor, alias cleanup, experimental inventory, stable **4.xx** freeze

**Roadmap:** [ROADMAP.md](../ROADMAP.md#400--3x-line-close-out-breaking-major)

**Prerequisite:** [checkpoint-390](checkpoint-390.md) · efficiency budgets green · **3.91…3.99** prep complete

---

## 4.00 deliverables (not yet tagged)

| Area | Deliverable | Status |
|------|-------------|--------|
| **Qt** | Floor **6.12 LTS**; drop pre-6.12 shims required after **3.00**’s 6.10 floor | Planned |
| **Modules** | Remove aliases deferred through **3.xx**; optional modules stay opt-in | Planned |
| **Experimental** | Permanent-defer types removed from default imports or namespaced (`QWinUI3.Experimental`) | Planned |
| **Stable contract** | [compatibility-4xx.md](compatibility-4xx.md) — **4.xx** “will not break” freeze | Planned |
| **CMake / PyPI** | Semver **4.00**; document `core` / `shell` / `full` presets | Planned |
| **Docs** | [upgrade-notes.md](upgrade-notes.md) **Upgrade 3.90 → 4.00** | Planned |

---

## Exit criteria (tag `v4.00`)

- [ ] checkpoint-390 green
- [ ] Qt CI matrix on **6.12+** only (document last 6.10 consumer path if any)
- [ ] Alias / experimental inventory closed with upgrade-notes rows
- [ ] compatibility-4xx.md published
- [ ] Efficiency budgets from 3.90 still the default consumer guidance
- [ ] Switch latency / default UX rules **unchanged** by the major (no “speed up” via shorter transitions)

**Out:** macOS first-class · Fluent 2 fork · WebGL charts · micro-interaction dump in the same tag

**Then:** **4.01+** friction-only, or deferred [micro-interaction backlog](../ROADMAP.md#micro-interaction--visual-polish--deferred-last)
