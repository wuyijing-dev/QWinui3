# Checkpoint 280 — Capability pack soft audit (2.71…2.80)

**Status:** soft green on master at **2.80**  
**Scope:** Capability pack tranche 6 — Python residual · consumer DX · platform polish · offline/security UX helpers

## Slices

| Tag | Theme | Verdict |
|-----|-------|---------|
| **2.71** | DataTable CSV · MaskedTextField · PermissionGate | Shipped |
| **2.72** | WindowMessageBus · SessionTimeout | Shipped |
| **2.73** | Consumer checkpoint · `qwinui3 init` / `doctor --fix` | Shipped — [checkpoint-273.md](checkpoint-273.md) |
| **2.74** | Opt-in SingleInstance · `qwinui3 run` | Shipped — [single-instance.md](single-instance.md) |
| **2.75** | ErrorBoundary recovery pattern | Shipped — Pitfalls Gallery demo |
| **2.76** | `qwinui3 upgrade` · Path C primary callout | Shipped — [packaging-consumer.md](packaging-consumer.md) |
| **2.77** | RecentFiles | Shipped — Extras + Gallery |
| **2.78** | OfflineBanner · OperationRetry | Shipped — Extras + Gallery |
| **2.79** | SensitiveField · ConfirmWithReason | Shipped — Extras + Gallery |
| **2.80** | Soft checkpoint-280 | This document |

## Exit criteria

- [x] Opt-in single-instance documented; default multi-instance preserved
- [x] `python scripts/qwinui3.py run` / `upgrade --from X.YY` present
- [x] ErrorBoundary on Pitfalls (pattern demo, not a version checklist)
- [x] Path C callout points at `examples/find-package-consumer` + getting-started
- [x] RecentFiles / OfflineBanner / OperationRetry / SensitiveField / ConfirmWithReason registered in Extras + Gallery catalog
- [x] Friction-log brief closed rows for DX/consumer where appropriate

## Out of checkpoint

- Forcing single-instance on Gallery
- Full crash telemetry / minidump SaaS
- **3.00** breaking close-out (checkpoint-300) — Qt floor 6.10, experimental cleanup

## Next

**3.00** prep per [ROADMAP.md](../ROADMAP.md) · keep friction gate for **3.01+**.
