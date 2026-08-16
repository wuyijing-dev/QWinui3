import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — RadioButton.
//
// Use RadioButtons to let users select one option from two or more choices. API: docs/components/RadioButton.md

CatalogPage {
    title: qsTr("RadioButton")
    subtitle: qsTr("Use RadioButtons to let users select one option from two or more choices.")

    ControlExample {
        headerText: qsTr("A group of RadioButtons")
        qmlSource: "ButtonGroup { id: group }\nRadioButton {\n    text: \"Option A\"\n    checked: true\n    ButtonGroup.group: group\n}\nRadioButton {\n    text: \"Option B\"\n    ButtonGroup.group: group\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            ButtonGroup { id: group }

            RadioButton { text: qsTr("Option A"); checked: true; ButtonGroup.group: group }
            RadioButton { text: qsTr("Option B"); ButtonGroup.group: group }
            RadioButton { text: qsTr("Option C"); ButtonGroup.group: group }
            RadioButton { text: qsTr("Disabled"); enabled: false }
        }
    }
}
