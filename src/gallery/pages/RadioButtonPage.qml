import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — RadioButton (WinUI groups + description).

CatalogPage {
    title: qsTr("RadioButton")
    subtitle: qsTr("Grouped options with description — docs/components/RadioButton.md")

    ControlExample {
        headerText: qsTr("A group of RadioButtons")
        qmlSource: "ButtonGroup { id: group }\nRadioButton {\n    text: \"Option A\"\n    checked: true\n    ButtonGroup.group: group\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use ButtonGroup so only one option is selected. For model-driven groups with a header, see RadioButtons.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            ButtonGroup { id: group }
            RadioButton { text: qsTr("Option A"); checked: true; ButtonGroup.group: group }
            RadioButton { text: qsTr("Option B"); ButtonGroup.group: group }
            RadioButton { text: qsTr("Option C"); ButtonGroup.group: group }
            RadioButton { text: qsTr("Disabled"); enabled: false }
            RadioButton { text: qsTr("Disabled selected"); checked: true; enabled: false }
        }
    }

    ControlExample {
        headerText: qsTr("RadioButtons with descriptions")
        qmlSource: "RadioButton {\n    text: \"Balanced\"\n    description: \"Good default for most PCs.\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Label {
                text: qsTr("Power mode")
                font.weight: Theme.fontWeightSemiBold
            }
            ButtonGroup { id: powerGroup }
            RadioButton {
                Layout.fillWidth: true
                text: qsTr("Best performance")
                description: qsTr("Higher fan speed and energy use when needed.")
                ButtonGroup.group: powerGroup
            }
            RadioButton {
                Layout.fillWidth: true
                text: qsTr("Balanced")
                description: qsTr("Good default for most PCs.")
                checked: true
                ButtonGroup.group: powerGroup
            }
            RadioButton {
                Layout.fillWidth: true
                text: qsTr("Best power efficiency")
                description: qsTr("Extends battery life; may limit peak performance.")
                ButtonGroup.group: powerGroup
            }
        }
    }

    ControlExample {
        headerText: qsTr("Two independent groups")
        qmlSource: "// Each ButtonGroup is exclusive within itself"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ColumnLayout {
                spacing: Theme.spacing
                Label { text: qsTr("Day"); font.weight: Theme.fontWeightSemiBold }
                ButtonGroup { id: dayGroup }
                RadioButton { text: qsTr("Mon"); checked: true; ButtonGroup.group: dayGroup }
                RadioButton { text: qsTr("Tue"); ButtonGroup.group: dayGroup }
                RadioButton { text: qsTr("Wed"); ButtonGroup.group: dayGroup }
            }
            ColumnLayout {
                spacing: Theme.spacing
                Label { text: qsTr("Time"); font.weight: Theme.fontWeightSemiBold }
                ButtonGroup { id: timeGroup }
                RadioButton { text: qsTr("Morning"); checked: true; ButtonGroup.group: timeGroup }
                RadioButton { text: qsTr("Afternoon"); ButtonGroup.group: timeGroup }
                RadioButton { text: qsTr("Evening"); ButtonGroup.group: timeGroup }
            }
        }
    }
}
