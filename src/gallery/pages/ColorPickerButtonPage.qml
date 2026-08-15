import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("ColorPickerButton")
                subtitle: qsTr("Preview swatch with ColorPicker flyout. Supports showAlpha and isOpen.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Accent")
                qmlSource: "ColorPickerButton {\n    showAlpha: true\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    CheckBox {
                        id: alphaBox
                        text: qsTr("Show alpha")
                    }
                    RowLayout {
                        spacing: Theme.spacingLoose
                        ColorPickerButton {
                            id: colorBtn
                            selectedColor: Theme.accent
                            showAlpha: alphaBox.checked
                        }
                        Label {
                            text: String(colorBtn.selectedColor).toUpperCase()
                            color: Theme.textSecondary
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
