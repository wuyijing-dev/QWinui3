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
                title: qsTr("ToggleSplitButton")
                subtitle: qsTr("Checkable primary action with flyout. Supports iconGlyph, isOpen, and flyoutPlacement.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("List style")
                qmlSource: "ToggleSplitButton {\n    text: \"List\"\n    icon: FluentIcons.List\n    checked: true\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    ToggleSplitButton {
                        id: listToggle
                        text: qsTr("List")
                        icon: FluentIcons.List
                        checked: true
                        onPrimaryClicked: status.text = checked ? qsTr("List on") : qsTr("List off")
                        MenuItem {
                            text: qsTr("List")
                            onTriggered: status.text = qsTr("List mode")
                        }
                        MenuItem {
                            text: qsTr("Grid")
                            onTriggered: status.text = qsTr("Grid mode")
                        }
                        MenuItem {
                            text: qsTr("Tiles")
                            onTriggered: status.text = qsTr("Tiles mode")
                        }
                    }
                    Label {
                        id: status
                        text: qsTr("Ready — menu open: %1").arg(listToggle.isOpen ? qsTr("yes") : qsTr("no"))
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
