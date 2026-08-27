import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ColorPickerButton.
//
// Swatch → ColorPicker. Forms: wrap with HeaderedContentControl — docs/pickers.md.

CatalogPage {
    title: qsTr("ColorPickerButton")
    subtitle: qsTr("Swatch flyout. For forms wrap with HeaderedContentControl — docs/pickers.md.")

    ControlExample {
        headerText: qsTr("Accent")
        qmlSource: "ColorPickerButton {\n    showHexLabel: true\n    flyoutPlacement: Qt.AlignBottom\n}"
        ColumnLayout {
            spacing: Theme.spacing
            CheckBox {
                id: alphaBox
                text: qsTr("Show alpha")
            }
            CheckBox {
                id: hexBox
                text: qsTr("Show hex on button")
                checked: true
            }
            RowLayout {
                spacing: Theme.spacingLoose
                ColorPickerButton {
                    id: colorBtn
                    selectedColor: Theme.accent
                    showAlpha: alphaBox.checked
                    showHexLabel: hexBox.checked
                    flyoutPlacement: Qt.AlignBottom
                }
                Label {
                    text: qsTr("Open: %1").arg(colorBtn.isOpen ? qsTr("yes") : qsTr("no"))
                    color: Theme.textSecondary
                }
            }
        }
    }
}
