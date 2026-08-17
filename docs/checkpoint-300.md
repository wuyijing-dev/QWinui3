# 2.x close-out checkpoint (3.00)

Final audit of **2.00…2.73** before the **3.00** breaking major. **Does not** ship breaking code in the checkpoint tag itself — breaks land only in **3.00**.

Earlier: [checkpoint-273.md](checkpoint-273.md) · [checkpoint-270.md](checkpoint-270.md) · [checkpoint-260.md](checkpoint-260.md) · [checkpoint-250.md](checkpoint-250.md) · [upgrade-notes.md](upgrade-notes.md) · [ROADMAP.md](../ROADMAP.md).

**Platforms:** **Windows + Linux** — macOS first-class, Fluent 2 fork, Hub controls remain **withdrawn**.

---

## Verdict

| Question | Answer (3.00 gate) |
|----------|-------------------|
| **2.x line complete?** | **Not yet** — fill when **2.73** + this checkpoint ship |
| **Breaking inventory finalized?** | **Draft** in [upgrade-notes.md](upgrade-notes.md) **Upgrade 2.73 → 3.00 (draft)** |
| **Next tag posture?** | **3.00** is the next *planned* major — **gate: 2.73 shipped + this checkpoint green** |
| **2.xx freeze?** | **Active through 2.73** — lifts at **3.00** with documented remaps |
| **Friction queue empty?** | **Expected** — [friction-log.md](planning/friction-log.md) P0/P1 closed or honest defer before 3.00 |

---

## Audit snapshot (3.00 prep)

| Check | Result |
|-------|--------|
| Tranche 1 (**2.00…2.50**) | **TBD** — [checkpoint-250.md](checkpoint-250.md) |
| Friction tranche (**2.51…2.60**) | **TBD** — [checkpoint-260.md](checkpoint-260.md) |
| Professional surfaces (**2.61…2.70**) | **TBD** — [checkpoint-270.md](checkpoint-270.md) |
| Python / PyPI (**2.71…2.72**) | **TBD** — [checkpoint-273.md](checkpoint-273.md) |
| Recipe + ROADMAP `docs/*.md` links | **TBD** (`python scripts/check_docs_links.py`) |
| Consumer matrix Win + Linux | **TBD** — [packaging-consumer.md](packaging-consumer.md) |
| Gallery smoke | **TBD** — `python scripts/smoke_gallery.py --build-dir build` |
| Product version target | **3.00** |

---

## 3.00 prep inventory (draft — breaks land in 3.00 only)

Full consumer steps: [upgrade-notes.md](upgrade-notes.md) **Upgrade 2.73 → 3.00 (draft)**.

| Area | 3.00 intent (not shipped in 2.73) |
|------|-------------------------------------|
| **Qt floor** | Drop **Qt 6.8** shim path; floor **6.10 LTS** (forward **6.12+** OK) — [qt-version-compat.md](qt-version-compat.md) + CI |
| **Theme** | Remove remaining 2.x compatibility aliases (stroke/focus/density leftovers from **2.00** defer) — **not** Fluent 2 redesign |
| **Experimental cleanup** | **Permanent defer** types (sibling charts/gauges, **MediaPlayerElement**, withdrawn Hub) **removed from default imports** or moved to explicit experimental module — inventory from **2.45** / **2.67** |
| **Stable surface** | [stable-api.md](stable-api.md) becomes **3.xx contract**; new [compatibility-3xx.md](compatibility-3xx.md) freeze |
| **CMake / packaging** | **`find_package(QWinUI3 CONFIG)`** primary consumer path (**2.02**); document dev-only `add_subdirectory`; PyPI wheel semver aligns if **2.72** shipped |
| **Shell / Platform** | Remove undocumented Gallery-era window aliases; `StandardWindow` / `NavigationWindow` / `WindowHelper` remain |
| **Versioning** | `QWINUI3_VERSION` **3.00**; tags `v3.00` |

Apps that **cannot** leave Qt 6.8: **stay on 2.73** (last 2.x).

---

## Post-3.00 posture

1. **Open 3.00 only after 2.73** — one named breaking major; follow-ups are **`3.01+`** (friction-gated, same rules as **2.51+**).
2. **No catalog shopping in 3.xx** — new minors need [friction-log.md](planning/friction-log.md) rows.
3. **Animations stay** — perf work trims waste, not motion ([performance.md](performance.md)).
4. **Copy `gallery-shell` or first-app quickstart** (**2.52**), not the full Gallery tree.
5. **Field harden first** on the new Qt floor after 3.00 ships.

---

## Consumer checklist

- [ ] Pin / rebuild **2.73** Release (or stay on **2.72** / **2.70** until ready)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) draft **2.73 → 3.00**
- [ ] Grep app for experimental types — migrate to stable six / compose recipes before 3.00
- [ ] Prefer [stable-api.md](stable-api.md) + `examples/gallery-shell`
- [ ] Run consumer matrix locally if using shared package — [packaging-consumer.md](packaging-consumer.md)
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Related

| Doc | Role |
|-----|------|
| [roadmap.md](roadmap.md) | Full **2.00…3.00** plan |
| [roadmap-strategy.md](planning/roadmap-strategy.md) | Phase guide through 3.00 |
| [friction-log.md](planning/friction-log.md) | Gate for **3.01+** |
