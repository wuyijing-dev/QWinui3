import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — KpiTile.
//
// Delta + sparkline KPI tiles; invertDeltaColors for lower-is-better. API: docs/components/KpiTile.md

Page {
    id: page
    padding: 0

    property var latencyTrend: [48, 44, 46, 42, 40, 43, 41, 39, 42]
    property var cpuTrend: [52, 55, 58, 54, 60, 62, 59, 61, 64]
    property var errTrend: [2, 3, 2, 4, 3, 5, 4, 3, 2]

    Timer {
        interval: 1200
        running: page.visible
        repeat: true
        onTriggered: {
            var next = 50 + Math.round(Math.random() * 30)
            liveCpu.setValueAndTrend(next, 12)
            liveCpu.delta = next - 60
        }
    }

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
                title: qsTr("KpiTile")
                subtitle: qsTr("Compact KPI with signed delta and optional sparkline.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Metric tiles")
                qmlSource: "KpiTile {\n    delta: -3.2\n    invertDeltaColors: true\n    badgeText: \"p95\"\n    trendValues: […]\n}"
                GridLayout {
                    Layout.fillWidth: true
                    columns: width > 640 ? 3 : 1
                    rowSpacing: Theme.spacingLoose
                    columnSpacing: Theme.spacingLoose

                    KpiTile {
                        Layout.fillWidth: true
                        title: qsTr("Latency p95")
                        value: 42
                        unit: " ms"
                        delta: -3.2
                        invertDeltaColors: true
                        cautionThreshold: 60
                        criticalThreshold: 80
                        invertThresholds: true
                        badgeText: qsTr("p95")
                        trendValues: page.latencyTrend
                        symbol: FluentIcons.Clock
                        caption: qsTr("vs last hour")
                        footer: qsTr("Updated just now")
                        isInteractive: true
                        onClicked: console.log("latency tile")
                    }
                    KpiTile {
                        Layout.fillWidth: true
                        id: cpuTile
                        title: qsTr("CPU")
                        value: 64
                        unit: "%"
                        delta: 2.8
                        cautionThreshold: 70
                        criticalThreshold: 90
                        trendValues: page.cpuTrend
                        symbol: FluentIcons.Sync
                        elevated: true
                        footer: qsTr("severity %1 · valueColor from thresholds").arg(cpuTile.severity)
                    }
                    KpiTile {
                        Layout.fillWidth: true
                        title: qsTr("Error rate")
                        value: 0.12
                        valuePrecision: 2
                        unit: "%"
                        delta: 0.4
                        trendValues: page.errTrend
                        symbol: FluentIcons.Warning
                        accentColor: Theme.systemCritical
                        badgeText: qsTr("HOT")
                        badgeSeverity: 3
                        caption: qsTr("Needs attention")
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Live pushTrend / setValueAndTrend")
                qmlSource: "kpi.setValueAndTrend(next, 12)"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    KpiTile {
                        id: liveCpu
                        Layout.fillWidth: true
                        Layout.maximumWidth: 360
                        title: qsTr("Live CPU")
                        value: 58
                        unit: "%"
                        delta: -2
                        cautionThreshold: 70
                        criticalThreshold: 90
                        trendValues: [50, 52, 55, 53, 58]
                        symbol: FluentIcons.Sync
                        footer: qsTr("Timer calls setValueAndTrend()")
                        animateValue: true
                    }
                    RowLayout {
                        spacing: Theme.spacing
                        Button {
                            text: qsTr("pushTrend(88)")
                            onClicked: {
                                liveCpu.pushTrend(88, 12)
                                liveCpu.value = 88
                            }
                        }
                        Button {
                            text: qsTr("clearTrend")
                            onClicked: liveCpu.clearTrend()
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
