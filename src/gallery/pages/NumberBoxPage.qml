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
                title: qsTr("NumberBox")
                subtitle: qsTr("Fluent spin chevrons, wheel, validationMode, and focusField().")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Header + wheel")
                qmlSource: "NumberBox {\n    header: \"Quantity\"\n    acceptWheel: true\n}"
                NumberBox {
                    Layout.preferredWidth: 220
                    header: qsTr("Quantity")
                    description: qsTr("Scroll or use ↑/↓. Ctrl+wheel uses largeChange.")
                    value: 5
                    minimum: 0
                    maximum: 100
                    stepSize: 1
                    largeChange: 10
                    spinButtonPlacementMode: "inline"
                    acceptWheel: true
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Compact (hover to reveal)")
                qmlSource: "NumberBox {\n    spinButtonPlacementMode: \"compact\"\n}"
                NumberBox {
                    Layout.preferredWidth: 220
                    header: qsTr("Opacity")
                    value: 1.5
                    minimum: 0
                    maximum: 10
                    stepSize: 0.5
                    decimals: 1
                    suffix: "×"
                    spinButtonPlacementMode: "compact"
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Validation")
                qmlSource: "NumberBox {\n    validationMode: \"invalidInputOverValue\"\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    NumberBox {
                        Layout.preferredWidth: 220
                        header: qsTr("Score")
                        value: 3
                        minimum: 0
                        maximum: 10
                        largeChange: 2
                        spinButtonPlacementMode: "hidden"
                        validationMode: "invalidInputOverValue"
                        errorMessage: ""
                    }
                    Label {
                        text: qsTr("Out-of-range Enter flashes critical border. Wheel and PageUp/PageDown supported.")
                        color: Theme.textSecondary
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
