import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TreeView recipe (expand + context menu).
//
// Fluent TreeViewDelegate rows with a right-click MenuFlyout.

Page {
    id: page
    padding: 0

    property int contextRow: -1

    ToastHost {
        id: toasts
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        width: 360
        z: 10
    }

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
                title: qsTr("TreeView recipe")
                subtitle: qsTr("Styled hierarchy with context MenuFlyout — pair with a real tree model in apps.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
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
                            text: (modelData.expanded ? "\uE70E " : "\uE76C ") + modelData.title
                            font.family: Theme.fontFamily
                            highlighted: page.contextRow === index

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
    }
}
