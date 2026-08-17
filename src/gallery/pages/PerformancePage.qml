import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Performance handbook (1.25) + cold start (1.39). docs/performance.md

CatalogPage {
    id: page
    title: qsTr("Performance")
    subtitle: qsTr("Lists, shell trim, tranche-1 sign-off, app flows (2.59) — docs/performance.md")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Handbook (1.25)")
        qmlSource: "// Virtualize lists · lean roles · chart point budgets\n// docs/performance.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Prefer virtualized views (DataTable / ItemsView / ListView with reuseItems). Keep model roles lean. Cap chart points for live series. Avoid MultiEffect on first paint of heavy pages — Gallery Home defers card shadows (1.39).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("ItemsRepeater enables ListView.reuseItems by default. Heavy demos: DataTable, Charts hub.")
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
        headerText: qsTr("Gallery cold start (1.39)")
        qmlSource: "NavigationView.pageCacheLimit\n--startup-log · Settings page-cache card"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("NavigationView keeps an LRU page cache (pageCacheLimit / clearPageCache). initialPageTransition defaults to none for a snappy first paint. Use Settings → page cache controls, or CLI --startup-log with --smoke for timing.")
                font.family: Theme.fontFamily
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
        headerText: qsTr("Shell & navigation wave 6 (2.28)")
        qmlSource: "NavigationView.sameKeySkipCount\nNavigationWindow.pageCacheLimit"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Real-app checklist: lazy pageModule pages, tune pageCacheLimit, rely on same-key / same-page skips (sameKeySkipCount / samePageSkipCount), initialPageTransition none for cold start, defer heavy Loader siblings. NavigationWindow forwards cache + skip counters.")
                font.family: Theme.fontFamily
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
        headerText: qsTr("Collection controls wave 7 (2.40)")
        qmlSource: "DataTable.filterDebounceMs · ListDetailsView.filteredCount\nTreeDataGrid.maxFilterResults · NavigationView paneSearch debounce"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Second collection pass: debounced filter on DataTable / ListDetailsView / TreeDataGrid; skip unchanged rebuilds; cap maxFilterResults on huge JS arrays; debounce NavigationView paneSearchTextEdited in your app. FileTree table side inherits DataTable knobs — filter treeModel app-side. docs/performance.md wave 7.")
                font.family: Theme.fontFamily
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
                text: qsTr("Pair with wave 6 shell trim (page cache + skip counters) on real app checklists — not micro-benchmarks.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Developer diagnostics — dev vs retail (2.44)")
        qmlSource: "FrameStatsMonitor.applyRetailProfile()\nFrameStatsBadge { } // dev builds only"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("FrameStatsMonitor is opt-in (enabled default false). Gallery uses the dev profile — Settings toggles persist. Shipping apps call applyRetailProfile() in main before QML loads so FPS/RHI never stick from QSettings. CLI --show-diagnostics for internal QA only. Recipe: docs/developer-diagnostics.md.")
                font.family: Theme.fontFamily
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
        headerText: qsTr("Charts & dashboard wave 8 (2.49)")
        qmlSource: "KpiTile.trendValues capped\nItemsWrapGrid.filterDebounceMs\n// docs/perf-signoff-2xx.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Tranche-1 perf sign-off: cap chart points (~500/series), KPI trend rings (~16 samples), one chart per ChartCard. ItemsWrapGrid debounces filter (120 ms) — low hundreds of tiles only. Pair with wave 6 shell cache + wave 7 table debounce. Animations stay.")
                font.family: Theme.fontFamily
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
                text: qsTr("Full sign-off: docs/perf-signoff-2xx.md · FL-008 partial — 2.64 if field metrics return.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("App-level flows wave 9 (2.59)")
        qmlSource: "CommandPalette.maxRecentCommands\nAutoSuggestBox.minFilterLength\nButton.loading"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Named slow paths: palette/search debounce + caps; Button.loading for async save; FlipView swipe off when Theme.reducedMotion. docs/app-sluggishness-259.md")
                font.family: Theme.fontFamily
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
            CheckBox { text: qsTr("CommandPalette: maxRecentCommands pins hot commands when query empty") }
            CheckBox { text: qsTr("ItemsView / AutoSuggest: minFilterLength 2 on 1000+ JS rows") }
            CheckBox { text: qsTr("Button.loading + enabled: !busy blocks double-submit") }
        }
    }
}
