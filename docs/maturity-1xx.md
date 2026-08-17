# 1.xx maturity checkpoint (1.51)

Deliberate **“where we are”** release for the 1.line after the post-1.40 arc (`1.41`…`1.50`). **Not** a soft 2.00.

**Latest mid-horizon (1.60):** [checkpoint-160.md](checkpoint-160.md) — re-audit + confirmed `1.61`…`1.70` order.

Related: [compatibility-1xx.md](compatibility-1xx.md) · [stable-api.md](stable-api.md) · [upgrade-notes.md](upgrade-notes.md) · [ROADMAP.md](../ROADMAP.md) · Gallery **Pitfalls**.

---

## Verdict

| Question | Answer (1.51) |
|----------|----------------|
| Ready for LoB apps on stable surface? | **Yes** — prefer [stable-api.md](stable-api.md) + [examples/gallery-shell](../examples/gallery-shell/) |
| Start **2.00**? | **No** — stay on 1.xx through planned `1.52`…`1.70` (or pause) |
| Posture for the next slices? | **Prefer harden / field polish / docs** over inventing new control families |
| Experimental still movable? | **Yes** — Media, ConnectedAnimation, niche charts, Snap Layouts, TabView tear-out (1.37 defer) |

---

## Audit snapshot (1.51)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP `docs/*.md` links | **0 broken** (`scripts/checkpoint_1_51_audit.py`) |
| Gallery catalog pages | **~184** (controls + recipe hubs) |
| Public component docs | **~208** public / **~219** generated pages |
| Stable map vs Gallery | Stable list remains the product contract; Gallery also demos experimental — treat unlisted public types as experimental ([stable-api.md](stable-api.md)) |
| Starter path | **`examples/gallery-shell`** (1.50) first; `nav-settings` for hand-wired `StandardWindow` |

No silent Theme / shell / stable renames since the **1.40** freeze. Additive APIs in `1.41`…`1.50` (clipboard, TwoPaneView, contrast helpers, icon micro-motion, NavigationWindow `pageModule`, …) stay compatible under the freeze rules.

---

## LTS-style guidance (for a while)

Until a later checkpoint says otherwise:

1. **Ship on stable** — Theme tokens, shells, and types named on [stable-api.md](stable-api.md).
2. **Copy `gallery-shell`**, not the full Gallery tree — [examples/gallery-shell/README.md](../examples/gallery-shell/README.md) keep-vs-delete.
3. **Harden first** — field P0s (portal / DPI / tray / WebView2 / packaging) beat new surfaces; **1.52** shipped CI/docs harden when no field P0s were open.
4. **Promote only in named minors** — update stable-api changelog; do not silently flip experimental → stable.
5. **Do not draft 2.00** until several breaking needs pile up — [ROADMAP.md](../ROADMAP.md) far-future section.

---

## Deferred (unchanged intent)

Still experimental / won’t-promote-for-now (see [stable-api 1.37 defer](stable-api.md#137-defer--wont-promote-for-now)):

- `MediaPlayerElement` (optional Multimedia — **deferred 1.67**)
- ConnectedAnimation / entrance / theme transition helpers
- TabView tear-out
- Niche charts beyond the stable six
- WebView2 advanced Environment / multi-profile
- Snap Layouts / battery / online / screens / recent-docs helpers

Scheduled follow-ups remain on the roadmap (`1.61`…`1.70`) — order confirmed at **1.60**; may flex for field P0s.

---

## Consumer checklist

Use [upgrade-notes.md](upgrade-notes.md) for `1.50` → `1.51`. Short form:

- [ ] Pin / reinstall `QWINUI3_VERSION` **1.51**
- [ ] Skim stable-api changelog rows **1.49**…**1.51**
- [ ] Prefer `examples/gallery-shell` if starting a new app shell
- [ ] Rebuild **Release**; optional Gallery `--smoke`

---

## Re-run the link audit

```bat
python scripts/check_docs_links.py
```

(`scripts/checkpoint_1_51_audit.py` remains a thin alias.)
