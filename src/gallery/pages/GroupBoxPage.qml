import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — GroupBox.

CatalogPage {
    title: qsTr("GroupBox")
    subtitle: qsTr("Groups related controls under a common labeled frame.")

    ControlExample {
        headerText: qsTr("A simple GroupBox")
        qmlSource: "GroupBox {\n    title: \"Options\"\n    ColumnLayout {\n        CheckBox { text: \"Option A\"; checked: true }\n        CheckBox { text: \"Option B\" }\n    }\n}"

        GroupBox {
            title: qsTr("Options")
            Layout.preferredWidth: 320
            ColumnLayout {
                CheckBox { text: qsTr("Option A"); checked: true }
                CheckBox { text: qsTr("Option B") }
                CheckBox { text: qsTr("Option C") }
            }
        }
    }
}
