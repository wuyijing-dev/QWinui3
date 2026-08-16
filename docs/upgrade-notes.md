# Consumer upgrade notes (1.40)

How to move a product app between **QWinUI3 `1.xx` minors** without surprises.

**Compatibility contract:** [compatibility-1xx.md](compatibility-1xx.md).  
**Stable types:** [stable-api.md](stable-api.md).  
**Qt floors:** [qt-version-compat.md](qt-version-compat.md).

---

## Template (copy per release)

Use this block when you ship a tagged `vX.YY` that consumers must react to. Skip rows that are N/A.

```markdown
## Upgrade X.YY → X.ZZ

**Product version:** X.ZZ (`QWINUI3_VERSION`)  
**Date:** YYYY-MM-DD  
**Qt:** still 6.5+ / recommended 6.8 (change only if true)

### Action required
| Area | Change | What to do |
|------|--------|------------|
| … | … | … |

### Optional / polish
- …

### No action (compatible)
- Stable Theme / shell / control APIs unchanged for this slice.
```

Maintainers: append a filled section below when a slice has consumer-visible breaks or important opt-ins. Pure docs / Gallery-only / additive defaults usually need only a one-line **No action** note.

---

## Checklist (every upgrade)

1. Bump / reinstall the kit (`QWINUI3_VERSION` / Release zip / `add_subdirectory` pin).
2. Confirm Qt major/minor still matches your linked kit — [packaging-consumer.md](packaging-consumer.md).
3. Skim [stable-api.md](stable-api.md) changelog for new **promotes** or **defer** notes.
4. Rebuild Release; run your smoke / Gallery `--smoke` if you vendor the Gallery binary.
5. If you fork Theme colors: keep using `customAccent` / packs — do not assign readonly `bgCard` etc.

---

## Recent minors (filled)

### Upgrade 1.40 → 1.41

**Product version:** 1.41  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Prefer [drag-drop.md](drag-drop.md) for FileDropZone + FilePicker browse + CopyButton / `WindowHelper` clipboard.
- Gallery FileDropZone / CopyButton pages updated.

#### No action (compatible)

- Additive docs + Gallery; `FileDropZone` / `CopyButton` / clipboard helpers unchanged in shape.

### Upgrade 1.39 → 1.40

**Product version:** 1.40  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Action required

| Area | Change | What to do |
|------|--------|------------|
| Docs gate | Published [compatibility-1xx.md](compatibility-1xx.md) | Prefer frozen Theme / shell / stable APIs for new code; treat this doc as the 1.4x gate |

#### Optional / polish

- Link your internal “supported kit” page to compatibility-1xx + stable-api.
- Gallery **Pitfalls** page points at the freeze (no API change).

#### No action (compatible)

- No Theme token renames, no shell API removals, no stable control breaks in 1.40.

### Upgrade 1.38 → 1.39

**Product version:** 1.39

#### Optional / polish

- Apps using `NavigationView` page stacks: consider `pageCacheLimit` (default **24**) and `initialPageTransition: "none"` for cold start — [performance.md](performance.md).
- `clearPageCache()` available after long browse sessions.

#### No action (compatible)

- Existing NavigationView call sites keep working; cache limit only evicts least-recently-used **Components** (not a public type rename).

### Upgrade 1.37 → 1.38

**Product version:** 1.38

#### Optional / polish

- Linux field hosts: read [platform-linux-wayland.md](platform-linux-wayland.md) failure matrix (SSD, portal parent, SNI).

#### No action (compatible)

- Docs / Gallery System integration callouts only.

---

## When we would break (2.00 territory)

Examples that **do not** belong in a quiet 1.xx:

- Renaming `Theme.bgCard` or stable `NavigationView.openPage`
- Dropping Qt 6.5 without a named roadmap decision
- Removing a type listed as Stable on stable-api without a deprecation window

Track those only under a future **2.00** plan in [ROADMAP.md](../ROADMAP.md).
