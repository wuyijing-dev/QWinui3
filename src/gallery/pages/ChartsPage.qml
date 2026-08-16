import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Charts.
//
// WinUI-style Canvas charts. Open each control in the Charts category for focused demos.
// Stable subset + naming: docs/charts.md (1.23).

CatalogPage {
    id: page
    title: qsTr("Charts")
    subtitle: qsTr("Stable (1.23): LineChart, BarChart, DonutChart, RingGauge, KpiTile, ChartCard — docs/charts.md.")

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

    ControlExample {
        headerText: qsTr("Stable subset (1.23)")
        qmlSource: "// Stable: LineChart, BarChart, DonutChart,\n//          RingGauge, KpiTile, ChartCard\n// docs/charts.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Production dashboards should prefer the stable six above. Area/Pie/Arc/Radar and other gauges remain experimental. Naming still uses series/values/slices, unit, and interactive (see 1.11 aliases).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("examples/dashboard uses only stable types (KpiTile + ChartCard + LineChart + RingGauge).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
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
        qmlSource: "DonutChart { slices: […] }  // stable\nPieChart { values: […] }     // experimental"
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
                // Convenience values (1.11) — experimental sibling of Donut
                values: [50, 30, 20]
            }
        }
    }

    ControlExample {
        headerText: qsTr("Inline sparkline (experimental)")
        qmlSource: "Sparkline { values: […] }"
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
