# 1.xx close-out checkpoint (1.90)

Final audit of **1.83…1.90** (accessibility wave 3 → performance arc → close-out). **Still 1.xx through 1.90** — the [1.xx freeze](compatibility-1xx.md) lifts only at **2.00**.

Earlier: [checkpoint-178.md](checkpoint-178.md) (long-horizon) · [checkpoint-160.md](checkpoint-160.md) (mid-horizon) · [compatibility-1xx.md](compatibility-1xx.md) · [stable-api.md](stable-api.md) · [performance.md](performance.md) · [ROADMAP.md](../ROADMAP.md).

---

## Verdict

| Question | Answer (1.90) |
|----------|----------------|
| **1.xx close-out done?** | **Yes** — docs, perf arc sign-off, **2.00 prep draft** only (no breaking code) |
| **Performance arc (1.86…1.89)?** | **Signed off** — four waves shipped; **animations stay**; trim no-op / defer / debounce only |
| **Next tag posture?** | **2.00** is the next *planned* major — **gate: 1.90 shipped**; do not open 2.00 PRs before this checkpoint lands |
| **Freeze (1.40)?** | **Active through 1.90** — ends at **2.00** with documented remaps |
| **OSK / packaging promote?** | **Still experimental / parked** — **2.01+** (not part of 1.90) |

---

## Audit snapshot (1.90)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP `docs/*.md` links | **OK** (`python scripts/check_docs_links.py`) |
| Gallery catalog entries | **195** (`python scripts/smoke_catalog.py`) |
| Critical smoke pages | **18** (synced: `main.cpp` · `ControlCatalog` · `smoke_catalog.py`) |
| Component docs (`docs/components.json`) | **215** public types |
| Product version | **1.90** |
| Starter path | **`examples/gallery-shell`** (+ **`examples/multi-window`**, **`examples/floating-osk`** experimental) |
| Freeze accurate | **Yes** — [compatibility-1xx.md](compatibility-1xx.md) + [stable-api.md](stable-api.md) |

### Absorbed since 1.78 (theme summary)

| Slice | Theme |
|-------|--------|
| **1.79** | Linux / Wayland field harden |
| **1.80…1.84** | Win11 OSK chrome/behavior, floating window, consumer example |
| **1.85** | Accessibility wave 3 — dialog/flyout focus return; live regions |
| **1.86** | Performance wave 1 — shell / window runtime |
| **1.87** | Performance wave 2 — navigation & page stack |
| **1.88** | Performance wave 3 — lists & data collections |
| **1.89** | Performance wave 4 — style, charts & Gallery heavy pages |
| **1.90** | This close-out + **1.90 → 2.00** upgrade draft |

---

## Performance arc sign-off (1.86…1.89)

Rule: **trim waste, not motion.** Pane collapse, page transitions, hover/press feedback, and chart reveal motion are unchanged when interacting.

| Wave | Version | Checklist | Status |
|------|---------|-----------|--------|
| 1 | **1.86** | Solid host layer fill; DWM border pin; Solid focus path skips redundant 80 ms timer bursts | **Green** |
| 2 | **1.87** | StackView per-axis animators; compact flyout `MultiEffect` defer; `TabView` idle `Behavior` gating | **Green** |
| 3 | **1.88** | `DataTable` filter debounce + skip unchanged `_viewRows`; optional `filterText` on JS-array lists | **Green** |
| 4 | **1.89** | `ElevatedChrome` shadow defer; Style hot-path `Behavior` gating; chart reveal budget + coalesced redraw; Gallery deferrals | **Green** |

Validation: Release build + `python scripts/smoke_gallery.py --build-dir build` after each wave. Smoke `--smoke` timing is **advisory** (machine-dependent) — see [ci-smoke.md](ci-smoke.md).

Detail: [performance.md](performance.md) (shell · navigation · lists · style/charts sections + arc summary).

---

## 2.00 prep inventory (draft — breaks land in 2.00 only)

Full consumer steps: [upgrade-notes.md](upgrade-notes.md) **Upgrade 1.90 → 2.00 (draft)**.

| Area | 2.00 intent (not shipped in 1.90) |
|------|-------------------------------------|
| **Qt floor** | Drop **Qt 6.5**; floor **6.8 LTS** (forward 6.10+) — [qt-version-compat.md](qt-version-compat.md) + CI |
| **Theme** | Collapse duplicate stroke/focus aliases only (example: unify legacy `strokeFocus*` / `focusOuter` naming) — **not** a Fluent 2 redesign |
| **Shell** | Remove Gallery-era compatibility aliases; keep `StandardWindow` / `NavigationWindow` / `WindowHelper` as the contract |
| **Experimental leftovers** | Types still experimental after **2.01** OSK slice: promote, move to an explicit experimental module, or remove with an upgrade-notes row |
| **Packaging** | `QWINUI3_VERSION` **2.00**; shared/static default changes only if **2.01+** documents them |

Apps that **cannot** leave Qt 6.5: **stay on 1.90**.

---

## Posture for `2.00+`

1. **Open 2.00 only after 1.90** — one named breaking major; follow-ups are `2.01+`.
2. **Ship on stable** — through 1.90, Theme tokens, shells, and types on [stable-api.md](stable-api.md) remain the contract.
3. **Copy `gallery-shell`**, not the full Gallery tree, for new apps.
4. **OSK promote** — explicit green soak in **2.01+**, not bundled into 2.00 by default.
5. **Field harden first** on the new Qt floor after 2.00 ships.

---

## Consumer checklist

- [ ] Pin / rebuild **1.90** Release (or stay on **1.89** until ready — no breaks in 1.90)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) `1.89` → `1.90` and draft `1.90` → `2.00`
- [ ] Read [performance.md](performance.md) arc summary if tuning shell / nav / lists / charts
- [ ] Prefer [stable-api.md](stable-api.md) + `examples/gallery-shell`
- [ ] Treat `OnScreenKeyboard` as **experimental** until **2.01+** promote
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Re-run audits

```bat
python scripts/check_docs_links.py
python scripts/smoke_catalog.py
python scripts/smoke_gallery.py --build-dir build
```
