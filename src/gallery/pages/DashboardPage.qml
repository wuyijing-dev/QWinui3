import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Dashboard.
//
// Composite monitoring layout: KpiTile, RingGauge, TankGauge, charts. API: docs/components/RingGauge.md

CatalogPage {
    id: page
    title: qsTr("Dashboard")
    subtitle: qsTr("Composite layout with KPIs, ring/tank gauges, and a live chart.")

    property real cpu: 64
    property real mem: 71
    property real tank: 58
    property real temp: 42
    property real latency: 42
    property var spark: {
        var a = []
        for (var i = 0; i < 36; ++i)
            a.push(40 + Math.sin(i * 0.35) * 12 + (i % 5))
        return a
    }
    property var cpuTrend: [52, 55, 58, 54, 60, 62, 59, 61, 64]
    property var memTrend: [68, 69, 70, 71, 70, 72, 71, 73, 71]
    property var latTrend: [48, 44, 46, 42, 40, 43, 41, 39, 42]

    Timer {
        interval: 1400
        running: page.visible
        repeat: true
        onTriggered: {
            page.cpu = 40 + Math.round(Math.random() * 45)
            page.mem = 55 + Math.round(Math.random() * 30)
            page.tank = 35 + Math.round(Math.random() * 50)
            page.temp = 28 + Math.round(Math.random() * 40)
            page.latency = 28 + Math.round(Math.random() * 30)
            kpiCpu.pushTrend(page.cpu, 16)
            kpiMem.pushTrend(page.mem, 16)
            kpiLat.pushTrend(page.latency, 16)
        }
    }

    ControlExample {
        headerText: qsTr("Ops overview")
        qmlSource: "KpiTile { … }\nRingGauge { … }\nTankGauge { … }\nChartCard { LineChart { … } }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            GridLayout {
                Layout.fillWidth: true
                columns: width > 700 ? 3 : 1
                rowSpacing: Theme.spacingLoose
                columnSpacing: Theme.spacingLoose

                KpiTile {
                    id: kpiCpu
                    Layout.fillWidth: true
                    title: qsTr("CPU")
                    value: page.cpu
                    unit: "%"
                    delta: 1.6
                    cautionThreshold: 75
                    criticalThreshold: 90
                    badgeText: qsTr("LIVE")
                    trendValues: page.cpuTrend
                    symbol: FluentIcons.Sync
                    elevated: true
                    footer: qsTr("severity %1").arg(kpiCpu.severity)
                }
                KpiTile {
                    id: kpiMem
                    Layout.fillWidth: true
                    title: qsTr("Memory")
                    value: page.mem
                    unit: "%"
                    delta: -0.8
                    invertDeltaColors: true
                    cautionThreshold: 80
                    criticalThreshold: 92
                    trendValues: page.memTrend
                    symbol: FluentIcons.Save
                    elevated: true
                }
                KpiTile {
                    id: kpiLat
                    Layout.fillWidth: true
                    title: qsTr("Latency p95")
                    value: page.latency
                    unit: " ms"
                    delta: -2.4
                    invertDeltaColors: true
                    invertThresholds: true
                    cautionThreshold: 50
                    criticalThreshold: 70
                    badgeText: qsTr("p95")
                    trendValues: page.latTrend
                    symbol: FluentIcons.Clock
                    elevated: true
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: width > 900 ? 4 : (width > 720 ? 2 : 1)
                rowSpacing: Theme.spacingLoose
                columnSpacing: Theme.spacingLoose

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("Utilization")
                    subtitle: qsTr("Ring gauges")
                    footer: qsTr("Live")
                    RowLayout {
                        anchors.fill: parent
                        spacing: Theme.spacingLoose
                        RingGauge {
                            Layout.preferredWidth: 140
                            Layout.preferredHeight: 140
                            title: qsTr("CPU")
                            value: page.cpu
                            unit: "%"
                            target: 75
                            cautionThreshold: 0.75
                            criticalThreshold: 0.9
                        }
                        RingGauge {
                            Layout.preferredWidth: 140
                            Layout.preferredHeight: 140
                            title: qsTr("Mem")
                            value: page.mem
                            unit: "%"
                            cautionThreshold: 0.8
                            criticalThreshold: 0.92
                            fillColor: Theme.systemCaution
                        }
                    }
                }

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("Coolant")
                    subtitle: qsTr("Tank level")
                    footer: qsTr("%1%").arg(Math.round(page.tank))
                    TankGauge {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 96
                        height: 160
                        value: page.tank
                        unit: "%"
                        target: 55
                        showMarks: true
                        showThresholdBands: true
                        invertThresholds: true
                        cautionThreshold: 0.4
                        criticalThreshold: 0.7
                        showMinMax: true
                    }
                }

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("Thermal")
                    subtitle: qsTr("Package")
                    footer: qsTr("%1°C").arg(Math.round(page.temp))
                    ThermometerGauge {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 72
                        height: 160
                        value: page.temp
                        minimum: 20
                        maximum: 100
                        unit: "°C"
                        valuePrecision: 0
                        target: 55
                        showTickLabels: true
                        cautionThreshold: 0.65
                        criticalThreshold: 0.8
                        fillColor: Theme.systemCaution
                    }
                }

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("Throughput")
                    subtitle: qsTr("Requests / min")
                    footer: qsTr("Updated just now")
                    LineChart {
                        anchors.fill: parent
                        showLegend: false
                        values: page.spark
                    }
                }
            }
        }
    }
}
