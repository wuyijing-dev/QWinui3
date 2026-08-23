import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Dashboard example — DashboardShell + stable six (2.65).
// Recipe: docs/charts.md

StandardWindow {
    id: window
    width: 1100
    height: 760
    visible: true
    title: qsTr("Dashboard example")
    backdrop: WindowHelper.BackdropSolid

    property real cpu: 64
    property real mem: 71
    property real latency: 42
    property var cpuTrend: [52, 55, 58, 54, 60, 62, 59, 61, 64]
    property var memTrend: [68, 69, 70, 71, 70, 72, 71, 73, 71]
    property var latTrend: [48, 44, 46, 42, 40, 43, 41, 39, 42]
    property var utilSeries: [
        { name: qsTr("CPU"), color: Theme.accent, values: [40, 48, 52, 55, 60, 58, 62, 64] },
        { name: qsTr("Mem"), color: Theme.systemCaution, values: [60, 62, 65, 68, 70, 69, 71, 71] }
    ]
    property string emptyDemoState: "empty"

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
        }
    }

    Timer {
        interval: 1400
        running: true
        repeat: true
        onTriggered: {
            window.cpu = 40 + Math.round(Math.random() * 45)
            window.mem = 55 + Math.round(Math.random() * 30)
            window.latency = 28 + Math.round(Math.random() * 30)
            kpiCpu.pushTrend(window.cpu, 16)
            kpiMem.pushTrend(window.mem, 16)
            kpiLat.pushTrend(window.latency, 16)
        }
    }

    Timer {
        interval: 1200
        running: window.emptyDemoState === "loading"
        repeat: false
        onTriggered: window.emptyDemoState = "error"
    }

    DashboardShell {
        id: shell
        anchors.fill: parent
        anchors.margins: Theme.spacingSection
        title: qsTr("Ops dashboard")
        subtitle: qsTr("DashboardShell · MetricCompareRow · LineChart zoom · ChartEmptyState — docs/charts.md")
        filterBreakpoint: 720
        chartBreakpoint: 900

        filterPane: ColumnLayout {
            spacing: Theme.spacing

            Text {
                Layout.fillWidth: true
                text: qsTr("Filters")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            ComboBox {
                Layout.fillWidth: true
                model: [qsTr("Last hour"), qsTr("Last 24h"), qsTr("Last 7d")]
                currentIndex: 1
            }
            CheckBox {
                text: qsTr("Live refresh")
                checked: true
            }
            Item { Layout.fillHeight: true }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Filter rail beside charts when width ≥ %1. Narrow keeps the chart pane.")
                        .arg(shell.filterBreakpoint)
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }

        kpiRow: MetricCompareRow {
            Layout.fillWidth: true
            periodLabel: qsTr("vs last period")
            KpiTile {
                id: kpiCpu
                Layout.fillWidth: true
                title: qsTr("CPU")
                value: window.cpu
                unit: "%"
                compareValue: 58
                delta: 1.6
                cautionThreshold: 75
                criticalThreshold: 90
                badgeText: qsTr("LIVE")
                trendValues: window.cpuTrend
                sparklineHeight: 32
                symbol: FluentIcons.Sync
                elevated: true
            }
            KpiTile {
                id: kpiMem
                Layout.fillWidth: true
                title: qsTr("Memory")
                value: window.mem
                unit: "%"
                compareValue: 69
                delta: -0.8
                invertDeltaColors: true
                cautionThreshold: 80
                criticalThreshold: 92
                trendValues: window.memTrend
                symbol: FluentIcons.Save
                elevated: true
            }
            KpiTile {
                id: kpiLat
                Layout.fillWidth: true
                title: qsTr("Latency p95")
                value: window.latency
                unit: " ms"
                compareValue: 45
                delta: -2.4
                invertDeltaColors: true
                invertThresholds: true
                cautionThreshold: 50
                criticalThreshold: 70
                badgeText: qsTr("p95")
                trendValues: window.latTrend
                symbol: FluentIcons.Clock
                elevated: true
            }
        }

        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            text: qsTr("Layout: %1 px · chart columns: %2 (≥%3 → 2)")
                    .arg(Math.round(shell.width))
                    .arg(shell.chartColumns)
                    .arg(shell.chartBreakpoint)
        }

        GridLayout {
            Layout.fillWidth: true
            columns: shell.chartColumns
            rowSpacing: Theme.spacingLoose
            columnSpacing: Theme.spacingLoose

            ChartCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                title: qsTr("Utilization")
                subtitle: qsTr("Drag to zoom · Export footer")
                footer: qsTr("Live")
                showExportAction: true
                symbol: FluentIcons.LineChart
                onExportRequested: console.log("export: utilization")
                LineChart {
                    anchors.fill: parent
                    zoomEnabled: true
                    showLegend: true
                    series: window.utilSeries
                }
            }

            ChartCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                title: qsTr("CPU ring")
                symbol: FluentIcons.SpeedHigh
                RingGauge {
                    anchors.centerIn: parent
                    width: 140
                    height: 140
                    title: qsTr("CPU")
                    value: window.cpu
                    unit: "%"
                    valueFormat: "%1%2"
                    cautionThreshold: 0.75
                    criticalThreshold: 0.9
                }
            }

            ChartCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                title: qsTr("Throughput")
                subtitle: qsTr("Requests / min")
                symbol: FluentIcons.BarChartHorizontal
                BarChart {
                    anchors.fill: parent
                    values: [18, 26, 22, 34, 40, 31, 28]
                    showValueLabels: false
                }
            }

            ChartCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                title: qsTr("Share")
                symbol: FluentIcons.PieSingle
                DonutChart {
                    anchors.fill: parent
                    centerText: "72%"
                    legendPosition: "bottom"
                    slices: [
                        { value: 42, label: qsTr("Apps"), color: Theme.accent },
                        { value: 18, label: qsTr("Media"), color: Theme.systemCaution },
                        { value: 12, label: qsTr("Docs"), color: Theme.systemSuccess }
                    ]
                }
            }

            ChartCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                Layout.columnSpan: shell.chartColumns
                title: qsTr("Empty / loading / error")
                subtitle: qsTr("ChartEmptyState inside ChartCard")
                ChartEmptyState {
                    anchors.fill: parent
                    state: window.emptyDemoState
                    message: window.emptyDemoState === "error"
                             ? qsTr("Check the data source and try again.")
                             : qsTr("Widen the date range or connect a source.")
                    actionText: window.emptyDemoState === "loading" ? "" : qsTr("Cycle state")
                    onActionClicked: {
                        if (window.emptyDemoState === "empty")
                            window.emptyDemoState = "loading"
                        else if (window.emptyDemoState === "error")
                            window.emptyDemoState = "empty"
                        else
                            window.emptyDemoState = "error"
                    }
                }
            }
        }
    }
}
