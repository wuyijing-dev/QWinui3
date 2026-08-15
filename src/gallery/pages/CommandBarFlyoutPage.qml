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
                subtitle: qsTr("A flyout that hosts a compact command bar, with optional secondary actions.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Primary commands")
                qmlSource: "CommandBarFlyout {\n    AppBarButton { text: \"Share\" }\n}"
                Button {
                    id: hostBtn
                    text: qsTr("Show CommandBarFlyout")
                    onClicked: flyout.open()

                    CommandBarFlyout {
                        id: flyout
                        parent: hostBtn
                        AppBarButton {
                            iconGlyph: "\uE72D"
                            text: qsTr("Share")
                            onClicked: flyout.close()
                        }
                        AppBarButton {
                            iconGlyph: "\uE8C8"
                            text: qsTr("Copy")
                            onClicked: flyout.close()
                        }
                        AppBarSeparator {}
                        AppBarToggleButton {
                            iconGlyph: "\uE734"
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
                    onClicked: flyout2.open()

                    CommandBarFlyout {
                        id: flyout2
                        parent: host2

                        AppBarButton {
                            iconGlyph: "\uE70F"
                            text: qsTr("Edit")
                            onClicked: flyout2.close()
                        }
                        AppBarButton {
                            iconGlyph: "\uE74D"
                            text: qsTr("Delete")
                            onClicked: flyout2.close()
                        }

                        ItemDelegate {
                            parent: flyout2.secondaryCommands
                            text: qsTr("Move to…")
                            Layout.fillWidth: true
                            onClicked: flyout2.close()
                        }
                        ItemDelegate {
                            parent: flyout2.secondaryCommands
                            text: qsTr("Rename")
                            Layout.fillWidth: true
                            onClicked: flyout2.close()
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
