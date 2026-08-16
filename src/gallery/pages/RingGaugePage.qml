import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RingGauge.
//
// Closed KPI ring; drag when interactive; thresholds tint the stroke. API: docs/components/RingGauge.md

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
                title: qsTr("RingGauge")
                subtitle: qsTr("Closed KPI ring with center value; drag when interactive.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive rings")
                qmlSource: "RingGauge {\n    isInteractive: true\n    target: 80\n    cautionThreshold: 0.7\n}"
                ColumnLayout {
                    spacing: Theme.spacingLoose
                    RowLayout {
                        spacing: Theme.spacingSection
                        RingGauge {
                            id: cpuRing
                            width: 160
                            height: 160
                            title: qsTr("CPU")
                            value: 72
                            unit: "%"
                            target: 80
                            showTarget: true
                            showGlow: true
                            showThumb: true
                            isInteractive: true
                            cautionThreshold: 0.7
                            criticalThreshold: 0.9
                            caption: qsTr("Host A")
                        }
                        RingGauge {
                            width: 148
                            height: 148
                            title: qsTr("Battery")
                            value: 28
                            unit: "%"
                            isInteractive: true
                            invertThresholds: true
                            cautionThreshold: 0.55
                            criticalThreshold: 0.8
                            fillColor: Theme.systemSuccess
                            sweepTotal: 360
                            showGlow: false
                            caption: qsTr("Remaining")
                        }
                    }
                    Label {
                        text: qsTr("CPU severity %1 — scroll wheel or nudge; target marker at 80%")
                              .arg(cpuRing.severity)
                        color: Theme.textSecondary
                    }
                    RowLayout {
                        spacing: Theme.spacing
                        Button {
                            text: qsTr("Nudge −5")
                            onClicked: cpuRing.nudge(-5)
                        }
                        Button {
                            text: qsTr("Nudge +5")
                            onClicked: cpuRing.nudge(5)
                        }
                        Button {
                            text: qsTr("Set 95")
                            onClicked: cpuRing.setValue(95)
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
