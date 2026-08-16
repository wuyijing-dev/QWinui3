import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ToggleButton.
//
// Checkable accent toggle with optional symbol: FluentIcons.*. API: docs/components/ToggleButton.md

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
                title: qsTr("ToggleButton")
                subtitle: qsTr("Checkable accent toggle with optional symbol: FluentIcons.*.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Toggle")
                qmlSource: "ToggleButton {\n    text: \"Bold\"\n    symbol: FluentIcons.Edit\n    checked: true\n}"
                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    ToggleButton { text: qsTr("Bold"); checked: true }
                    ToggleButton { text: qsTr("Italic") }
                    ToggleButton {
                        text: qsTr("Mail")
                        symbol: FluentIcons.Mail
                        checked: true
                    }
                    ToggleButton {
                        symbol: FluentIcons.Flag
                        ToolTip.text: qsTr("Flag")
                    }
                    ToggleButton { text: qsTr("Disabled"); enabled: false; checked: true }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("IsThreeState")
                qmlSource: "ToggleButton {\n    isThreeState: true\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    ToggleButton {
                        id: triToggle
                        text: qsTr("Three-state")
                        symbol: FluentIcons.Checkmark
                        isThreeState: true
                    }
                    Label {
                        text: {
                            switch (triToggle.checkState) {
                            case Qt.Checked: return qsTr("State: Checked")
                            case Qt.PartiallyChecked: return qsTr("State: PartiallyChecked")
                            default: return qsTr("State: Unchecked")
                            }
                        }
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
