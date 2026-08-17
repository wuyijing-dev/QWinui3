import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Charts hub (1.23 stable six / 1.66 defer remaining).
// Recipe: docs/charts.md · examples/dashboard

CatalogPage {
    id: page
    title: qsTr("Charts")
    subtitle: qsTr("Stable six (1.23). Remaining charts/gauges deferred 1.66 — docs/charts.md.")

    signal openControl(var item)

    readonly property var sparkData: {
        var a = []
        for (var i = 0; i < 48; ++i)
            a.push(40 + Math.sin(i * 0.35) * 14)
        return a
    }
    readonly property var lineA: {
        var a = []
        for (var i = 0; i < 60; ++i)
            a.push(28 + Math.sin(i * 0.16) * 12)
        return a
    }

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Stable vs deferred (1.66)")
        qmlSource: "// Stable: LineChart, BarChart, DonutChart,\n//          RingGauge, KpiTile, ChartCard\n// Deferred: Area/Pie/Sparkline/extra gauges\n// docs/charts.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Production dashboards stay on the stable six. AreaChart → LineChart showArea; PieChart → DonutChart; extra gauges → RingGauge. Gallery still demos deferred types; names are not freeze-covered. Naming: series/values/slices, unit, interactive (1.11 aliases).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("examples/dashboard uses all six stable types (KpiTile + ChartCard + Line/Bar/Donut + RingGauge).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button { text: qsTr("Dashboard"); onClicked: page.openComp("DashboardPage") }
                Button { text: qsTr("LineChart"); onClicked: page.openComp("LineChartPage") }
                Button { text: qsTr("BarChart"); onClicked: page.openComp("BarChartPage") }
                Button { text: qsTr("DonutChart"); onClicked: page.openComp("DonutChartPage") }
                Button { text: qsTr("RingGauge"); onClicked: page.openComp("RingGaugePage") }
                Button { text: qsTr("KpiTile"); onClicked: page.openComp("KpiTilePage") }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Trend + columns (stable)")
        qmlSource: "LineChart { values: […] }\nBarChart { values: […]; unit: \" MB\" }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            LineChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                showArea: true
                values: page.lineA
            }
            BarChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                values: [18, 26, 22, 34, 40, 31, 28]
                unit: " MB"
                showValueLabels: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("Part-to-whole")
        qmlSource: "DonutChart { slices: […] }  // stable\nPieChart { values: […] }     // deferred 1.66"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            DonutChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                centerText: "72%"
                centerSubText: qsTr("Used")
                slices: [
                    { value: 42, label: qsTr("Apps"), color: Theme.accent },
                    { value: 18, label: qsTr("Media"), color: Theme.systemCaution },
                    { value: 12, label: qsTr("Docs"), color: Theme.systemSuccess }
                ]
            }
            PieChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                values: [50, 30, 20]
            }
        }
    }

    ControlExample {
        headerText: qsTr("Inline sparkline (deferred 1.66)")
        qmlSource: "Sparkline { values: […] }  // prefer KpiTile.trendValues"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Label { text: qsTr("Live"); color: Theme.textSecondary }
            Sparkline {
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                values: page.sparkData
            }
        }
    }
}
