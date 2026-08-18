# Items wrap grid (2.24)

Model-driven **variable-size wrap** for tag clouds, KPI chips, and gallery tiles — WinUI **`ItemsWrapGrid`** pattern without a second layout engine.

Gallery: **ItemsWrapGrid** · **WrapPanel** (static children) · **ItemsRepeater** (virtualized list).

Control: `import QWinUI3.Extras` · [`ItemsWrapGrid.qml`](../src/extras/QWinUI3/Extras/ItemsWrapGrid.qml) (**experimental**).

---

## Choosing a control

| Need | Prefer | Why |
|------|--------|-----|
| Model + delegate, variable widths/heights | **`ItemsWrapGrid`** | WrapPanel + Repeater + optional `filterText` |
| Static QML children, manual layout | **`WrapPanel`** | No model — Repeater is yours to add |
| Long single-column list (1000+ rows) | **`ItemsRepeater`** / **`ItemsView`** | `ListView` + `reuseItems` virtualization |
| Fixed cell grid | **`UniformGrid`** | Equal cell sizes |

**Out of scope (2.24):** virtualizing wrap for million items — keep models in the low hundreds or paginate app-side.

---

## Basic usage

```qml
ItemsWrapGrid {
    id: grid
    width: parent.width
    Layout.preferredHeight: 240
    minItemSize: Theme.controlHeight   // touch floor — honor in delegate
    horizontalSpacing: 8
    verticalSpacing: 8
    model: [
        { title: qsTr("Design") },
        { title: qsTr("Engineering") }
    ]
    delegate: Chip {
        required property int index
        required property var modelData
        text: modelData.title
        implicitHeight: Math.max(implicitHeight, grid.minItemSize)
        onClicked: grid.itemActivated(index, modelData)
    }
}
```

| API | Role |
|-----|------|
| `model` / `delegate` | Same contract as **ItemsRepeater** (`index`, `modelData`) |
| `filterText` | Debounced filter on plain JS arrays (roles via `filterRoles`) |
| `itemSpacing` / `horizontalSpacing` / `verticalSpacing` | Forwarded to inner **WrapPanel** |
| `orientation` / `layoutDirection` | Horizontal wrap (default) or vertical flow |
| `itemWidth` / `itemHeight` | Optional uniform cell size (`-1` = natural) |
| `minItemSize` | Documented touch floor — default **`Theme.controlHeight`** |
| `itemActivated` / `itemClicked` | Row activation from delegates |

Content scrolls vertically inside the control when wrapped rows exceed height.

---

## Touch & density

Follow [touch-pointer.md](touch-pointer.md): primary targets ≥ **`Theme.controlHeight`**. Set `minItemSize` and enforce in delegates:

```qml
implicitHeight: Math.max(implicitHeight, grid.minItemSize)
implicitWidth: Math.max(implicitWidth, grid.minItemSize)   // icon-only tiles
```

Prefer **`Theme.density: "standard"`** on finger-first shells.

---

## Performance

| Size | Guidance |
|------|----------|
| **≤ ~200** plain objects | Default — filter debounces like **ItemsRepeater** (1.88) |
| **Thousands+** | Not virtualized — paginate, lazy-load pages, or use **ItemsRepeater** list |

See [performance.md](performance.md) for list virtualization patterns.

---

## Accessibility (2.29)

| API | Note |
|-----|------|
| `accessibleName` | Override when multiple wrap grids share a page |
| `announceChanges` | Live region for filter match count (Qt 6.8+ `Accessible.announce`) |
| Delegates | Set `Accessible.name` on each chip/button — the host only names the list |

Gallery **Accessibility** wave 5 sample · [accessibility.md](accessibility.md) wave 5 checklist.
