import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Dashboard example — one padding inset; tiles/cards bring Layout.fillWidth.

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

            GridLayout {
                Layout.fillWidth: true
                columns: width > 700 ? 3 : 1
                rowSpacing: Theme.spacingLoose
                columnSpacing: Theme.spacingLoose

                KpiTile {
                    id: kpiCpu
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

            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: Theme.spacingSection
                spacing: Theme.spacingLoose

                ChartCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 260
                    title: qsTr("Utilization")
                    subtitle: qsTr("CPU / Memory")
                    LineChart {
                        anchors.fill: parent
                        series: window.utilSeries
                    }
                }

                ChartCard {
                    Layout.preferredWidth: 220
                    Layout.preferredHeight: 260
                    title: qsTr("CPU ring")
                    RingGauge {
                        anchors.centerIn: parent
                        width: 160
                        height: 160
                        title: qsTr("CPU")
                        value: window.cpu
                        unit: "%"
                        cautionThreshold: 0.75
                        criticalThreshold: 0.9
                    }
                }
            }
        }
    }
}
