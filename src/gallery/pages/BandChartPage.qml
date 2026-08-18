import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — BandChart.

CatalogPage {
    id: page
    title: qsTr("BandChart")
    subtitle: qsTr("Experimental high/low envelope with a mid line. Prefer LineChart.showArea for one series.")

    readonly property var high: {
        var a = []
        for (var i = 0; i < 24; ++i)
            a.push(48 + Math.sin(i * 0.35) * 8 + 6)
        return a
    }
    readonly property var low: {
        var a = []
        for (var i = 0; i < 24; ++i)
            a.push(48 + Math.sin(i * 0.35) * 8 - 7)
        return a
    }
    readonly property var mid: {
        var a = []
        for (var i = 0; i < 24; ++i)
            a.push(48 + Math.sin(i * 0.35) * 8)
        return a
    }

    ControlExample {
        headerText: qsTr("Forecast band")
        qmlSource: "BandChart {\n    high: hi; low: lo; mid: mid\n}"
        BandChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 220
            title: qsTr("Load")
            high: page.high
            low: page.low
            mid: page.mid
            xAxisLabels: ["0h", "6h", "12h", "18h"]
        }
    }
}
