import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — MenuBar.
//
// A horizontal bar of cascading menus for an application window. API: docs/components/MenuBar.md

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
                title: qsTr("MenuBar")
                subtitle: qsTr("A horizontal bar of cascading menus for an application window.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Standard menus")
                qmlSource: "MenuBar {\n    Menu { title: \"File\" ... }\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    MenuBar {
                        Layout.fillWidth: true
                        Menu {
                            title: qsTr("File")
                            Action { text: qsTr("New"); onTriggered: status.text = qsTr("New") }
                            Action { text: qsTr("Open…"); onTriggered: status.text = qsTr("Open") }
                            MenuSeparator {}
                            Action { text: qsTr("Exit"); onTriggered: status.text = qsTr("Exit") }
                        }
                        Menu {
                            title: qsTr("Edit")
                            Action { text: qsTr("Cut"); onTriggered: status.text = qsTr("Cut") }
                            Action { text: qsTr("Copy"); onTriggered: status.text = qsTr("Copy") }
                            Action { text: qsTr("Paste"); onTriggered: status.text = qsTr("Paste") }
                        }
                        Menu {
                            title: qsTr("Help")
                            Action { text: qsTr("About"); onTriggered: status.text = qsTr("About") }
                        }
                    }
                    Label {
                        id: status
                        text: qsTr("Ready")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
