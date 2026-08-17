# Docs IA v2 (2.46)

MkDocs navigation and [recipes.md](recipes.md) hub regroup for **2.xx** — developer diagnostics, experimental sweep, Gallery expansion matrices, and tranche-1 checkpoints. Not a full site redesign (**1.36** layout stays).

**Find docs in ≤2 clicks:** [Recipes hub](recipes.md) → section tables · MkDocs **Planning** + **Recipes** · Gallery **Recipes hub** mirrors rows.

Related: [roadmap.md](roadmap.md) **2.46** · [Planning hub](planning/index.md) · [ci-smoke.md](ci-smoke.md) (`check_docs_ia_v2.py` · `check_planning_ia.py`).

---

## What moved (2.46 → planning IA)

| Bucket | MkDocs nav | Recipes hub section |
|--------|------------|---------------------|
| Dev vs retail FPS | **Recipes → 2.xx developer → [Developer diagnostics](developer-diagnostics.md)** | [2.xx developer & stability](recipes.md#2xx-developer--stability) |
| FL-004 badges / defer | **Recipes → 2.xx developer → [Experimental sweep](experimental-sweep.md)** | same |
| Friction / strategy / expansion | **Planning → …** | [Planning & product expansion](recipes.md#planning--product-expansion) |
| 2.21…2.38 Gallery matrix | **Recipes → 2.xx controls → [Gallery catalog expansion](gallery-catalog-expansion.md)** | [2.xx controls & Gallery](recipes.md#2xx-controls--gallery) |
| Slice docs (Calendar, wrap grid, …) | **Recipes → 2.xx controls → …** | same |
| 2.50 / 2.60 / 3.00 audits | **Recipes → Quality → 2.xx checkpoints** | [Quality & checkpoints](recipes.md#quality--checkpoints) |

**Unchanged:** **1.xx** getting-started rows, component API index, stable-api top-level tab, legacy **webview2-future** redirect.

---

## Gallery mirror

Gallery **Recipes → Recipes hub** (`RecipesHubPage`) lists the same doc paths as the hub tables — open the matching demo with **Open**. **Planning & product expansion** block added for `docs/planning/`.

Smoke: `python scripts/check_docs_ia_v2.py` · `python scripts/check_planning_ia.py` (no Qt build).

---

## Maintainer checklist

1. Add a **2.xx** recipe doc → row in [recipes.md](recipes.md) **and** `mkdocs.yml` under **Recipes** or **Planning**.
2. Expansion / friction docs → `docs/planning/` + **Planning** nav + [recipes.md](recipes.md) **Planning & product expansion** section.
3. If the doc has a Gallery demo → row in `RecipesHubPage.qml` with the same `docs/…` path.
4. Run `python scripts/check_docs_links.py`, `python scripts/check_docs_ia_v2.py`, and `python scripts/check_planning_ia.py`.
5. Regenerate component index when bumping product version: `python scripts/generate_component_docs.py`.
