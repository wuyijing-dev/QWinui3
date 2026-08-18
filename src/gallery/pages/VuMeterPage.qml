import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — VuMeter.

CatalogPage {
    id: page
    title: qsTr("VuMeter")
    subtitle: qsTr("Experimental LED / peak-hold meter. Prefer LinearGauge for analog tracks.")

    property real level: 0.42

    Timer {
        interval: 80
        running: page.visible
        repeat: true
        onTriggered: page.level = Math.max(0.05, Math.min(1, page.level + (Math.random() - 0.46) * 0.18))
    }

    ControlExample {
        headerText: qsTr("Peak hold")
        qmlSource: "VuMeter {\n    value: 0.7\n    peakHold: true\n}"
        RowLayout {
            spacing: Theme.spacingSection
            VuMeter {
                title: qsTr("L")
                value: page.level
                unit: "%"
                peakHold: true
            }
            VuMeter {
                title: qsTr("R")
                value: Math.max(0, page.level - 0.08)
                unit: "%"
                peakHold: true
            }
            VuMeter {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                orientation: Qt.Horizontal
                title: qsTr("Master")
                value: page.level
                segmentCount: 24
                isInteractive: true
            }
        }
    }
}
