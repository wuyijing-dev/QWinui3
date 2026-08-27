import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

// Gallery — CandlestickChart.

CatalogPage {
    title: qsTr("CandlestickChart")
    subtitle: qsTr("Experimental OHLC candles. ChartSeries is Y-only — pass {o,h,l,c} objects.")

    ControlExample {
        headerText: qsTr("Session candles")
        qmlSource: "CandlestickChart {\n    candles: [{ o: 100, h: 112, l: 96, c: 108 }]\n}"
        CandlestickChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 240
            title: qsTr("Index")
            candles: [
                { o: 100, h: 108, l: 97, c: 105, v: 12 },
                { o: 105, h: 107, l: 101, c: 102, v: 9 },
                { o: 102, h: 110, l: 100, c: 109, v: 18 },
                { o: 109, h: 112, l: 104, c: 106, v: 11 },
                { o: 106, h: 111, l: 103, c: 110, v: 14 },
                { o: 110, h: 118, l: 109, c: 117, v: 22 },
                { o: 117, h: 119, l: 112, c: 113, v: 16 },
                { o: 113, h: 116, l: 108, c: 109, v: 10 }
            ]
        }
    }
}
