import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Performance handbook + cold start. docs/performance.md

CatalogPage {
    id: page
    title: qsTr("Performance")
    subtitle: qsTr("Lists, shell trim, tranche-1 sign-off, app + collection flows — docs/performance.md")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Handbook")
        qmlSource: "// Virtualize lists · lean roles · chart point budgets\n// docs/performance.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Prefer virtualized views (DataTable / ItemsView / ListView with reuseItems). Pair with a mild cacheBuffer — see docs/performance.md. Keep model roles lean. Cap chart points for live series. Avoid MultiEffect on first paint of heavy pages — Gallery Home defers card shadows.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("ItemsRepeater / ItemsView / NavigationView pane enable reuseItems + cacheBuffer by default. Heavy demos: DataTable, Charts hub.")
            }
            RowLayout {
                Button {
                    text: qsTr("Open DataTable")
                    onClicked: page.openComp("DataTablePage")
                }
                Button {
                    text: qsTr("Open Charts")
                    onClicked: page.openComp("ChartsPage")
                }
                Button {
                    text: qsTr("Open ItemsRepeater")
                    onClicked: page.openComp("ItemsRepeaterPage")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Gallery cold start")
        qmlSource: "NavigationView.pageCacheLimit\n--startup-log · Settings page-cache card"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("NavigationView keeps an LRU of compiled page Components (Gallery: pageCacheLimit 8 + Home/Settings pinned — 3.46). StackView.replace already destroys off-screen page trees. Bootstrap caps QPixmapCache (16 MB, QWINUI3_PIXMAP_CACHE_KB); ElevatedChrome frees shadow layers when hidden (3.47). Use Settings → Clear cache, or CLI --startup-log with --smoke for timing.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "qwinui3_gallery.exe --smoke --startup-log"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "qwinui3_gallery.exe --smoke --startup-log"
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Open Settings (footer) for live page-cache / density / RHI knobs.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Shell &")
        qmlSource: "NavigationView.sameKeySkipCount\nNavigationWindow.pageCacheLimit"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Real-app checklist: lazy pageModule pages, tune pageCacheLimit, rely on same-key / same-page skips (sameKeySkipCount / samePageSkipCount), initialPageTransition none for cold start, defer heavy Loader siblings. NavigationWindow forwards cache + skip counters.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Button {
                    text: qsTr("Open NavigationView")
                    onClicked: page.openComp("NavigationViewPage")
                }
                Button {
                    text: qsTr("Open Settings")
                    onClicked: page.openComp("SettingsPage")
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Advisory smoke: --smoke --startup-log prints main/pages/total ms — compare on the same Release machine only; not a CI millisecond gate.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Collection")
        qmlSource: "DataTable.filterDebounceMs · ListDetailsView.filteredCount\nTreeDataGrid.maxFilterResults · NavigationView paneSearch debounce"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Second collection pass: debounced filter on DataTable / ListDetailsView / TreeDataGrid; skip unchanged rebuilds; cap maxFilterResults on huge JS arrays; debounce NavigationView paneSearchTextEdited in your app. FileTree table side inherits DataTable knobs — filter treeModel app-side. docs/performance..")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("DataTable")
                    onClicked: page.openComp("DataTablePage")
                }
                Button {
                    text: qsTr("ListDetailsView")
                    onClicked: page.openComp("ListDetailsViewPage")
                }
                Button {
                    text: qsTr("NavigationView")
                    onClicked: page.openComp("NavigationViewPage")
                }
                Button {
                    text: qsTr("FileTree")
                    onClicked: page.openComp("FileTreePage")
                }
                Button {
                    text: qsTr("TreeDataGrid")
                    onClicked: page.openComp("TreeDataGridPage")
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Pair shell trim (page cache + skip counters) on real app checklists — not micro-benchmarks.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Developer diagnostics — dev vs retail")
        qmlSource: "FrameStatsMonitor.applyRetailProfile()\nFrameStatsBadge { } // dev builds only"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("FrameStatsMonitor is opt-in (enabled default false). Gallery uses the dev profile — Settings toggles persist. Shipping apps call applyRetailProfile() in main before QML loads so FPS/RHI never stick from QSettings. CLI --show-diagnostics for internal QA only. Recipe: docs/developer-diagnostics.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Open Settings (FPS)")
                    onClicked: page.openComp("SettingsPage")
                }
                Button {
                    text: qsTr("Graphics backend")
                    onClicked: page.openComp("GraphicsBackendPage")
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Retail checklist: no FrameStatsBadge in title bar · applyRetailProfile() in Release main · --retail-diagnostics for smoke.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Charts &")
        qmlSource: "KpiTile.trendValues capped\nItemsWrapGrid.filterDebounceMs\n// docs/perf-signoff-2xx.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Tranche-1 perf sign-off: cap chart points (~500/series), KPI trend rings (~16 samples), one chart per ChartCard. ItemsWrapGrid debounces filter (120 ms) — low hundreds of tiles only. Pair shell cache + table debounce. Animations stay.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Dashboard")
                    onClicked: page.openComp("DashboardPage")
                }
                Button {
                    text: qsTr("Charts")
                    onClicked: page.openComp("ChartsPage")
                }
                Button {
                    text: qsTr("ItemsWrapGrid")
                    onClicked: page.openComp("ItemsWrapGridPage")
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Full sign-off: docs/perf-signoff-2xx.md · FL-008 closed documented paths — docs/collection-perf-264.md.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("App-level")
        qmlSource: "CommandPalette.maxRecentCommands\nAutoSuggestBox.minFilterLength\nButton.loading"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Named slow paths: palette/search debounce + caps; Button.loading for async save; FlipView swipe off when Theme.reducedMotion. docs/app-sluggishness-259.md")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Command palette")
                    onClicked: page.openComp("CommandPalettePage")
                }
                Button {
                    text: qsTr("AutoSuggestBox")
                    onClicked: page.openComp("AutoSuggestBoxPage")
                }
                Button {
                    text: qsTr("FlipView")
                    onClicked: page.openComp("FlipViewPage")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("")
        qmlSource: "DataTable { groupRole; columns: [{ pinned: true }] }\nListDetailsView { multiSelectEnabled; detailToolbar }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Ops tables: pin identity columns, groupRole section headers, persist columnOrder. Mail master: multiSelectEnabled + detailToolbar instead of a second ItemsView. TreeDataGrid freezeFirstColumn; FileTree filterText + column chooser. docs/collection-perf-264.md")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("DataTable")
                    onClicked: page.openComp("DataTablePage")
                }
                Button {
                    text: qsTr("ListDetailsView")
                    onClicked: page.openComp("ListDetailsViewPage")
                }
                Button {
                    text: qsTr("FileTree")
                    onClicked: page.openComp("FileTreePage")
                }
            }
        }
    }
}
