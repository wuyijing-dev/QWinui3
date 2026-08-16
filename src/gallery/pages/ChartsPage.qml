import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Charts.
//
// WinUI-style Canvas charts. Open each control in the Charts category for focused demos.
// API naming recipe: docs/charts.md (1.11).

CatalogPage {
    id: page
    title: qsTr("Charts")
    subtitle: qsTr("Canvas charts & gauges. Naming recipe: docs/charts.md — prefer series/values/slices, unit, interactive.")

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
        headerText: qsTr("API consistency (1.11)")
        qmlSource: "// Prefer: series / values / slices\n// unit (== valueUnit), interactive (== isInteractive)\n// See docs/charts.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("High-traffic charts share one naming story: series or values for trends, values or bars for columns, slices (or values) for part-to-whole, unit on gauges and bar labels, interactive on both charts and gauges.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Trend + columns")
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
        qmlSource: "DonutChart { slices: […] }\nPieChart { values: [50, 30, 20] }"
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
                // Convenience values (1.11) — same as slices without labels
                values: [50, 30, 20]
            }
        }
    }

    ControlExample {
        headerText: qsTr("Inline sparkline")
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
