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
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Before copying a deferred chart page into product code, run the decision tree — stable six only in shipping UI. Dashboard layout demo is embedded below.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    DashboardPage { hubEmbed: true; width: parent.width }

    ControlExample {
        headerText: qsTr("Deferred chart demos (2.26)")
        qmlSource: "// Each deferred type — scroll for live demos\n// docs/charts.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Production dashboards stay on the stable six. Deferred siblings below are Gallery-only comparisons — use compose recipes in docs/charts.md for shipping UI.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    GalleryHubSection {
        title: qsTr("AreaChart")
        description: qsTr("Deferred filled area chart — prefer LineChart showArea in product.")
        AreaChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("Sparkline")
        description: qsTr("Deferred inline sparkline — prefer KpiTile.trendValues.")
        SparklinePage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("PieChart")
        description: qsTr("Deferred pie chart — prefer DonutChart in product.")
        PieChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("HorizontalBarChart")
        description: qsTr("Deferred horizontal bar chart demo.")
        HorizontalBarChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("StackedBarChart")
        description: qsTr("Deferred stacked columns — compose with LineChart showArea.")
        StackedBarChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("BulletChart")
        description: qsTr("Deferred bullet chart comparison demo.")
        BulletChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("WaterfallChart")
        description: qsTr("Deferred waterfall chart demo.")
        WaterfallChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("RadarChart")
        description: qsTr("Deferred radar / spider chart demo.")
        RadarChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("ScatterChart")
        description: qsTr("Deferred scatter plot demo.")
        ScatterChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("HeatmapChart")
        description: qsTr("Deferred heatmap chart demo.")
        HeatmapChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("ComboChart")
        description: qsTr("Deferred combo line + bar chart demo.")
        ComboChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("FunnelChart")
        description: qsTr("Deferred funnel chart demo.")
        FunnelChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("CandlestickChart")
        description: qsTr("Deferred candlestick chart demo.")
        CandlestickChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("HistogramChart")
        description: qsTr("Deferred histogram chart demo.")
        HistogramChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("BoxPlotChart")
        description: qsTr("Deferred box plot chart demo.")
        BoxPlotChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("ParetoChart")
        description: qsTr("Deferred Pareto chart demo.")
        ParetoChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("BandChart")
        description: qsTr("Deferred band chart demo.")
        BandChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("TreemapChart")
        description: qsTr("Deferred treemap chart demo.")
        TreemapChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("PolarAreaChart")
        description: qsTr("Deferred polar area chart demo.")
        PolarAreaChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("ViolinChart")
        description: qsTr("Deferred violin plot demo.")
        ViolinChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("ErrorBarChart")
        description: qsTr("Deferred error bar chart demo.")
        ErrorBarChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("WaffleChart")
        description: qsTr("Deferred waffle chart demo.")
        WaffleChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("LollipopChart")
        description: qsTr("Deferred lollipop chart demo.")
        LollipopChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("DumbbellChart")
        description: qsTr("Deferred dumbbell chart demo.")
        DumbbellChartPage { hubEmbed: true; width: parent.width }
    }
    GalleryHubSection {
        title: qsTr("SunburstChart")
        description: qsTr("Deferred sunburst chart demo.")
        SunburstChartPage { hubEmbed: true; width: parent.width }
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
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                text: qsTr("Compare with StackedBarChart deferred demo embedded above.")
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
                text: qsTr("Stable six is frozen — no new chart names in 2.08. Full stable demos: LineChart, BarChart, DonutChart, RingGauge, KpiTile, ChartCard — embedded below and in Gauges hub.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    GalleryHubSection {
        title: qsTr("LineChart")
        description: qsTr("Stable trend chart with area, legend, and interaction.")
        LineChartPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("BarChart")
        description: qsTr("Stable column chart with value labels.")
        BarChartPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("DonutChart")
        description: qsTr("Stable part-to-whole ring chart.")
        DonutChartPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ChartCard")
        description: qsTr("Elevated card chrome wrapping a chart.")
        ChartCardPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("RingGauge")
        description: qsTr("Stable radial gauge for KPI dashboards.")
        RingGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("KpiTile")
        description: qsTr("Stable KPI tile with delta and inline spark trend.")
        KpiTilePage { hubEmbed: true; width: parent.width }
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
