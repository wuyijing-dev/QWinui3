# Navigation & TabView (1.27)

Recipes for the **default app frame**: [`NavigationView`](components/NavigationView.md) (destinations) vs [`TabView`](components/TabView.md) (documents). Prefer these over inventing a second shell stack.

Gallery: **NavigationView** · **TabView** · (shell) Gallery `Main.qml`.  
**Start from Gallery shell:** [`examples/gallery-shell`](../examples/gallery-shell/) (**1.50**).  
Hand-wired rail: [`examples/nav-settings`](../examples/nav-settings/).

Related: [window-shells.md](window-shells.md) · [window-chrome.md](window-chrome.md) · [accessibility.md](accessibility.md).

---

## Choosing

| Need | Prefer |
|------|--------|
| App destinations (Home / Settings / sections) | **NavigationView** + `pageModule` / `component` |
| Multiple open documents / editors | **TabView** (add / close / reorder) |
| Master list + reading pane | [`ListDetailsView`](components/ListDetailsView.md) — not TabView |
| Settings-only page | [`SettingsView`](components/SettingsView.md) (see [forms.md](forms.md)) |
| Full shell chrome | `NavigationWindow` ([`examples/gallery-shell`](../examples/gallery-shell/), **1.50**) or `StandardWindow` + `NavigationView` ([`nav-settings`](../examples/nav-settings/)) |

**Do not** nest a full NavigationView inside every TabView page as a second app rail — pick one primary frame.

Tear-out (`canTearOutTabs`) stays **experimental** (may change; see TabView notes). Core `TabView` is **stable (1.37)** — [stable-api.md](stable-api.md).

---

## Pane display modes

| `paneDisplayMode` | Behavior |
|-------------------|----------|
| `left` | Expanded left rail |
| `leftCompact` | Icon rail; expand via hamburger / `paneOpen` |
| `leftMinimal` | Hamburger only; pane overlays content with light-dismiss scrim |
| `top` | Horizontal top nav; optional in-pane Back |
| `auto` | `left` when width ≥ `autoCompactThreshold` (default **1008**), else `leftCompact`. Hamburger collapse in `left` stays collapsed (does not force the pane open on width ticks). |

```qml
NavigationView {
    paneDisplayMode: "auto"
    autoCompactThreshold: 1008
    openPaneLength: Theme.navPaneWidth
    compactPaneLength: Theme.navPaneCompactWidth
}
```

| Tip | Detail |
|-----|--------|
| Linux / small laptops | Prefer `auto` so the rail collapses without custom breakpoints — [adaptive-layout.md](adaptive-layout.md) (**1.42**) · [density.md](density.md) |
| Hide rail | `isPaneVisible: false` |
| Compact + title | `alwaysShowHeader: true` shows hamburger + `paneTitle` in leftCompact |
| Master–detail pages | Prefer `ListDetailsView` / `TwoPaneView` inside the page — not a second NavigationView |

---

## Footer (Settings)

Footer is the WinUI **Settings** row at the bottom of the pane:

```qml
NavigationView {
    footerText: qsTr("Settings")
    footerSymbol: FluentIcons.Settings   // or footerIcon glyph
    footerComponent: "SettingsPage"      // loaded via pageModule
    isSettingsVisible: true
    // …
    // Programmatic: nav.selectFooter()
}
```

| Tip | Detail |
|-----|--------|
| No settings page | `footerComponent: ""` still shows the row; handle `onFooterClicked` |
| Hide row | `isSettingsVisible: false` |
| Custom chrome | `paneFooter: …` slot under the footer row |

---

## Back stack

NavigationView keeps a soft **`pageHistory`** for TitleBar / top-pane Back (StackView still **replace**s content):

```qml
TitleBar {
    isBackButtonVisible: nav.canGoBack
    isBackButtonEnabled: nav.canGoBack
    onBackRequested: nav.navigateBack()
    onPaneToggleRequested: nav.paneOpen = !nav.paneOpen
}

NavigationView {
    paneDisplayMode: "auto"
    // Top mode can also show an in-pane Back:
    // isBackButtonVisible: true
}
```

| API | Role |
|-----|------|
| `canGoBack` / `navigateBack()` | Soft history |
| `openPage` / `selectKey` / `navigateToTitle` | Forward navigation |
| `pageTransition` | Default transition for pane clicks (`slide`, `fade`, `drill`, …) |
| Same-key click | Skips replace + transition |

Left rail does **not** host Back — wire the **TitleBar** (Gallery / nav-settings pattern).

---

## Compact / overlay patterns

| Pattern | Recipe |
|---------|--------|
| Responsive shell | `paneDisplayMode: "auto"` + TitleBar pane toggle |
| Overlay drawer | `leftMinimal` — open with hamburger; scrim dismisses |
| Host-owned content | `hostContent: true` + `content: …` (e.g. NavigationWindow) instead of `pageModule` |
| Groups | `model` entries `type: "group"` with `children[]`; `toggleGroup` / `setGroupExpanded` |

```qml
model: [
    { type: "item", key: "home", title: qsTr("Home"),
      symbol: FluentIcons.Home, component: "HomePage" },
    { type: "group", key: "lib", title: qsTr("Library"),
      symbol: FluentIcons.Library, children: [
        { title: qsTr("Docs"), component: "DocsPage" }
      ] }
]
```

---

## TabView (documents)

```qml
TabView {
    tabWidthMode: "equal"           // equal | sizeToContent | compact
    closeButtonOverlayMode: "onPointerOver"
    isAddTabButtonVisible: true
    tabsReorderable: true
    canTearOutTabs: false           // experimental when true
    model: [
        { title: qsTr("Home"), symbol: FluentIcons.Home, content: homeBody },
        { title: qsTr("Report"), content: reportBody }
    ]
}
```

| Tip | Detail |
|-----|--------|
| Close | Handle `tabCloseRequested` / remove from model |
| Strip chrome | `tabStripHeader` / `tabStripFooter` |
| Inside NavigationView | Optional: TabView as **page content** for multi-document tools |

---

## Accessibility (demo path)

| Surface | Guidance |
|---------|----------|
| NavigationView | `Accessible.name` defaults to `headerText` / `paneTitle` — set a clear app name |
| TitleBar Back / pane toggle | Built-in names; keep `isBackButtonVisible` in sync with `canGoBack` |
| Footer | Uses `footerText` |
| TabView tabs | Prefer `title` on each model item; give strip header buttons an `Accessible.name` |
| Pages | Set page-level names when multiple forms share a shell ([forms.md](forms.md) `accessibleName`) |

Gallery NavigationView / TabView pages and [`examples/nav-settings`](../examples/nav-settings/) follow this path.

---

## Starter alignment (1.27)

[`examples/nav-settings`](../examples/nav-settings/) matches the documented shell:

1. `StandardWindow` + `BackdropSolid`
2. `PlatformTitleBar` / `TitleBar` pane toggle + **Back ↔ `navigateBack`**
3. `NavigationView` with `paneDisplayMode: "auto"`, Home / About, Settings `footerComponent`

Copy that folder, then swap `pageModule` / model entries for your app.
