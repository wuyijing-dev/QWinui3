import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

// Gallery — Dashboard.
// Stable layout + responsive breakpoints; matches examples/dashboard.
// Recipe: docs/charts.md

CatalogPage {
    id: page
    title: qsTr("Dashboard")
    subtitle: qsTr("DashboardShell, MetricCompareRow, zoom / empty / export — docs/charts.md")

    signal openControl(var item)

    readonly property int kpiBreakpoint: 700
    readonly property int chartBreakpoint: 900

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
    property string emptyState: "empty"
    property string exportNote: ""

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

    Timer {
        interval: 1100
        running: page.emptyState === "loading"
        repeat: false
        onTriggered: page.emptyState = "error"
    }

    ControlExample {
        headerText: qsTr("Responsive breakpoints")
        qmlSource: "DashboardShell {\n    chartBreakpoint: 900\n    filterBreakpoint: 720\n    // chartColumns hint for GridLayout\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("DashboardShell exposes chartColumns / filterBreakpoint. Optional filterPane uses TwoPaneView (wide ≥ 720). See examples/dashboard.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textPrimary
                font.pixelSize: Theme.fontCaption
                text: qsTr("Demo width: %1 px · chart cols: %2")
                        .arg(Math.round(shellDemo.width))
                        .arg(shellDemo.width > page.chartBreakpoint ? 2 : 1)
            }
        }
    }

    ControlExample {
        headerText: qsTr("Compose vs stable")
        qmlSource: "// docs/dashboard-compose-decision.md\n// Sparkline → KpiTile.trendValues\n// AreaChart → LineChart.showArea"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Friction slot: pick stable six in product — deferred siblings only in Gallery demos. Sparkline → KpiTile.trendValues; AreaChart → LineChart.showArea; PieChart → DonutChart; Tank/Thermometer → RingGauge. Full tree: docs/dashboard-compose-decision.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Repeater {
                model: [
                    { need: qsTr("Inline trend"), use: qsTr("KpiTile.trendValues"), avoid: qsTr("Sparkline") },
                    { need: qsTr("Area series"), use: qsTr("LineChart.showArea"), avoid: qsTr("AreaChart") },
                    { need: qsTr("Share mix"), use: qsTr("DonutChart"), avoid: qsTr("PieChart") },
                    { need: qsTr("Tank level"), use: qsTr("RingGauge"), avoid: qsTr("TankGauge") }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Label {
                        Layout.preferredWidth: 120
                        text: modelData.need
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }
                    Label {
                        Layout.fillWidth: true
                        text: modelData.use
                        color: Theme.systemSuccess
                        font.pixelSize: Theme.fontCaption
                    }
                    Label {
                        Layout.preferredWidth: 100
                        text: modelData.avoid
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
            Button {
                text: qsTr("Charts compose hub")
                onClicked: page.openComp("ChartsPage")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Status icon strip")
        qmlSource: "KpiTile { symbol: FluentIcons.Sync }\nChartCard { symbol: FluentIcons.LineChart }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Named FluentIcons on KPI tiles and ChartCard headers — scanability without extra assets. Recipe: docs/planning/expansion/icons-dashboard-expansion.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacingLoose
                Repeater {
                    model: [
                        { label: qsTr("Healthy"), sym: FluentIcons.CheckMark, color: Theme.systemSuccess },
                        { label: qsTr("Warning"), sym: FluentIcons.Important, color: Theme.systemCaution },
                        { label: qsTr("Critical"), sym: FluentIcons.StatusErrorFull, color: Theme.systemCritical },
                        { label: qsTr("Live"), sym: FluentIcons.Sync, color: Theme.accent },
                        { label: qsTr("Network"), sym: FluentIcons.Wifi, color: Theme.textPrimary },
                        { label: qsTr("Alerts"), sym: FluentIcons.Ringer, color: Theme.textSecondary }
                    ]
                    delegate: RowLayout {
                        required property var modelData
                        spacing: Theme.spacingTight
                        FontIcon {
                            symbol: modelData.sym
                            fontSize: 18
                            iconColor: modelData.color
                            Accessible.name: modelData.label
                        }
                        Label {
                            text: modelData.label
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                        }
                    }
                }
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Iconography catalog")
                    onClicked: page.openComp("FontIconPage")
                }
                Button {
                    text: qsTr("Charts hub")
                    onClicked: page.openComp("ChartsPage")
                }
            }
        }
    }

    ControlExample {
        id: shellDemo
        headerText: qsTr("DashboardShell ops overview")
        qmlSource: "DashboardShell {\n    filterPane: …\n    kpiRow: MetricCompareRow { KpiTile { compareValue } }\n    ChartCard { LineChart { zoomEnabled } }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Matches examples/dashboard: DashboardShell filter rail, MetricCompareRow, LineChart brush zoom, ChartCard export, ChartEmptyState, DonutChart legendPosition, RingGauge valueFormat.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            DashboardShell {
                id: shell
                Layout.fillWidth: true
                Layout.preferredHeight: 720
                title: qsTr("Ops")
                subtitle: qsTr("Live · width %1 · chart cols %2")
                        .arg(Math.round(shell.width))
                        .arg(shell.chartColumns)
                filterBreakpoint: 720
                chartBreakpoint: page.chartBreakpoint

                filterPane: ColumnLayout {
                    spacing: Theme.spacing
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Filters")
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }
                    ComboBox {
                        Layout.fillWidth: true
                        model: [qsTr("Last hour"), qsTr("Last 24h"), qsTr("Last 7d")]
                        currentIndex: 1
                    }
                    CheckBox { text: qsTr("Live refresh"); checked: true }
                }

                kpiRow: MetricCompareRow {
                    Layout.fillWidth: true
                    periodLabel: qsTr("vs last period")
                    KpiTile {
                        id: kpiCpu
                        Layout.fillWidth: true
                        title: qsTr("CPU")
                        value: page.cpu
                        unit: "%"
                        compareValue: 58
                        delta: 1.6
                        cautionThreshold: 75
                        criticalThreshold: 90
                        badgeText: qsTr("LIVE")
                        trendValues: page.cpuTrend
                        sparklineHeight: 32
                        symbol: FluentIcons.Sync
                        elevated: true
                    }
                    KpiTile {
                        id: kpiMem
                        Layout.fillWidth: true
                        title: qsTr("Memory")
                        value: page.mem
                        unit: "%"
                        compareValue: 69
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
                        compareValue: 45
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
                    columns: shell.chartColumns
                    rowSpacing: Theme.spacingLoose
                    columnSpacing: Theme.spacingLoose

                    ChartCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        title: qsTr("Utilization")
                        subtitle: qsTr("Brush zoom + export")
                        footer: page.exportNote.length ? page.exportNote : qsTr("Live")
                        showExportAction: true
                        symbol: FluentIcons.LineChart
                        onExportRequested: page.exportNote = qsTr("Export requested")
                        LineChart {
                            anchors.fill: parent
                            zoomEnabled: true
                            showLegend: true
                            series: page.utilSeries
                        }
                    }

                    ChartCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        title: qsTr("CPU ring")
                        symbol: FluentIcons.SpeedHigh
                        RingGauge {
                            anchors.centerIn: parent
                            width: 140
                            height: 140
                            title: qsTr("CPU")
                            value: page.cpu
                            unit: "%"
                            valueFormat: "%1%2"
                            cautionThreshold: 0.75
                            criticalThreshold: 0.9
                        }
                    }

                    ChartCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        title: qsTr("Throughput")
                        subtitle: qsTr("Requests / min")
                        symbol: FluentIcons.BarChartHorizontal
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
                        Layout.preferredHeight: 180
                        Layout.columnSpan: shell.chartColumns
                        title: qsTr("ChartEmptyState")
                        subtitle: qsTr("empty · loading · error")
                        ChartEmptyState {
                            anchors.fill: parent
                            state: page.emptyState
                            message: page.emptyState === "error"
                                     ? qsTr("Check the data source and try again.")
                                     : qsTr("Widen the date range or connect a source.")
                            actionText: page.emptyState === "loading" ? "" : qsTr("Cycle state")
                            onActionClicked: {
                                if (page.emptyState === "empty")
                                    page.emptyState = "loading"
                                else if (page.emptyState === "error")
                                    page.emptyState = "empty"
                                else
                                    page.emptyState = "error"
                            }
                        }
                    }
                }
            }

            Button {
                text: qsTr("LineChart zoom page")
                onClicked: page.openComp("LineChart")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Deferred gauges (permanent defer)")
        qmlSource: "TankGauge { … }       // Gallery only\nThermometerGauge { … } // prefer RingGauge"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("TankGauge / ThermometerGauge and other sibling gauges stay experimental permanently. Product dashboards: RingGauge + stable six. Compose table: docs/charts.md.")
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
                    symbol: FluentIcons.Drop
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
                    symbol: FluentIcons.Temperature
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
