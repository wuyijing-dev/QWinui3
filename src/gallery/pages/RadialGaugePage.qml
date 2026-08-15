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
                title: qsTr("RadialGauge")
                subtitle: qsTr("Drag when isInteractive; invertThresholds, stepSize, valueEdited.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive")
                qmlSource: "RadialGauge {\n    isInteractive: true\n    cautionThreshold: 0.7\n}"
                ColumnLayout {
                    spacing: Theme.spacingLoose
                    RowLayout {
                        spacing: Theme.spacingSection
                        RadialGauge {
                            id: gauge
                            width: 168
                            height: 168
                            value: 72
                            unit: "%"
                            title: qsTr("CPU")
                            tickCount: 9
                            showNeedle: true
                            isInteractive: true
                            stepSize: 1
                            cautionThreshold: 0.7
                            criticalThreshold: 0.9
                        }
                        RadialGauge {
                            width: 128
                            height: 128
                            value: 22
                            maximum: 100
                            fillColor: Theme.systemSuccess
                            showValue: true
                            showNeedle: false
                            unit: "%"
                            title: qsTr("Battery")
                            caption: qsTr("Remaining")
                            isInteractive: true
                            invertThresholds: true
                            cautionThreshold: 0.55
                            criticalThreshold: 0.8
                        }
                    }
                    Label {
                        text: qsTr("%1% — drag the dial").arg(Math.round(gauge.percentage))
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
