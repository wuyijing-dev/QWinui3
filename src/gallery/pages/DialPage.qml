import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Dial.

CatalogPage {
    title: qsTr("Dial")
    subtitle: qsTr("Fluent dial with ticks, title, showValue, and Accessible.")

    ControlExample {
        headerText: qsTr("Standard")
        qmlSource: "Dial {\n    title: \"Volume\"\n    unit: \"%\"\n    showTicks: true\n}"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Dial {
                title: qsTr("Volume")
                from: 0
                to: 100
                value: 40
                unit: "%"
                showValue: true
                showTicks: true
            }
            Dial {
                title: qsTr("Disabled")
                enabled: false
                value: 25
                showValue: true
            }
        }
    }
}
