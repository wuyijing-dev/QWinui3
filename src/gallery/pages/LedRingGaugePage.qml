import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    id: page
    title: qsTr("LedRingGauge")
    subtitle: qsTr("Experimental circular LED / peak-hold. Prefer VuMeter for a linear stack.")

    property real level: 0.55

    Timer {
        interval: 90
        running: page.visible
        repeat: true
        onTriggered: page.level = Math.max(0.05, Math.min(1, page.level + (Math.random() - 0.46) * 0.16))
    }

    ControlExample {
        headerText: qsTr("Signal")
        qmlSource: "LedRingGauge { value: 0.7; peakHold: true }"
        LedRingGauge {
            title: qsTr("RF")
            value: page.level
            peakHold: true
            isInteractive: true
        }
    }
}
