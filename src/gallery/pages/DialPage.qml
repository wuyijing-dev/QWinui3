import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

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
                title: qsTr("Dial")
                subtitle: qsTr("Fluent dial with ticks, title, showValue, and Accessible.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
