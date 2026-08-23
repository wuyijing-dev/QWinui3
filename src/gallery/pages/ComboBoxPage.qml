import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ComboBox.

CatalogPage {
    title: qsTr("ComboBox")
    subtitle: qsTr("Fluent chevron · appearance filled/outline · hasError (2.66 A2).")

    ControlExample {
        headerText: qsTr("Appearances (2.66 A2)")
        qmlSource: "ComboBox { appearance: \"filled\" }\nComboBox { appearance: \"outline\" }\nComboBox { hasError: true }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ComboBox {
                Layout.preferredWidth: 240
                appearance: "filled"
                model: [qsTr("Filled"), qsTr("Option B")]
            }
            ComboBox {
                Layout.preferredWidth: 240
                appearance: "outline"
                model: [qsTr("Outline"), qsTr("Option B")]
            }
            ComboBox {
                Layout.preferredWidth: 240
                appearance: "outline"
                hasError: true
                model: [qsTr("Has error"), qsTr("Option B")]
            }
        }
    }

    ControlExample {
        headerText: qsTr("A simple ComboBox")
        qmlSource: "ComboBox {\n    model: [\"Red\", \"Green\", \"Blue\", \"Orange\"]\n}\nComboBox {\n    model: [\"One\", \"Two\", \"Three\"]\n    enabled: false\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            ComboBox {
                Layout.preferredWidth: 240
                model: [qsTr("Red"), qsTr("Green"), qsTr("Blue"), qsTr("Orange")]
            }
            ComboBox {
                Layout.preferredWidth: 240
                model: [qsTr("One"), qsTr("Two"), qsTr("Three")]
                enabled: false
            }
        }
    }
}
