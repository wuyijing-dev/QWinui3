import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Dashboard example — responsive ops layout (2.22).
// Stable six: docs/charts.md — KpiTile, ChartCard, LineChart, BarChart, DonutChart, RingGauge.

StandardWindow {
    id: window
    width: 1100
    height: 760
    visible: true
    title: qsTr("Dashboard example")
    backdrop: WindowHelper.BackdropSolid

    // Breakpoints — match Gallery DashboardPage + docs/charts.md (2.22).
    readonly property int kpiBreakpoint: 700
    readonly property int chartBreakpoint: 900
    readonly property int filterPaneBreakpoint: 720
    readonly property int kpiColumns: content.width > kpiBreakpoint ? 3 : 1
    readonly property int chartColumns: content.width > chartBreakpoint ? 2 : 1

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

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        background: null

        ColumnLayout {
            id: content
            x: Theme.spacingSection
            width: Math.max(0, scroll.availableWidth - 2 * Theme.spacingSection)
            spacing: Theme.spacingSection

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }

            Text {
                text: qsTr("Ops dashboard")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontTitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                text: qsTr("Layout: %1 px · KPI columns: %2 (≥%3 → 3) · chart columns: %4 (≥%5 → 2) · filter pane: %6")
                        .arg(Math.round(content.width))
                        .arg(window.kpiColumns).arg(window.kpiBreakpoint)
                        .arg(window.chartColumns).arg(window.chartBreakpoint)
                        .arg(filterPane.modeName)
            }

            GridLayout {
                Layout.fillWidth: true
                columns: window.kpiColumns
                rowSpacing: Theme.spacingLoose
                columnSpacing: Theme.spacingLoose

                KpiTile {
                    id: kpiCpu
                    Layout.fillWidth: true
                    title: qsTr("CPU")
                    value: window.cpu
                    unit: "%"
                    delta: 1.6
                    cautionThreshold: 75
                    criticalThreshold: 90
                    badgeText: qsTr("LIVE")
                    trendValues: window.cpuTrend
                    symbol: FluentIcons.Sync
                    elevated: true
                }
                KpiTile {
                    id: kpiMem
                    Layout.fillWidth: true
                    title: qsTr("Memory")
                    value: window.mem
                    unit: "%"
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

            TwoPaneView {
                id: filterPane
                Layout.fillWidth: true
                Layout.preferredHeight: 540
                preferredMode: TwoPaneView.Wide
                minWideWidth: window.filterPaneBreakpoint

                pane1: Rectangle {
                    color: Theme.bgCard
                    border.width: 1
                    border.color: Theme.strokeCard
                    radius: Theme.cornerCard
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing
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
                        CheckBox {
                            text: qsTr("Show deferred gauges")
                            checked: false
                        }
                        Item { Layout.fillHeight: true }
                        Text {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            text: qsTr("TwoPaneView: filter rail beside charts when width ≥ %1. Narrow → SinglePane (docs/charts.md 2.22).")
                                    .arg(window.filterPaneBreakpoint)
                            font.pixelSize: Theme.fontCaption
                            color: Theme.textSecondary
                        }
                    }
                }

                pane2: Item {
                    GridLayout {
                        anchors.fill: parent
                        columns: window.chartColumns
                        rowSpacing: Theme.spacingLoose
                        columnSpacing: Theme.spacingLoose

                        ChartCard {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 220
                            title: qsTr("Utilization")
                            subtitle: qsTr("CPU / Memory")
                            LineChart {
                                anchors.fill: parent
                                showLegend: true
                                series: window.utilSeries
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
                                value: window.cpu
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
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
