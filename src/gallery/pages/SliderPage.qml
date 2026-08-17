import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Slider.

CatalogPage {
    title: qsTr("Slider")
    subtitle: qsTr("Range thumb — keep targets ≥ Theme.controlHeight. Touch: docs/touch-pointer.md (1.57).")

    ControlExample {
        headerText: qsTr("Touch note (1.57)")
        qmlSource: "docs/touch-pointer.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Thumbs follow Theme metrics. On touch devices, avoid ultra-compact density if sliders are primary controls — docs/touch-pointer.md · docs/density.md.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

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
