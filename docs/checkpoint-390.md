# Checkpoint 390 — Efficiency & control depth (3.90)

**Status:** **planned** — opens after tranche 10 waves (**3.34…3.82**) land  
**Scope:** Sign-off for kit **cold start**, **memory**, **silent runtime**, **control depth**, and **package slim** — **no** default UX / switch-latency regressions

**Roadmap:** [ROADMAP.md](../ROADMAP.md#efficiency--control-depth-tranche-10-334--400)

**Prerequisite for:** [checkpoint-400](checkpoint-400.md) (**4.00**)

---

## Hard rules (must stay green)

| Rule | Pass |
|------|------|
| Default UX unchanged | No appearance/motion duration change without upgrade-notes row |
| Switch latency | NavigationView / page / Gallery switch **p50 ≤ 3.33 baseline** (same Release machine) |
| Additive APIs | New APIs default off or behavior-compatible |
| Measure | Startup ms · working-set/RSS · switch budget recorded |

---

## Wave checklist

| Wave | Slices | IDs | Status |
|------|--------|-----|--------|
| Cold start | **3.34…3.40** | **S10–S17** | **3.34–3.38** shipped · rest Planned |
| Memory | **3.41…3.48** | **H10–H17** | Planned |
| Silent runtime | **3.49…3.55** | **C20–C26** | Planned |
| Control depth | **3.56…3.72** | **D30–D54** | Planned |
| Platform + package | **3.73…3.82** | **P10–P12 · K10–K16** | Planned |
| Friction buffer | **3.83…3.89** | friction-log only | Planned |

---

## Exit criteria (tag `v3.90`)

- [ ] Startup budget met on CI Win Release (`--startup-log`)
- [ ] Working-set / RSS table filled; Gallery idle RSS ↓ vs **3.33** baseline
- [ ] Switch p50 **≤** baseline
- [ ] **D30–D54** shipped or deferred with friction-log link
- [ ] **K10–K14** presets + size table published
- [ ] [performance.md](performance.md) updated with budgets
- [ ] No **4.00** breaking changes bundled into **3.90**

**Out:** **L1–L5** micro-interaction wave · changing default page-transition timings · new public control types without friction proof

---

## Baseline capture (fill at wave start)

| Metric | Machine | **3.33** baseline | **3.90** result |
|--------|---------|-------------------|-----------------|
| Interactive shell ms | CI Win Release | _TBD_ | |
| Gallery idle RSS (MB) | CI Win Release | _TBD_ | |
| Nav page switch p50 (ms) | CI Win Release | _TBD_ | |
| Kit zip `shell` (MB) | Release package | _TBD_ | |
| PyPI default wheel (MB) | Release | _TBD_ | |
