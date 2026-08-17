import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Performance handbook (1.25) + cold start (1.39). docs/performance.md

CatalogPage {
    id: page
    title: qsTr("Performance")
    subtitle: qsTr("Lists, models, charts, Gallery cold start — docs/performance.md (1.25 / 1.39).")

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
}
