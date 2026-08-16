import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ComboBox.

CatalogPage {
    title: qsTr("ComboBox")
    subtitle: qsTr("Fluent chevron indicator with popup-open rotation.")

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
