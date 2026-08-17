# Field harden buffer (2.47)

Tranche-1 **buffer tag** — close actionable **P0/P1** rows from [checkpoint-230.md](checkpoint-230.md) and post-**2.45** [experimental-sweep.md](experimental-sweep.md) audits. **No new controls.**

Related: [friction-log.md](planning/friction-log.md) · [packaging-consumer.md](packaging-consumer.md) · [stable-api.md](stable-api.md) · [docs-ia-v2.md](docs-ia-v2.md)

Validation: `python scripts/check_field_harden_247.py`

---

## Audit scope (2.30 + 2.45)

| ID | Severity | 2.47 disposition |
|----|----------|------------------|
| **FL-003** | P1 | **Partial → documented** — [packaging-consumer.md](packaging-consumer.md) **2.47 path picker**; full `find_package` productize stays **2.02** |
| **FL-004** | P1 | **Partial → hardened** — [stable-api.md](stable-api.md) **Import guard** + Gallery Pitfalls **2.47** checklist; **2.51** lint/templates remain |
| **FL-008** | P1 | **No code change** — wave 5/6 already shipped; reopen only with field metrics → **2.64** |
| **FL-002** | P1 | **No code change** — **2.03** + **2.68** track; no new Linux shell work in buffer |

**Out of scope (by design):** conditional controls (**FL-005/006**), Python tranche (**FL-011**), feature slices.

---

## Deliverables (2.47)

| Item | Location |
|------|----------|
| Consumer path picker | [packaging-consumer.md](packaging-consumer.md) — which Path A–E to use |
| QML import guard recipe | [stable-api.md](stable-api.md) — experimental vs stable imports |
| Pitfalls audit checklist | Gallery **Pitfalls** — **2.47** field buffer |
| Critical smoke bump | `RecipesHubPage` + `PerformancePage` in `--smoke` page loads |
| Friction log sync | [friction-log.md](planning/friction-log.md) — **FL-003** / **FL-004** status lines |

---

## Consumer checklist

- [ ] Pick packaging path with the **2.47** decision table — do not copy Gallery monorepo blindly
- [ ] Product QML: stable imports only unless badge/doc says experimental
- [ ] Re-run `python scripts/smoke_gallery.py` after bumping to **2.47**
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) **2.46 → 2.47**

**Next:** **2.48** friction-only slot (top open **P0** row) · **2.50** [checkpoint-250.md](checkpoint-250.md)
