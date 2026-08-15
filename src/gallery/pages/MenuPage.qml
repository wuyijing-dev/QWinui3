import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

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
                title: qsTr("Menu")
                subtitle: qsTr("Displays a list of commands or options in a MenuBar or as a context menu.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("MenuBar")
                qmlSource: "MenuBar {\n    Menu {\n        title: \"File\"\n        Action { text: \"New\" }\n        Action { text: \"Open\" }\n    }\n}"

                MenuBar {
                    Layout.fillWidth: true
                    Menu {
                        title: qsTr("File")
                        Action { text: qsTr("New") }
                        Action { text: qsTr("Open") }
                        MenuSeparator {}
                        Action { text: qsTr("Exit") }
                    }
                    Menu {
                        title: qsTr("Edit")
                        Action { text: qsTr("Cut") }
                        Action { text: qsTr("Copy") }
                        Action { text: qsTr("Paste") }
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Context menu")
                qmlSource: "Button {\n    text: \"Context menu\"\n    onClicked: contextMenu.popup()\n    Menu {\n        id: contextMenu\n        Action { text: \"Refresh\" }\n        Action { text: \"Share\" }\n    }\n}"

                Button {
                    text: qsTr("Context menu")
                    onClicked: contextMenu.popup()
                    Menu {
                        id: contextMenu
                        Action { text: qsTr("Refresh") }
                        Action { text: qsTr("Share") }
                        MenuSeparator {}
                        Action { text: qsTr("Delete") }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
