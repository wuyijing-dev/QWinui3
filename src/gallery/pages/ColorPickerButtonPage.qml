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
                subtitle: qsTr("Swatch, hex label, flyoutPlacement, showAlpha, and isOpen.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
