# SemanticZoom (2.62)

Experimental **dual-view host** for contacts / album surfaces — grid ↔ letter index with **shared selection** — closes **FL-006** without two hand-synced `ItemsView`s.

Related: [data-collections.md](data-collections.md) · [accessibility.md](accessibility.md) · [planning/friction-log.md](planning/friction-log.md) (**FL-006**) · Gallery **SemanticZoom** page.

Control: `import QWinUI3.Extras` · [`SemanticZoom.qml`](../src/extras/QWinUI3/Extras/SemanticZoom.qml) (**experimental**).

---

## Choosing

| Need | Prefer |
|------|--------|
| Single list with sections | **`ItemsView`** + `sectionRole` |
| Variable-size wrap grid | **`ItemsWrapGrid`** |
| Thumbnail grid **and** zoomed-out index sharing selection | **`SemanticZoom`** |
| Map / graph / pinch zoom | App-owned surface — **out of scope** |

**Out of scope (2.62):** pinch gestures, map tiles, unrelated layout zoom.

---

## Contacts recipe

```qml
SemanticZoom {
    id: contactsZoom
    Layout.fillWidth: true
    Layout.preferredHeight: 320
    model: contacts
    groupRole: "letter"
    selectedIndex: 0

    GridView {
        anchors.fill: parent
        model: contactsZoom.model
        cellWidth: 112
        cellHeight: 108
        delegate: GridTile {
            title: modelData.name
            checked: contactsZoom.selectedIndex === index
            onClicked: contactsZoom.selectIndex(index)
        }
    }

    zoomedOut: GridView {
        anchors.fill: parent
        model: contactsZoom.groupKeys
        cellWidth: 52
        cellHeight: 52
        delegate: RoundButton {
            text: modelData
            onClicked: contactsZoom.selectGroup(modelData)
        }
    }
}
```

Gallery: **SemanticZoom** page mirrors this layout.

---

## API

| Member | Note |
|--------|------|
| `model` | Shared source for both views |
| `groupRole` | Role / property for index groups (e.g. `"letter"`) |
| `selectedIndex` | Current row in `model` |
| `selectedGroup` | Last activated group key |
| `isZoomedOut` | `true` when index view visible |
| `groupKeys` | Sorted unique group values from `model` |
| `toggleZoom()` / `zoomIn()` / `zoomOut()` | Switch views |
| `selectIndex(i)` | Select row + emit `selectionChanged` |
| `selectGroup(key)` | Jump to first row in group, zoom in |
| `indexForGroup(key)` | Lookup helper |
| `zoomedIn` (default children) | Detail / grid host |
| `zoomedOut` | Index host alias |

**Signals:** `zoomChanged(bool zoomedOut)` · `selectionChanged(int index, var item)` · `groupActivated(string group)`

---

## Keyboard

| Shortcut | Action |
|----------|--------|
| **Ctrl+-** | Zoom out (index) |
| **Ctrl++** / **Ctrl+=** | Zoom in (detail) |

Focus must be on the **`SemanticZoom`** control (or use the header zoom button when `showZoomButton: true`).

---

## App checklist

- [ ] Mark **`SemanticZoom`** experimental in product docs until promote gate
- [ ] One **`model`** — do not duplicate arrays for grid vs index
- [ ] Wire **`selectGroup`** on index cells; **`selectIndex`** on grid tiles
- [ ] Prefer **`groupKeys`** for the zoomed-out view — not a hand-maintained A–Z list
- [ ] Not for map/graph zoom — use app-owned canvas if needed

**Next:** **2.64** collection perf sign-off (**FL-008** residual)
