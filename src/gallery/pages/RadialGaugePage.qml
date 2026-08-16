import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RadialGauge.
//
// Toolkit-aligned: MinAngle/MaxAngle, TickSpacing, ScaleWidth, Needle*, ValueStringFormat.
// API: docs/components/RadialGauge.md

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
                subtitle: qsTr("Community Toolkit–aligned needle gauge (MinAngle, TickSpacing, ScaleWidth, NeedleLength).")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Toolkit sample")
                qmlSource: "RadialGauge {\n    minAngle: -150; maxAngle: 150\n    tickSpacing: 20\n    scaleWidth: 12\n    isInteractive: true\n}"
                ColumnLayout {
                    spacing: Theme.spacingLoose
                    RowLayout {
                        spacing: Theme.spacingSection
                        RadialGauge {
                            id: gauge
                            width: 200
                            height: 200
                            value: 120
                            minimum: 0
                            maximum: 240
                            minAngle: -150
                            maxAngle: 150
                            tickSpacing: 20
                            scaleWidth: 12
                            scalePadding: 4
                            tickLength: 8
                            tickWidth: 2
                            tickPadding: 6
                            scaleTickWidth: 2
                            needleLength: 0.68
                            needleWidth: 4
                            stepSize: 5
                            valueStringFormat: "N0"
                            unit: "rpm"
                            title: qsTr("Motor")
                            isInteractive: true
                            cautionThreshold: 0.75
                            criticalThreshold: 0.9
                        }
                        RadialGauge {
                            width: 148
                            height: 148
                            value: 22
                            maximum: 100
                            trailBrush: Theme.systemSuccess
                            showNeedle: false
                            unit: "%"
                            title: qsTr("Battery")
                            caption: qsTr("Remaining")
                            valueStringFormat: "N0"
                            isInteractive: true
                            invertThresholds: true
                            cautionThreshold: 0.55
                            criticalThreshold: 0.8
                            tickSpacing: 25
                            scaleWidth: 14
                        }
                    }
                    Label {
                        text: qsTr("Value %1 — angle %2° — severity %3 — drag or scroll")
                              .arg(Math.round(gauge.value))
                              .arg(Math.round(gauge.valueAngle))
                              .arg(gauge.severity)
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
