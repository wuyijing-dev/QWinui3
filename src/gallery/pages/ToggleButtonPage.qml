import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ToggleButton.

CatalogPage {
    title: qsTr("ToggleButton")
    subtitle: qsTr("Checkable accent toggle with optional symbol: FluentIcons.*.")

    ControlExample {
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
}
