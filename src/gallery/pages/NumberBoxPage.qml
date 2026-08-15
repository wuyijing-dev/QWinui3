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
                subtitle: qsTr("WinUI NumberBox: spin placement, LargeChange, and validation flash.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Inline spins")
                qmlSource: "NumberBox {\n    spinButtonPlacementMode: \"inline\"\n}"
                NumberBox {
                    Layout.preferredWidth: 180
                    value: 5
                    minimum: 0
                    maximum: 100
                    stepSize: 1
                    largeChange: 10
                    spinButtonPlacementMode: "inline"
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Compact (hover to reveal)")
                qmlSource: "NumberBox {\n    spinButtonPlacementMode: \"compact\"\n}"
                NumberBox {
                    Layout.preferredWidth: 180
                    value: 1.5
                    minimum: 0
                    maximum: 10
                    stepSize: 0.5
                    decimals: 1
                    spinButtonPlacementMode: "compact"
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Hidden spins + keyboard")
                qmlSource: "NumberBox {\n    spinButtonPlacementMode: \"hidden\"\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    NumberBox {
                        Layout.preferredWidth: 180
                        value: 3
                        minimum: 0
                        maximum: 10
                        largeChange: 2
                        spinButtonPlacementMode: "hidden"
                    }
                    Label {
                        text: qsTr("↑/↓ step, PageUp/PageDown largeChange. Out-of-range Enter flashes critical border.")
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
