import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TreeView recipe (expand + context menu).
//
// Fluent TreeViewDelegate rows with a right-click MenuFlyout.

CatalogPage {
    id: page

    title: qsTr("TreeView recipe")
    subtitle: qsTr("Styled hierarchy with context MenuFlyout — pair with a real tree model in apps.")

    property int contextRow: -1

    overlay: ToastHost {
        id: toasts
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        width: 360
    }

    ControlExample {
        headerText: qsTr("Folders")
        qmlSource: "TreeView {\n    delegate: TreeViewDelegate { }\n}\nMenuFlyout { … }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Repeater {
                id: rows
                model: [
                    { title: qsTr("Documents"), depth: 0, expanded: true },
                    { title: qsTr("Projects"), depth: 1, expanded: true },
                    { title: qsTr("QWinUI3"), depth: 2, expanded: false },
                    { title: qsTr("Pictures"), depth: 1, expanded: false },
                    { title: qsTr("Downloads"), depth: 0, expanded: false }
                ]
                ItemDelegate {
                    id: row
                    required property var modelData
                    required property int index
                    Layout.fillWidth: true
                    leftPadding: 12 + modelData.depth * 16
                    highlighted: page.contextRow === index
                    contentItem: RowLayout {
                        spacing: 6
                        FontIcon {
                            symbol: modelData.expanded ? FluentIcons.ChevronUp : FluentIcons.ChevronRight
                            fontSize: 12
                            iconColor: Theme.textSecondary
                        }
                        Label {
                            text: modelData.title
                            color: Theme.textPrimary
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }

                    TapHandler {
                        acceptedButtons: Qt.RightButton
                        onTapped: {
                            page.contextRow = index
                            treeMenu.showAt(row, 0, row.height)
                        }
                    }
                    onPressAndHold: {
                        page.contextRow = index
                        treeMenu.showAt(row, 0, row.height)
                    }
                }
            }

            MenuFlyout {
                id: treeMenu
                MenuFlyoutItem {
                    text: qsTr("Expand")
                    onTriggered: toasts.info(qsTr("Expand row %1").arg(page.contextRow), qsTr("Tree"))
                }
                MenuFlyoutItem {
                    text: qsTr("Rename")
                    onTriggered: toasts.info(qsTr("Rename row %1").arg(page.contextRow), qsTr("Tree"))
                }
                MenuFlyoutSeparator {}
                MenuFlyoutItem {
                    text: qsTr("Delete")
                    onTriggered: toasts.warningToast(qsTr("Delete row %1").arg(page.contextRow), qsTr("Tree"))
                }
            }
        }
    }
}
