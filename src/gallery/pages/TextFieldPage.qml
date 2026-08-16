import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — TextField.

CatalogPage {
    title: qsTr("TextField")
    subtitle: qsTr("A single-line text input control.")

    ControlExample {
        headerText: qsTr("A simple TextField")
        qmlSource: "TextField {\n    placeholderText: \"Placeholder\"\n}\nTextField {\n    text: \"Sample text\"\n}\nTextField {\n    text: \"Disabled\"\n    enabled: false\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            TextField {
                Layout.preferredWidth: 320
                placeholderText: qsTr("Placeholder")
            }
            TextField {
                Layout.preferredWidth: 320
                text: qsTr("Sample text")
            }
            TextField {
                Layout.preferredWidth: 320
                text: qsTr("Disabled")
                enabled: false
            }
        }
    }
}
