import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — BreadcrumbBar.
//
// Fluent separators, symbol crumbs, overflow ellipsis, and Accessible path. API: docs/components/BreadcrumbBar.md

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("BreadcrumbBar")
                subtitle: qsTr("Fluent separators, symbol crumbs, overflow ellipsis, and Accessible path.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
