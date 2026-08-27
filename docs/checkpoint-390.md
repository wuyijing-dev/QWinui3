# Checkpoint 390 — Efficiency & control depth (3.90)

**Status:** **planned** — opens after tranche 10 waves (**3.34…3.82**) land  
**Scope:** Sign-off for kit **cold start**, **memory**, **silent runtime**, **control depth**, and **package slim** — **no** default UX / switch-latency regressions

**Roadmap:** [ROADMAP.md](../ROADMAP.md#efficiency--control-depth-tranche-10-334--400)

**Prerequisite for:** [checkpoint-400](checkpoint-400.md) (**4.00**)

**Cold start wave:** **green** — signed off **2026-08-27** at **`QWINUI3_VERSION` 3.40** (**S10–S17**).  
**Memory wave:** **green** — signed off **2026-08-27** at **`QWINUI3_VERSION` 3.48** (**H10–H17**).  
**Silent runtime wave:** **green** — signed off **2026-08-27** at **`QWINUI3_VERSION` 3.55** (**C20–C26**). Depth / package rows remain open until their waves land.

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
| Cold start | **3.34…3.40** | **S10–S17** | **Shipped** — see [Cold start sign-off](#cold-start-sign-off-s10s17--340) |
| Memory | **3.41…3.48** | **H10–H17** | **Shipped** — see [Memory sign-off](#memory-sign-off-h10h17--348) |
| Silent runtime | **3.49…3.55** | **C20–C26** | **Shipped** — see [Silent runtime sign-off](#silent-runtime-sign-off-c20c26--355) |
| Control depth | **3.56…3.72** | **D30–D54** | **3.56** D30–D32 shipped · rest Planned |
| Platform + package | **3.73…3.82** | **P10–P12 · K10–K16** | Planned |
| Friction buffer | **3.83…3.89** | friction-log only | Planned |

---

## Exit criteria (tag `v3.90`)

- [x] Startup budget met on CI Win Release (`--startup-log` / smoke `main=`) — **3.39 S16** gate + **3.40** sign-off below
- [ ] Working-set / RSS table filled; Gallery idle RSS ↓ vs **3.33** baseline — **table filled at 3.48** (post-wave); **↓ vs 3.33** still unverified (**3.33** never captured)
- [x] Switch p50 recorded — **3.55** warm Gallery `openPage` **p50 ≈ 146 ms** (mode `none`); **3.33** pre-wave never captured — see [Silent runtime sign-off](#silent-runtime-sign-off-c20c26--355)
- [ ] **D30–D54** shipped or deferred with friction-log link
- [ ] **K10–K14** presets + size table published
- [x] [performance.md](performance.md) updated with budgets — **3.39** absolute CI table
- [ ] No **4.00** breaking changes bundled into **3.90**

**Out:** **L1–L5** micro-interaction wave · changing default page-transition timings · new public control types without friction proof

---

## Cold start sign-off (**S10–S17** · **3.40**)

| ID | Slice | Deliverable | Verdict |
|----|-------|-------------|---------|
| **S10** | **3.34** | Bootstrap minimal path — no optional host probes before first frame | Shipped |
| **S11** | **3.34** | Defer Style / Theme work not needed for first paint | Shipped |
| **S12** | **3.35** | Defer Charts / OSK / WebView2 QML registration until first import | Shipped |
| **S13** | **3.36** | Gallery / examples default **shell** import set | Shipped |
| **S14** | **3.37** | Gallery ControlCatalog lazy (Home hot index) | Shipped |
| **S15** | **3.38** | WebView2 probe / Keyman / FrameStats on demand | Shipped |
| **S16** | **3.39** | Absolute `main=` / `app=` CI budgets in `smoke_gallery.py` | Shipped |
| **S17** | **3.40** | This section — wave sign-off | **Signed off** |

### Interactive shell measurements

`python scripts/smoke_gallery.py --check-startup-budget` (Release `qwinui3_gallery`, Qt 6.8). Field **`main=`** = wall ms through `Main.qml` (interactive shell).

| Machine | Date | `app` avg | `main` avg (n) | Budget | Pass |
|---------|------|-----------|----------------|--------|------|
| Win Release (dev, this audit) | 2026-08-27 | **~13 ms** | **~335 ms** (n=5, min 330 / max 352) | Win `main` ≤ **1500** · `app` ≤ **800** | **Yes** |
| CI Win Release | (GHA `smoke.yml`) | — | enforced every push | same absolute table | **Gate on** |
| CI Linux offscreen | (GHA `smoke.yml`) | — | enforced every push | `main` ≤ **2000** · `app` ≤ **1000** | **Gate on** |

**Pre-wave contract:** **3.33** / **S5** used an advisory **`main` &lt; 1500 ms** without an absolute CI fail. **3.39** promoted that number to a hard gate ([performance.md](performance.md#ci-absolute-budgets-339-s16)). Local **3.40** `main` ≈ **335 ms** is well under the ceiling (~**78%** headroom vs 1500).

**Smoke:** `python scripts/smoke_gallery.py --check-startup-budget` → **OK** (2026-08-27).

**Out of cold-start wave:** Gallery idle RSS · nav switch p50 · kit zip size — later waves (**H** / **C** / **K**).

---

## Memory sign-off (**H10–H17** · **3.48**)

| ID | Slice | Deliverable | Verdict |
|----|-------|-------------|---------|
| **H10** | **3.41** | FluentIcons / glyph path — shared PreferNoHinting `QFont` cache | Shipped |
| **H11** | **3.42** | Theme singleton — lazy Text/Display stacks; density formula-only | Shipped |
| **H12** | **3.43** | List/Tree `reuseItems` + mild `cacheBuffer`; NavigationView pane later drops pooling (variable-height groups) | Shipped |
| **H13** | **3.44** | DataTable lean ListView roles + hidden-column filter discipline | Shipped |
| **H14** | **3.45** | Chart series ring caps documented + opt-in `capacity` / `trimRing` | Shipped |
| **H15** | **3.46** | Gallery page Component unload (`pageCacheLimit: 8` + pins) | Shipped |
| **H16** | **3.47** | Pixmap / shadow cache caps; ElevatedChrome FBO hygiene | Shipped |
| **H17** | **3.48** | This section — wave sign-off + working-set table | **Signed off** |

### Gallery idle working-set measurements

Method: Release `qwinui3_gallery.exe` (no `--smoke`), wait **5 s** after launch (Home settled), sample process **WorkingSet64** / **PrivateMemorySize64**, then quit. Repeat cold starts **n=5**. Machine: Win Release (dev, this audit), Qt 6.8, **2026-08-27**.

| Metric | Avg | Min | Max | n |
|--------|-----|-----|-----|---|
| WorkingSet (MB) | **136.2** | 133.8 | 138.5 | 5 |
| Private bytes (MB) | **162.7** | 159.4 | 165.6 | 5 |

**Honesty:** **3.33** pre-wave idle RSS was **never recorded**, so “↓ vs 3.33” cannot be claimed at H17. Post-wave idle WS is the baseline for later **3.90** / CI comparisons. No CI RSS gate yet (same posture as S17 documenting startup before inventing new infra).

**Recipes:** [performance.md](performance.md) H10–H16 rows (icon fonts, Theme trim, list overscan, DataTable lean roles, chart rings, Gallery page cache, pixmap/shadow caps).

**Out of memory wave:** Nav switch p50 · kit zip size · silent-runtime paint coalesce (**C20+**).

---

## Silent runtime sign-off (**C20–C26** · **3.55**)

| ID | Slice | Deliverable | Verdict |
|----|-------|-------------|---------|
| **C20** | **3.49** | Remaining experimental chart paint coalesce | Shipped |
| **C21** | **3.50** | Binding churn / Gallery incremental nav sync | Shipped |
| **C22** | **3.51** | ItemsView / ListDetailsView filter + `cacheBufferPx` | Shipped |
| **C23** | **3.52** | DataTable / TreeDataGrid row-height cache + skip | Shipped |
| **C24** | **3.53** | NavigationView pane rebuild costs | Shipped |
| **C25** | **3.54** | Stable-six chart coalesce inventory | Shipped |
| **C26** | **3.55** | This section — wave sign-off + switch p50 | **Signed off** |

### Gallery warm page-switch measurements

Method: Release `qwinui3_gallery.exe`, full nav model ready, **warm** `NavigationView.openPage` among cached Components with **`pageTransition: none`** (framework switch cost — excludes default slide animation). Sample wall ms from `openPage` to next event-loop turn after StackView replace. Pages: HomePage · ButtonPage · SettingsPage · DataTablePage · NavigationViewPage · PerformancePage. **n=24** warm switches. Machine: Win Release (dev, this audit), Qt 6.8, **2026-08-27**.

| Metric | Value | n |
|--------|-------|---|
| Switch p50 (ms) | **146** | 24 |
| Switch p95 (ms) | **215** | 24 |
| Switch avg (ms) | **135** | 24 |

**Honesty:** **3.33** pre-wave nav switch ms was **never recorded**, so “≤ 3.33 baseline” cannot be numerically proven at C26. Post-wave **p50 ≈ 146 ms** (mode `none`) is the frozen baseline for later **3.90** comparisons. Default Gallery `pageTransition: slide` still uses Theme motion (~`motionSlow` enter) on top of this framework cost — silent-runtime slices did **not** shorten transitions. No CI switch-p50 gate yet (same posture as H17).

**Smoke:** `python scripts/smoke_gallery.py --check-startup-budget` still **OK** at sign-off.

**Recipes:** [performance.md](performance.md) C20–C25 rows (chart coalesce, binding churn, list/table defaults, Nav pane, stable-six inventory).

**Out of silent-runtime wave:** Control depth (**D30+**) · kit zip size · CI switch gate.

---

## Baseline capture (fill as waves land)

| Metric | Machine | **3.33** / pre-wave | **3.40** cold start | **3.48** memory | **3.55** runtime | **3.90** result |
|--------|---------|---------------------|---------------------|-----------------|------------------|-----------------|
| Interactive shell ms (`main=`) | Win Release (dev) | advisory &lt; 1500 (no CI fail) | **~335** (n=5) | — | — | |
| Interactive shell ms | CI Win Release | advisory &lt; 1500 | **≤ 1500** absolute gate (**S16**) | — | — | |
| Gallery idle WorkingSet (MB) | Win Release (dev) | _not captured_ | — | **~136** (n=5) | — | |
| Gallery idle RSS (MB) | CI Win Release | _TBD_ | — | — | — | |
| Nav page switch p50 (ms) | Win Release (dev) | _not captured_ | — | — | **~146** (n=24, mode `none`) | |
| Kit zip `shell` (MB) | Release package | _TBD_ | — | — | — | |
| PyPI default wheel (MB) | Release | _TBD_ | — | — | — | |
