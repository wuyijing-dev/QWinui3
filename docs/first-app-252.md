# First app in an hour (2.52)

**FL-003** adoption slice — minimal quickstart smaller than `gallery-shell`. Introduces preview **`DashboardShell`** (full grid + filter rail in **2.65**).

Related: [packaging-consumer.md](packaging-consumer.md) · [stable-clarity-251.md](stable-clarity-251.md) · [examples/first-app/](../examples/first-app/) · [planning/friction-log.md](planning/friction-log.md)

---

## Goal

New teams stall on **import paths**, **shell choice**, and **Theme bootstrap**. **2.52** ships a one-hour path: configure Release → build `qwinui3_example_first_app` → copy `examples/first-app/`.

**Outcome:** shell ladder doc + smallest example + experimental **`DashboardShell`** layout host.

---

## Deliverables

| Item | Location |
|------|----------|
| Quickstart example | [`examples/first-app/`](../examples/first-app/) — `NavigationWindow` + `HomePage` |
| Layout host (preview) | **`DashboardShell`** — `QWinUI3.Extras` (experimental until **2.65**) |
| Shell ladder | This doc + Gallery **Pitfalls** **2.52** block |
| Path picker bump | [packaging-consumer.md](packaging-consumer.md) — **first-app** row |
| Lint | `python scripts/lint_qml_imports.py` after editing copied QML |

**Out:** Full **`find_package`** productize (**2.02**); **`DashboardShell`** chart grid (**2.65**); video assets (script checklist only).

---

## Shell ladder (pick one)

| Step | Folder | When |
|------|--------|------|
| **1 — first hour** | [`first-app/`](../examples/first-app/) | Bootstrap + one nav page + `DashboardShell` KPI row |
| **2 — product chrome** | [`gallery-shell/`](../examples/gallery-shell/) | Settings footer + `ThemeAppearanceSettings` + persistence |
| **3 — ops dashboard** | [`dashboard/`](../examples/dashboard/) | Stable six charts — [charts.md](charts.md) |
| **4 — packaged consumer** | [`find-package-consumer/`](../examples/find-package-consumer/) | Path C / vcpkg / Conan — not monorepo copy |

Hand-wired alternative: [`nav-settings/`](../examples/nav-settings/) (`StandardWindow` + `NavigationView`).

---

## Hour checklist (~60 min)

### 0–15 min — toolchain

- [ ] Clone repo; open **repo root** in Qt Creator — [qt-creator.md](qt-creator.md)
- [ ] Release configure: `cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release`
- [ ] Build Gallery once (validates kit): `cmake --build build --target qwinui3_gallery`

### 15–35 min — first app

- [ ] Build: `cmake --build build --target qwinui3_example_first_app`
- [ ] Run: `build/qwinui3_example_first_app` (Win) or `./build/qwinui3_example_first_app`
- [ ] Read `examples/first-app/README.md` keep vs replace table

### 35–50 min — copy path

- [ ] Duplicate `examples/first-app/` into your product tree
- [ ] Rename QML module URI + CMake target
- [ ] Set `geometryPersistenceKey` to your app id
- [ ] Pick packaging path — [packaging-consumer.md](packaging-consumer.md) **Path picker**

### 50–60 min — guardrails

- [ ] Stable imports only — [stable-api.md](stable-api.md)
- [ ] `python scripts/lint_qml_imports.py`
- [ ] Retail builds: `FrameStatsMonitor.applyRetailProfile()` — [developer-diagnostics.md](developer-diagnostics.md)

---

## DashboardShell (2.52 preview)

Minimal column layout: optional **title** / **subtitle**, **`kpiRow`** slot, default **content** (cards/charts).

```qml
DashboardShell {
    title: qsTr("Ops")
    kpiRow: RowLayout {
        KpiTile { title: qsTr("Users"); value: 42 }
    }
    ContentCard { title: qsTr("Details") }
}
```

**2.65** adds responsive chart grid + **TwoPaneView** filter rail — [planning/expansion/charts-dashboard-arc.md](planning/expansion/charts-dashboard-arc.md).

Treat as **experimental** until promote wave — not in stable-api **Stable** table.

---

## App checklist

- [ ] Started from **`first-app`**, not Gallery source tree
- [ ] `QWinUI3::configureEnvironment` + `configureApplication` in `main.cpp`
- [ ] `backdrop: WindowHelper.BackdropSolid` on Win + Linux
- [ ] Graduate to **`gallery-shell`** when Settings / theme prefs needed
- [ ] Graduate to **`dashboard`** when shipping stable six charts

**Next:** **2.53** Linux top-3 parity · **2.65** **DashboardShell** product wave
