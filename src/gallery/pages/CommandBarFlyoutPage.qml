import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

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
                title: qsTr("CommandBarFlyout")
                subtitle: qsTr("Command flyout with placement, showAt(), and Accessible menu role.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Primary commands")
                qmlSource: "CommandBarFlyout {\n    showAt(btn)\n    AppBarButton { symbol: FluentIcons.Share }\n}"
                Button {
                    id: hostBtn
                    text: qsTr("Show CommandBarFlyout")
                    onClicked: flyout.showAt(hostBtn)

                    CommandBarFlyout {
                        id: flyout
                        parent: hostBtn
                        AppBarButton {
                            symbol: FluentIcons.Share
                            text: qsTr("Share")
                            onClicked: flyout.hide()
                        }
                        AppBarButton {
                            symbol: FluentIcons.Copy
                            text: qsTr("Copy")
                            onClicked: flyout.hide()
                        }
                        AppBarSeparator {}
                        AppBarToggleButton {
                            symbol: FluentIcons.Favorite
                            text: qsTr("Favorite")
                        }
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("With secondary commands")
                qmlSource: "ItemDelegate {\n    parent: flyout.secondaryCommands\n}"

                Button {
                    id: host2
                    text: qsTr("Open flyout")
                    onClicked: flyout2.showAt(host2)

                    CommandBarFlyout {
                        id: flyout2
                        parent: host2

                        AppBarButton {
                            symbol: FluentIcons.Edit
                            text: qsTr("Edit")
                            onClicked: flyout2.hide()
                        }
                        AppBarButton {
                            symbol: FluentIcons.Delete
                            text: qsTr("Delete")
                            onClicked: flyout2.hide()
                        }

                        ItemDelegate {
                            parent: flyout2.secondaryCommands
                            text: qsTr("Move to…")
                            Layout.fillWidth: true
                            onClicked: flyout2.hide()
                        }
                        ItemDelegate {
                            parent: flyout2.secondaryCommands
                            text: qsTr("Rename")
                            Layout.fillWidth: true
                            onClicked: flyout2.hide()
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
