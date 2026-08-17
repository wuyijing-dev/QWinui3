# Navigation mental model (2.56)

Targeted fixes for **Back vs pane vs stack** confusion — not a new nav control.

Related: [navigation.md](navigation.md) · [window-shells.md](window-shells.md) · [planning/friction-log.md](planning/friction-log.md)

---

## Goal

Product shells mix **TitleBar Back**, **pane toggle**, **footer**, and **in-page drill** — teams wire the wrong API and Back feels random. **2.56** closes the top three footguns with small **NavigationView** guardrails + Gallery refresh.

---

## Top 3 footguns (fixed in 2.56)

| # | Symptom | Cause | Fix |
|---|---------|-------|-----|
| **1** | Back dead after in-page drill | `openDrill` / `openPage` skip soft history | **`navigateToPage(name, mode)`** / **`openDrillWithHistory(name)`** |
| **2** | Breadcrumb “Home” then Back returns to wrong page | Crumb click pushed current page onto history | **`selectBreadcrumbIndex`** suppresses history push |
| **3** | Back chevron always visible / never visible | Static **`isBackButtonVisible: true`** or never bound | Bind to **`nav.canGoBack`** ( **`NavigationWindow`** does this) |

**Also:** **`isPanePinned`** — overlay / auto mode will not auto-collapse the pane or light-dismiss scrim.

**Out:** New nav control; TabView tear-out; full pane-width persistence.

---

## Deliverables

| Item | Location |
|------|----------|
| In-page drill + history | **`NavigationView.navigateToPage`** · **`openDrillWithHistory`** |
| Breadcrumb guard | **`selectBreadcrumbIndex`** — no history push |
| Pane pin | **`isPanePinned`** on **NavigationView** / **NavigationWindow** |
| Back sync helpers | **`canGoBackChanged`** · **`effectiveBackVisible`** |
| Gallery refresh | **NavigationView** **2.56** block · Pitfalls checklist |
| Recipes | [navigation.md](navigation.md) **2.56** rows |

---

## App checklist

- [ ] **TitleBar** / **PlatformTitleBar**: `isBackButtonVisible: nav.canGoBack` · `onBackRequested: nav.navigateBack()`
- [ ] In-page detail: **`nav.navigateToPage("DetailPage", "drill")`** — not bare **`openPage`**
- [ ] **BreadcrumbBar**: `onItemInvoked: (i) => nav.selectBreadcrumbIndex(i)` — do not hand-roll **`selectKey`**
- [ ] **Footer**: use **`selectFooter()`** / footer row — same history as pane items
- [ ] Overlay pane product UX: **`isPanePinned: true`** when users must keep the rail open
- [ ] Do **not** nest a full **NavigationView** inside every **TabView** tab

**Next:** **2.58** OSK in apps · **2.59** named slow flows
