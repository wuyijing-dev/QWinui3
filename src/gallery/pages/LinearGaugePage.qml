import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — LinearGauge.
//
// Drag when isInteractive; stepSize, invertThresholds, showMinMax, valueEdited. API: docs/components/LinearGauge.md

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
                title: qsTr("LinearGauge")
                subtitle: qsTr("Drag when isInteractive; stepSize, invertThresholds, showMinMax, valueEdited.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive")
                qmlSource: "LinearGauge {\n    isInteractive: true\n    stepSize: 1\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    Label {
                        id: linMsg
                        text: qsTr("Drag the track or thumb")
                        color: Theme.textSecondary
                    }
                    LinearGauge {
                        id: hGauge
                        Layout.fillWidth: true
                        Layout.maximumWidth: 420
                        title: qsTr("Memory")
                        value: 68
                        unit: "%"
                        isInteractive: true
                        stepSize: 1
                        showMinMax: true
                        cautionThreshold: 0.7
                        criticalThreshold: 0.9
                        caption: qsTr("%1%").arg(Math.round(hGauge.percentage))
                        onValueEdited: function (v) {
                            linMsg.text = qsTr("valueEdited: %1").arg(Math.round(v))
                        }
                    }
                    LinearGauge {
                        Layout.preferredHeight: 200
                        orientation: Qt.Vertical
                        title: qsTr("Battery")
                        value: 28
                        unit: "%"
                        isInteractive: true
                        invertThresholds: true
                        cautionThreshold: 0.55
                        criticalThreshold: 0.8
                        fillColor: Theme.systemSuccess
                        showTicks: true
                        tickCount: 6
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
