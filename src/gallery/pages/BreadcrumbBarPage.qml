import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — BreadcrumbBar.
//
// Fluent separators, symbol crumbs, overflow ellipsis, and Accessible path. API: docs/components/BreadcrumbBar.md

CatalogPage {
    title: qsTr("BreadcrumbBar")
    subtitle: qsTr("Fluent separators, symbol crumbs, overflow ellipsis, and Accessible path.")

    ControlExample {
        headerText: qsTr("Path")
        qmlSource: "BreadcrumbBar {\n    model: [{ title, symbol: FluentIcons.Home }]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox {
                id: lastClickable
                text: qsTr("Last item clickable")
            }
            BreadcrumbBar {
                id: crumbs
                Layout.fillWidth: true
                maxItems: 4
                lastItemClickable: lastClickable.checked
                model: [
                    { title: qsTr("Home"), symbol: FluentIcons.Home },
                    { title: qsTr("Library"), symbol: FluentIcons.Folder },
                    qsTr("Documents"),
                    qsTr("Projects"),
                    qsTr("2026"),
                    qsTr("Reports")
                ]
                onItemInvoked: function (index) {
                    crumbs.model = crumbs.model.slice(0, index + 1)
                }
            }
            Label {
                text: {
                    var it = crumbs.selectedItem
                    var title = (it && it.title) ? it.title : String(it || "—")
                    return qsTr("Index %1 · selectedItem: %2 — long paths collapse with …")
                        .arg(crumbs.currentIndex).arg(title)
                }
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }
}
