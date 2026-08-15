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
                title: qsTr("TabBar")
                subtitle: qsTr("Presents a set of tabs that can be used to navigate between views.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple TabBar")
                qmlSource: "TabBar {\n    TabButton { text: \"Home\" }\n    TabButton { text: \"Documents\" }\n    TabButton { text: \"Settings\" }\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    TabBar {
                        id: tabs
                        Layout.fillWidth: true
                        TabButton { text: qsTr("Home") }
                        TabButton { text: qsTr("Documents") }
                        TabButton { text: qsTr("Settings") }
                    }

                    StackLayout {
                        Layout.fillWidth: true
                        currentIndex: tabs.currentIndex
                        Label { text: qsTr("Home page"); color: Theme.textPrimary; padding: 12 }
                        Label { text: qsTr("Documents page"); color: Theme.textPrimary; padding: 12 }
                        Label { text: qsTr("Settings page"); color: Theme.textPrimary; padding: 12 }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
