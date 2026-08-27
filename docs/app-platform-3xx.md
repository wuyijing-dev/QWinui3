# Application platform (3.01…3.10)

**Status:** Tranche 9 — lands after [checkpoint-300](checkpoint-300.md) (**3.00** close-out).  
**Roadmap:** [ROADMAP.md](../ROADMAP.md#application-platform-tranche-9-301--310)

Recipes for shippable desktop apps — shell, commands, workspace, navigation, dashboards, and vertical kits.

---

## Quick map

| Slice | Theme | Recipes |
|-------|--------|---------|
| **3.01** | Shell 2.0 | [title-bar-cookbook.md](title-bar-cookbook.md) · [window-shells.md](window-shells.md) · [settings-persistence.md](settings-persistence.md) |
| **3.02** | Command system | [commands.md](commands.md) — `shortcutConflicts`, `canExecute`, `refreshContext` |
| **3.03** | Workspace | [app-platform-3xx.md](app-platform-3xx.md) — `SplitWorkspace` + `LayoutPreset` |
| **3.04** | Navigation pro | [navigation.md](navigation.md) — pins, jump list, drilldown |
| **3.05** | Dashboard live | [charts.md](charts.md) — `LiveMetricStrip` · [`examples/dashboard/`](../examples/dashboard/) |
| **3.06** | Charts wave B | [charts.md](charts.md) — `BarChart` bins (**FL-015**) |
| **3.07** | Vertical kits | [`admin-settings`](../examples/admin-settings/) · [`master-detail-crm`](../examples/master-detail-crm/) · [`ops-console`](../examples/ops-console/) |
| **3.08** | Multi-window | [window-shells.md](window-shells.md) — bus + `PanelFloatHost` |
| **3.09** | Platform extras | [file-association.md](file-association.md) · RecentFiles · MenuStatusWindow |
| **3.10** | Sign-off | [checkpoint-310.md](checkpoint-310.md) |

---

## 3.01 — Shell 2.0 (shipped)

### Title-bar commands (**W2**)

Use **`TitleBarCommandBar`** in `leftHeader` or `captionRightHeader` with plain command objects:

```qml
leftHeader: TitleBarCommandBar {
    commands: [
        { id: "save", label: qsTr("Save"), symbol: FluentIcons.Save,
          shortcut: "Ctrl+S", action: saveDocument }
    ]
}
```

Fields: `id`, `label`/`title`, `symbol`/`icon`, `shortcut`, `enabled`, `visible`, `action`.

### Command palette on shells (**W3**)

| Shell | Wiring |
|-------|--------|
| **ShellWindow** / **NavigationWindow** | `commandPaletteEnabled` (default **true**), `commandPaletteCommands`, Ctrl+K / Meta+K |
| **StandardWindow** | Attach **`CommandPaletteHost`** — Ctrl+K / Meta+K |

Gallery **Main** uses **`CommandPaletteHost`** (Ctrl+K). **`examples/gallery-shell`** wires **`SessionRestore`**.

### Session restore (**W4**)

Host **`SessionRestore`** in a zero-size **`Item`** — not as a direct child of **`StandardWindow`**.

**`SessionRestore`** persists geometry (via `geometryPersistenceKey`), **`NavigationView` key**, **pane open**, and **footer** selection:

```qml
SessionRestore {
    window: mainWindow
    navigationView: nav
}
Component.onCompleted: session.restore()
onClosing: session.save()
```

Settings category defaults to `<geometryPersistenceKey>/Session`.

---

## 3.02 — Command system (shipped)

| ID | API |
|----|-----|
| **R1** | `CommandRegistry.dispatch(id)` — scoped run |
| **R2** | `shortcutConflicts()` / `conflicts` — chord collisions |
| **R3** | `canExecute` / `enabled` + `refreshContext()` |

See [commands.md](commands.md).

---

## 3.03 — Workspace layout (shipped)

### SplitWorkspace (**W5**)

```qml
SplitWorkspace {
    paneCount: 3
    orientation: Qt.Horizontal
    minPaneWidth: 120
    ratios: [0.25, 0.5, 0.25]
    pane1: /* … */; pane2: /* … */; pane3: /* … */
}
```

| Method | Role |
|--------|------|
| `setRatios([…])` | Normalize + apply relative widths/heights |
| `focusNextPane()` / `focusPreviousPane()` | Ctrl+Alt+Arrow |
| `snapshot()` / `applyPreset(obj)` | Serialize for LayoutPreset |

Prefer **TwoPaneView** when panes must collapse on narrow windows.

### LayoutPreset (**W6**)

```qml
Item {
    width: 0; height: 0; visible: false
    LayoutPreset {
        category: "MyApp/Layouts"
        workspace: split
    }
}
layouts.save("Editor")
layouts.apply("Monitor")
```

---

## 3.04 — Navigation pro (shipped)

### Pinned favorites (**N1**)

```qml
NavigationView {
    pinnedNavKeys: ["home"]
    maxPinnedNavKeys: 8
    pinnedNavSettingsCategory: "MyApp/NavPins"  // persist JSON in QSettings
}
nav.pinNavKey("home")
nav.toggleNavPin("reports")
```

Pinned keys render as chips above the pane list. Right-click a chip to unpin.

### Jump list (**N2**)

```qml
NavigationView {
    jumpListEnabled: true
}
nav.openJumpList()  // modal A–Z / group index over Overlay
```

### Drilldown stack (**N3**)

```qml
nav.pushDrilldown(qsTr("Order 42"), "OrderDetailPage")
nav.popDrilldown()
// TitleBar Back → navigateBack() pops drilldown before pageHistory
BreadcrumbBar {
    model: nav.breadcrumbTrail
    onItemInvoked: (i) => nav.selectBreadcrumbIndex(i)
}
```

`NavigationWindow` forwards pin / jump / drilldown APIs and `breadcrumbTrail`.

See [navigation.md](navigation.md).

---

## 3.05 — Dashboard live (shipped)

### LiveMetricStrip (**G1**)

```qml
LiveMetricStrip {
    id: live
    intervalMs: 1200
    running: true
    maxPoints: 16
    compareLag: 8
    periodLabel: qsTr("vs prior window")
    metrics: [
        { key: "cpu", title: qsTr("CPU"), unit: "%",
          cautionThreshold: 75, criticalThreshold: 90 }
    ]
    onTick: live.pushSample("cpu", measuredCpu)
}
```

| API | Role |
|-----|------|
| `pushSample` / `pushSamples` | Update value + ring + compare + auto delta |
| `tick` / `tickOnce` | Throttled poll hook (no per-tile Timer) |
| `compareLag` | Samples back for `compareValue` |

### Ops console (**G2**)

Gallery **Ops console** page demos the strip + threshold event feed. [`examples/dashboard`](../examples/dashboard/) uses **LiveMetricStrip** in `DashboardShell.kpiRow` with a Live refresh checkbox.

Closes **FL-014**. Prefer **MetricCompareRow** only for static period strips.

See [charts.md](charts.md) · [components/LiveMetricStrip.md](components/LiveMetricStrip.md).

---

## 3.06 — Charts wave B (shipped)

### BarChart bins (**G3**)

```qml
BarChart {
    samples: latencyMs   // raw numbers
    binCount: 12
    binLabelPrecision: 0
    showValueLabels: true
}
// or
chart.setBinsFromSamples(samples, 10)
chart.applyBins(ChartUtils.histogramBins(samples, 10))
```

**HistogramChart** stays experimental — product apps use **BarChart** binning. Closes **FL-015** without a new stable chart type.

See [charts.md](charts.md) · [components/BarChart.md](components/BarChart.md).

---

## 3.07 — Vertical app kits (shipped)

| ID | Example | Stack |
|----|---------|-------|
| **V1** | [`examples/admin-settings`](../examples/admin-settings/) | SettingsView · FormLayout · SettingsCard |
| **V2** | [`examples/master-detail-crm`](../examples/master-detail-crm/) | ListDetailsView · DataTable · CommandBar |
| **V3** | [`examples/ops-console`](../examples/ops-console/) | SplitWorkspace · LayoutPreset · LiveMetricStrip · DataTable |

Copy the folder; build `qwinui3_example_admin_settings` / `_master_detail_crm` / `_ops_console`.

---

## 3.08 — Multi-window & panels (shipped)

### WindowMessageBus appearance (**W7**)

```qml
WindowMessageBus.post("appearance", {
    dark: Theme.dark,
    accentPack: Theme.accentPack,
    layoutDirection: WindowHelper.layoutDirection
})
WindowMessageBus.subscribe("appearance", function (p) { /* apply */ })
```

Same process only — see [`examples/multi-window`](../examples/multi-window/).

### PanelFloatHost (**W8**)

```qml
PanelFloatHost {
    title: qsTr("Filters")
    geometryPersistenceKey: "MyAppFilterFloat"
    content: /* pane body Component */
}
```

`floatPane()` / `dockPane()` move one `Component` between host and owned **ToolShellWindow**.

---

## 3.09 — Platform desktop extras (shipped)

| ID | Surface |
|----|---------|
| **P1** | **MenuStatusWindow** — Gallery Window shells · [window-shells.md](window-shells.md) |
| **P2** | **RecentFiles** + `WindowHelper.addToRecentDocuments` |
| **P3** | `WindowHelper.registerFileAssociation` — [file-association.md](file-association.md) |

---

## 3.10 — Checkpoint

[checkpoint-310.md](checkpoint-310.md) green **2026-08-27**.

---

## Related

- [compatibility-3xx.md](compatibility-3xx.md) — stable surface after **3.00**
- [upgrade-notes.md](upgrade-notes.md) — version migration notes
