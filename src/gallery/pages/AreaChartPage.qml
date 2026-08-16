import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AreaChart.
//
// Filled areas with legend, hover crosshair, and stacked mode. API: docs/components/AreaChart.md

CatalogPage {
    id: page
    title: qsTr("AreaChart")
    subtitle: qsTr("Filled areas with legend, hover crosshair, and stacked mode.")

    readonly property var areaA: {
        var a = []
        for (var i = 0; i < 80; ++i)
            a.push(18 + Math.sin(i * 0.18) * 10 + 6)
        return a
    }
    readonly property var areaB: {
        var a = []
        for (var i = 0; i < 80; ++i)
            a.push(12 + Math.cos(i * 0.14) * 7 + 4)
        return a
    }
    readonly property var areaC: {
        var a = []
        for (var i = 0; i < 80; ++i)
            a.push(8 + Math.sin(i * 0.22) * 4 + 3)
        return a
    }

    ControlExample {
        headerText: qsTr("Interactive areas")
        qmlSource: "AreaChart {\n    title: \"Throughput\"\n    interactive: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            AreaChart {
                id: areas
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                title: qsTr("Throughput")
                showLegend: true
                interactive: true
                series: [
                    { name: qsTr("Inbound"), values: page.areaA, color: Theme.accent },
                    { name: qsTr("Outbound"), values: page.areaB, color: Theme.systemSuccess }
                ]
            }
            Button {
                text: qsTr("Replay reveal")
                onClicked: areas.playReveal()
            }
        }
    }

    ControlExample {
        headerText: qsTr("Stacked")
        qmlSource: "AreaChart { stacked: true }"
        AreaChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            stacked: true
            showLegend: true
            series: [
                { name: "A", values: page.areaA, color: Theme.accent },
                { name: "B", values: page.areaB, color: Theme.systemCaution },
                { name: "C", values: page.areaC, color: Theme.systemSuccess }
            ]
        }
    }
}
