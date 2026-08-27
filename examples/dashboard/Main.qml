import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts
import QWinUI3.Platform

// Dashboard example — DashboardShell + LiveMetricStrip (3.05) + stable six.
// Recipe: docs/charts.md · docs/app-platform-3xx.md

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
        subtitle: qsTr("LiveMetricStrip · DashboardShell · LineChart zoom — docs/charts.md (3.05)")
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
                id: liveRefresh
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

        kpiRow: LiveMetricStrip {
            id: liveKpis
            Layout.fillWidth: true
            intervalMs: 1400
            running: liveRefresh.checked
            maxPoints: 16
            compareLag: 8
            periodLabel: qsTr("vs prior window")
            metrics: [
                {
                    key: "cpu",
                    title: qsTr("CPU"),
                    unit: "%",
                    cautionThreshold: 75,
                    criticalThreshold: 90,
                    sparklineHeight: 32,
                    symbol: FluentIcons.Sync
                },
                {
                    key: "mem",
                    title: qsTr("Memory"),
                    unit: "%",
                    invertDeltaColors: true,
                    cautionThreshold: 80,
                    criticalThreshold: 92,
                    symbol: FluentIcons.Save
                },
                {
                    key: "lat",
                    title: qsTr("Latency p95"),
                    unit: " ms",
                    invertDeltaColors: true,
                    invertThresholds: true,
                    cautionThreshold: 50,
                    criticalThreshold: 70,
                    badgeText: qsTr("p95"),
                    symbol: FluentIcons.Clock
                }
            ]
            onTick: {
                window.cpu = 40 + Math.round(Math.random() * 45)
                window.mem = 55 + Math.round(Math.random() * 30)
                window.latency = 28 + Math.round(Math.random() * 30)
                pushSamples({ cpu: window.cpu, mem: window.mem, lat: window.latency })
            }
            Component.onCompleted: {
                pushSamples({ cpu: window.cpu, mem: window.mem, lat: window.latency })
            }
        }

        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            text: qsTr("Layout: %1 px · chart columns: %2 (≥%3 → 2) · samples %4")
                    .arg(Math.round(shell.width))
                    .arg(shell.chartColumns)
                    .arg(shell.chartBreakpoint)
                    .arg(liveKpis.sampleCount)
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
