# User friction log (2.xx gate)

**Purpose:** Record **real** kit pain — what WinUI 3 / QWinUI3 app authors hit in production or serious prototypes. A **`2.xx` tag (especially 2.51+)** needs a row here **before** it lands on [roadmap.md](roadmap.md).

**Not for:** WinUI parity shopping, “we lack control X”, internal refactors with no user impact, perf micro-opts without a named slow flow.

---

## Row template (copy per pain)

```markdown
### FL-NNN — Short title

| Field | Value |
|-------|--------|
| **Severity** | P0 / P1 / P2 |
| **Source** | GitHub issue / Gallery soak / example author / field app |
| **Pain** | What feels broken or unusable (one paragraph) |
| **Workaround today** | What teams do instead |
| **Proposed slice** | Roadmap tag or “fix in place” |
| **Status** | open / scheduled / fixed in X.YY / withdrawn |
```

---

## Open / recent (seed from field)

### FL-001 — Title-bar FPS badge invisible when enabled

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | Gallery Settings soak |
| **Pain** | “Show FPS” + Title bar placement ON but nothing visible — layout squeezed `rightHeader`. |
| **Workaround today** | `--show-fps` or Overlay mode only. |
| **Proposed slice** | Fix in **1.92** / **2.04** diagnostics |
| **Status** | fixed in master (PlatformTitleBar `rightHeader`, Settings toggle) |

### FL-002 — Linux client shell unlike Windows DWM

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | Wayland field request |
| **Pain** | No rounded corners / drop shadow on Linux Fluent shell; looks unfinished vs Win11. |
| **Workaround today** | Solid opaque window or compositor defaults. |
| **Proposed slice** | **1.92** shipped; **2.03** compositor polish |
| **Status** | partial — **1.92** client CSD; **2.03** if field gaps remain |

### FL-003 — Consumer CMake / import path friction

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | packaging-consumer / example authors |
| **Pain** | Every new app struggles with `add_subdirectory` vs zip vs `find_package` sketch. |
| **Workaround today** | Copy Gallery tree or hand-wire import paths. |
| **Proposed slice** | **2.02** productize Path C |
| **Status** | open |

### FL-004 — Experimental vs stable confusion

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | stable-api / Pitfalls |
| **Pain** | Teams ship OSK, charts, or shell extras thinking they are stable. |
| **Workaround today** | Read entire stable-api changelog. |
| **Proposed slice** | **2.45** sweep + **2.51** clarity |
| **Status** | open |

### FL-005 — (placeholder — add next field pain here)

| Field | Value |
|-------|--------|
| **Severity** | P? |
| **Source** | |
| **Pain** | |
| **Workaround today** | |
| **Proposed slice** | |
| **Status** | open |

---

## Rules

1. **2.51…2.60:** no open P0/P1 row → **skip the tag** (empty queue is OK).
2. **Conditional controls (2.06, 2.21, …):** must cite a row proving composition failed.
3. **Close rows** when shipped; link commit / version in **Status**.
4. Checkpoints **2.20 / 2.30 / 2.50 / 2.60** review this file before reordering roadmap.

See [roadmap.md](roadmap.md) · [ROADMAP.md](../ROADMAP.md).
