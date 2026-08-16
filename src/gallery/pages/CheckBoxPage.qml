import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — CheckBox.
//
// A control that a user can select or clear. API: docs/components/CheckBox.md

CatalogPage {
    title: qsTr("CheckBox")
    subtitle: qsTr("A control that a user can select or clear.")

    ControlExample {
        headerText: qsTr("A 2-state CheckBox")
        qmlSource: "CheckBox { text: \"Unchecked\" }\nCheckBox { text: \"Checked\"; checked: true }\nCheckBox { text: \"Disabled\"; enabled: false }\nCheckBox { text: \"Disabled checked\"; checked: true; enabled: false }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            CheckBox { text: qsTr("Unchecked") }
            CheckBox { text: qsTr("Checked"); checked: true }
            CheckBox { text: qsTr("Disabled"); enabled: false }
            CheckBox { text: qsTr("Disabled checked"); checked: true; enabled: false }
        }
    }

    ControlExample {
        headerText: qsTr("A 3-state CheckBox")
        qmlSource: "CheckBox {\n    text: \"Indeterminate\"\n    checkState: Qt.PartiallyChecked\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            CheckBox { text: qsTr("Indeterminate"); checkState: Qt.PartiallyChecked }
        }
    }
}
