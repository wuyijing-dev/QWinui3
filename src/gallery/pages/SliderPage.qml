import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Slider.

CatalogPage {
    title: qsTr("Slider")
    subtitle: qsTr("A control that lets the user select from a range of values by moving a thumb.")

    ControlExample {
        headerText: qsTr("A simple Slider")
        qmlSource: "Slider {\n    from: 0\n    to: 100\n    value: 40\n}\nSlider {\n    from: 0\n    to: 100\n    value: 70\n    enabled: false\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Slider {
                Layout.preferredWidth: 320
                from: 0
                to: 100
                value: 40
            }
            Slider {
                Layout.preferredWidth: 320
                from: 0
                to: 100
                value: 70
                enabled: false
            }
        }
    }
}
