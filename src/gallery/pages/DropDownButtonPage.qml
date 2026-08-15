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
                title: qsTr("DropDownButton")
                subtitle: qsTr("Opens a menu. Supports highlighted styling and flyoutPlacement.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("With MenuItem children")
                qmlSource: "DropDownButton {\n    text: \"Options\"\n    highlighted: true\n}"

                RowLayout {
                    spacing: Theme.spacingLoose
                    DropDownButton {
                        text: qsTr("Options")
                        MenuItem { text: qsTr("Copy") }
                        MenuItem { text: qsTr("Paste") }
                        MenuItem { text: qsTr("Delete") }
                    }
                    DropDownButton {
                        text: qsTr("Accent")
                        highlighted: true
                        MenuItem { text: qsTr("New") }
                        MenuItem { text: qsTr("Open") }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
