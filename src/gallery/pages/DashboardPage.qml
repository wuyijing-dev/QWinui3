import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Dashboard (1.66).
// Stable layout matches examples/dashboard; extra gauges are deferred.
// Recipe: docs/charts.md

CatalogPage {
    id: page
    title: qsTr("Dashboard")
    subtitle: qsTr("Stable KPI/chart recipe (1.66) — extra gauges deferred. docs/charts.md.")

    signal openControl(var item)

    property real cpu: 64
    property real mem: 71
    property real tank: 58
    property real temp: 42
    property real latency: 42
    property var cpuTrend: [52, 55, 58, 54, 60, 62, 59, 61, 64]
    property var memTrend: [68, 69, 70, 71, 70, 72, 71, 73, 71]
    property var latTrend: [48, 44, 46, 42, 40, 43, 41, 39, 42]
    property var utilSeries: [
        { name: qsTr("CPU"), color: Theme.accent, values: [40, 48, 52, 55, 60, 58, 62, 64] },
        { name: qsTr("Mem"), color: Theme.systemCaution, values: [60, 62, 65, 68, 70, 69, 71, 71] }
    ]

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

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
        headerText: qsTr("Stable ops overview (1.66)")
        qmlSource: "KpiTile { … }\nChartCard { LineChart / BarChart / DonutChart }\nRingGauge { … }\n// examples/dashboard · docs/charts.md"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Matches examples/dashboard: only LineChart, BarChart, DonutChart, RingGauge, KpiTile, ChartCard. Copy that example for product shells.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

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
                columns: width > 900 ? 2 : 1
                rowSpacing: Theme.spacingLoose
                columnSpacing: Theme.spacingLoose

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("Utilization")
                    subtitle: qsTr("CPU / Memory")
                    footer: qsTr("Live")
                    LineChart {
                        anchors.fill: parent
                        showLegend: true
                        series: page.utilSeries
                    }
                }

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("CPU ring")
                    RingGauge {
                        anchors.centerIn: parent
                        width: 140
                        height: 140
                        title: qsTr("CPU")
                        value: page.cpu
                        unit: "%"
                        cautionThreshold: 0.75
                        criticalThreshold: 0.9
                    }
                }

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("Throughput")
                    subtitle: qsTr("Requests / min")
                    BarChart {
                        anchors.fill: parent
                        values: [18, 26, 22, 34, 40, 31, 28]
                        unit: ""
                        showValueLabels: false
                    }
                }

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("Share")
                    DonutChart {
                        anchors.fill: parent
                        centerText: "72%"
                        slices: [
                            { value: 42, label: qsTr("Apps"), color: Theme.accent },
                            { value: 18, label: qsTr("Media"), color: Theme.systemCaution },
                            { value: 12, label: qsTr("Docs"), color: Theme.systemSuccess }
                        ]
                    }
                }
            }

            Button {
                text: qsTr("Charts hub")
                onClicked: page.openComp("ChartsPage")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Deferred gauges (1.66)")
        qmlSource: "TankGauge { … }       // deferred\nThermometerGauge { … } // prefer RingGauge"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("TankGauge / ThermometerGauge stay experimental. Prefer RingGauge in product dashboards.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            GridLayout {
                Layout.fillWidth: true
                columns: width > 720 ? 2 : 1
                rowSpacing: Theme.spacingLoose
                columnSpacing: Theme.spacingLoose

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    title: qsTr("Coolant")
                    subtitle: qsTr("TankGauge — deferred")
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
                    subtitle: qsTr("ThermometerGauge — deferred")
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
            }
        }
    }
}
