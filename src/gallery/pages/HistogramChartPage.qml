import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — HistogramChart.

CatalogPage {
    id: page
    title: qsTr("HistogramChart")
    subtitle: qsTr("Experimental. Product apps: BarChart { samples; binCount } — docs/charts.md.")

    readonly property var samples: {
        var a = []
        for (var i = 0; i < 240; ++i)
            a.push(50 + Math.sin(i * 0.11) * 18 + ((i * 17) % 13) - 6)
        return a
    }

    ControlExample {
        headerText: qsTr("Latency distribution")
        qmlSource: "HistogramChart {\n    values: samples\n    binCount: 12\n}"
        HistogramChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 220
            title: qsTr("ms")
            values: page.samples
            binCount: 12
        }
    }
}
