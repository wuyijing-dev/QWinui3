import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Charts hub (1.23 stable six / 2.08 compose / 2.26 recipe wave).
// Recipe: docs/charts.md · examples/dashboard

CatalogPage {
    id: page
    title: qsTr("Charts")
    subtitle: qsTr("Stable six frozen. Compose decision 2.48 + deferred chooser (2.26). docs/charts.md")
    property bool deferredChartsReady: false

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
    readonly property var areaB: {
        var a = []
        for (var j = 0; j < 60; ++j)
            a.push(18 + Math.cos(j * 0.12) * 8)
        return a
    }

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    Component.onCompleted: Qt.callLater(function () {
        if (page)
            page.deferredChartsReady = true
    })

    ControlExample {
        headerText: qsTr("Chart perf budgets (2.49 / wave 8)")
        qmlSource: "// revealAnimationPointBudget: 500\n// docs/perf-signoff-2xx.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Tranche-1 sign-off: cap points per series (~500), coalesced redraws, one chart per ChartCard. docs/performance.md wave 8.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Compose decision (2.48 / FL-009)")
        qmlSource: "docs/dashboard-compose-decision.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Before copying a deferred chart page into product code, run the decision tree — stable six only in shipping UI. Pair with Dashboard stable layout and examples/dashboard.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Button {
                text: qsTr("Open Dashboard")
                onClicked: page.openComp("DashboardPage")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Deferred sibling chooser (2.26)")
        qmlSource: "// Each deferred type → compose path or Gallery-only\n// docs/charts.md Recipe wave (2.26)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Production dashboards stay on the stable six. Open a deferred demo to compare, or copy the compose path. Radar / Scatter / Heatmap remain Gallery-only.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Repeater {
                model: [
                    {
                        deferred: qsTr("AreaChart"),
                        compose: qsTr("LineChart { showArea: true }"),
                        page: "AreaChartPage",
                        stable: "LineChartPage"
                    },
                    {
                        deferred: qsTr("Sparkline"),
                        compose: qsTr("KpiTile.trendValues"),
                        page: "SparklinePage",
                        stable: "KpiTilePage"
                    },
                    {
                        deferred: qsTr("PieChart"),
                        compose: qsTr("DonutChart"),
                        page: "PieChartPage",
                        stable: "DonutChartPage"
                    },
                    {
                        deferred: qsTr("StackedBarChart"),
                        compose: qsTr("LineChart stacked areas"),
                        page: "StackedBarChartPage",
                        stable: ""
                    },
                    {
                        deferred: qsTr("HorizontalBarChart"),
                        compose: qsTr("BarChart { bars: [...] }"),
                        page: "HorizontalBarChartPage",
                        stable: "BarChartPage"
                    },
                    {
                        deferred: qsTr("BulletChart"),
                        compose: qsTr("KpiTile + thresholds"),
                        page: "BulletChartPage",
                        stable: "KpiTilePage"
                    },
                    {
                        deferred: qsTr("WaterfallChart"),
                        compose: qsTr("BarChart bridge or Gallery"),
                        page: "WaterfallChartPage",
                        stable: ""
                    },
                    {
                        deferred: qsTr("RadarChart"),
                        compose: qsTr("Gallery-only"),
                        page: "RadarChartPage",
                        stable: ""
                    },
                    {
                        deferred: qsTr("ScatterChart"),
                        compose: qsTr("Gallery-only"),
                        page: "ScatterChartPage",
                        stable: ""
                    },
                    {
                        deferred: qsTr("HeatmapChart"),
                        compose: qsTr("Gallery-only"),
                        page: "HeatmapChartPage",
                        stable: ""
                    }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label {
                        Layout.preferredWidth: 140
                        text: modelData.deferred
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        text: modelData.compose
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                    }
                    Button {
                        text: qsTr("Deferred")
                        flat: true
                        onClicked: page.openComp(modelData.page)
                    }
                    Button {
                        visible: modelData.stable.length > 0
                        text: qsTr("Stable")
                        flat: true
                        onClicked: page.openComp(modelData.stable)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Stacked columns compose (2.26)")
        qmlSource: "LineChart { showArea: true; series: [Apps, Media] }  // not StackedBarChart"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("StackedBarChart → multi-series LineChart with showArea. Same weekly mix as StackedBarChart page — stable path for composition dashboards.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            LineChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                showArea: true
                showLegend: true
                series: [
                    { name: qsTr("Apps"), color: Theme.accent, values: [12, 14, 10, 16, 18, 15, 13] },
                    { name: qsTr("Media"), color: Theme.systemCaution, values: [8, 6, 9, 7, 5, 8, 10] },
                    { name: qsTr("Docs"), color: Theme.systemSuccess, values: [5, 7, 6, 4, 8, 6, 5] }
                ]
            }
            RowLayout {
                Button {
                    flat: true
                    text: qsTr("Compare StackedBarChart (deferred)")
                    onClicked: page.openComp("StackedBarChartPage")
                }
                Button {
                    flat: true
                    text: qsTr("Ranked BarChart compose")
                    onClicked: page.openComp("BarChartPage")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Compose recipes (2.08)")
        qmlSource: "// AreaChart → LineChart { showArea: true }\n// Sparkline → KpiTile.trendValues\n// docs/charts.md"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Production dashboards use the stable six only. These recipes replace deferred siblings without new stable names. Copy examples/dashboard for the full layout.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                text: qsTr("Filled trend — prefer LineChart showArea (not AreaChart)")
            }
            LineChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                showArea: true
                showLegend: true
                series: [
                    { name: qsTr("In"), color: Theme.accent, values: page.lineA },
                    { name: qsTr("Out"), color: Theme.systemCaution, values: page.areaB }
                ]
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                text: qsTr("Inline trend — prefer KpiTile.trendValues (not Sparkline)")
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingLoose
                KpiTile {
                    Layout.fillWidth: true
                    title: qsTr("CPU")
                    value: 64
                    unit: "%"
                    delta: 1.2
                    trendValues: page.sparkData
                }
                LineChart {
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 36
                    showLegend: false
                    showGrid: false
                    showArea: false
                    interactive: false
                    values: page.sparkData
                }
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                text: qsTr("Right: compact LineChart for table rows. Left: KpiTile for dashboard KPIs.")
            }
            Button {
                flat: true
                text: qsTr("Open Dashboard page")
                onClicked: page.openComp("DashboardPage")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Performance (1.89)")
        qmlSource: "// revealAnimationPointBudget: 500\n// redrawCoalesceMs: 16\n// docs/performance.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Stable Line/Bar/Donut charts coalesce canvas repaints (~16 ms) and skip reveal animation above ~500 points. ElevatedChrome defers MultiEffect one frame. Deferred Pie/Sparkline below load after first paint.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Stable vs deferred (permanent defer 2.08)")
        qmlSource: "// Stable: LineChart, BarChart, DonutChart,\n//          RingGauge, KpiTile, ChartCard\n// Deferred: Gallery demos only\n// docs/charts.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Stable six is frozen — no new chart names in 2.08. Sibling gauges (Tank, Thermometer, Arc, …) are permanently deferred; product apps use RingGauge. PieChart → DonutChart; extra niche charts stay Gallery-only.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
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
        qmlSource: "DonutChart { slices: […] }  // stable\nPieChart { values: […] }     // deferred — use Donut"
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
            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                active: page.deferredChartsReady
                sourceComponent: pieComp
            }
        }
    }

    Component {
        id: pieComp
        ColumnLayout {
            anchors.fill: parent
            spacing: 2
            Label {
                text: qsTr("PieChart (Gallery only)")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            PieChart {
                Layout.fillWidth: true
                Layout.fillHeight: true
                values: [50, 30, 20]
            }
        }
    }

    ControlExample {
        headerText: qsTr("Deferred Sparkline (Gallery only)")
        qmlSource: "// Prefer KpiTile.trendValues — compose recipe above"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Sparkline remains a Gallery demo. Product inline trends: KpiTile.trendValues or compact LineChart (see compose recipes).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                active: page.deferredChartsReady
                sourceComponent: sparkComp
            }
        }
    }

    Component {
        id: sparkComp
        Sparkline {
            anchors.fill: parent
            values: page.sparkData
        }
    }
}
