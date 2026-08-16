import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Switch.
//
// Use a Switch to present users with two mutually exclusive options. API: docs/components/Switch.md

CatalogPage {
    title: qsTr("Switch")
    subtitle: qsTr("Use a Switch to present users with two mutually exclusive options.")

    ControlExample {
        headerText: qsTr("A simple Switch")
        qmlSource: "Switch { text: \"Off\" }\nSwitch { text: \"On\"; checked: true }\nSwitch { text: \"Disabled\"; enabled: false }\nSwitch { text: \"Disabled on\"; checked: true; enabled: false }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Switch { text: qsTr("Off") }
            Switch { text: qsTr("On"); checked: true }
            Switch { text: qsTr("Disabled"); enabled: false }
            Switch { text: qsTr("Disabled on"); checked: true; enabled: false }
        }
    }

    ControlExample {
        headerText: qsTr("OnContent / OffContent")
        qmlSource: "Switch {\n    text: \"Wi‑Fi\"\n    onContent: \"On\"\n    offContent: \"Off\"\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Switch {
                text: qsTr("Wi‑Fi")
                onContent: qsTr("On")
                offContent: qsTr("Off")
                checked: true
            }
            Switch {
                header: qsTr("Bluetooth")
                onContent: qsTr("On")
                offContent: qsTr("Off")
            }
        }
    }
}
