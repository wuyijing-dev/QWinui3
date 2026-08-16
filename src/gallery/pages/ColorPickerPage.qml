import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ColorPicker.
//
// Spectrum, RGB/HSV/HEX, CopyButton for hex, and WinUI visibility toggles. API: docs/components/ColorPicker.md

CatalogPage {
    title: qsTr("ColorPicker")
    subtitle: qsTr("Spectrum, RGB/HSV/HEX, CopyButton for hex, and WinUI visibility toggles.")

    ControlExample {
        headerText: qsTr("ColorPicker Properties")
        qmlSource: "ColorPicker {\n    selectedColor: \"#005FB8\"\n}"
        ColorPicker {
            id: picker
            Layout.preferredWidth: 312
            selectedColor: Theme.accent
            previousColor: "#8764B8"
            isPreviousColorVisible: true
            colorSpectrumShape: shapeBox.currentText
            onColorChosen: function (c) {
                // keep previous as last committed sample for demo
            }
        }
    }
    ControlExample {
        headerText: qsTr("Spectrum shape")
        qmlSource: "colorSpectrumShape: \"ring\""
        RowLayout {
            spacing: Theme.spacing
            Label { text: qsTr("Shape"); color: Theme.textSecondary }
            ComboBox {
                id: shapeBox
                model: ["box", "ring"]
                currentIndex: 0
                Layout.preferredWidth: 120
            }
        }
    }
    ControlExample {
        headerText: qsTr("Selection")
        qmlSource: "selectedColor"
        RowLayout {
            spacing: Theme.spacingLoose
            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                radius: Theme.cornerControl
                color: picker.selectedColor
                border.width: 1
                border.color: Theme.strokeControl
            }
            Label {
                text: String(picker.selectedColor).toUpperCase()
                color: Theme.textSecondary
            }
        }
    }
}
