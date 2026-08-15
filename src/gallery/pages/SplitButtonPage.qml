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
                title: qsTr("SplitButton")
                subtitle: qsTr("Primary action plus flyout. Supports showMenu() and flyoutPlacement.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Save options")
                qmlSource: "SplitButton {\n    text: \"Save\"\n    highlighted: true\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    RowLayout {
                        spacing: Theme.spacingLoose
                        SplitButton {
                            text: qsTr("Save")
                            onPrimaryClicked: status.text = qsTr("Saved")
                            MenuItem {
                                text: qsTr("Save")
                                onTriggered: status.text = qsTr("Saved")
                            }
                            MenuItem {
                                text: qsTr("Save as…")
                                onTriggered: status.text = qsTr("Save as…")
                            }
                            MenuItem {
                                text: qsTr("Save a copy")
                                onTriggered: status.text = qsTr("Copy saved")
                            }
                        }
                        SplitButton {
                            text: qsTr("Publish")
                            highlighted: true
                            onPrimaryClicked: status.text = qsTr("Published")
                            MenuItem { text: qsTr("Publish now"); onTriggered: status.text = qsTr("Published") }
                            MenuItem { text: qsTr("Schedule…"); onTriggered: status.text = qsTr("Scheduled") }
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
