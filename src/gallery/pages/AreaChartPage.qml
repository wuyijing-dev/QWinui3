import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    id: page
    padding: 0

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

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("AreaChart")
                subtitle: qsTr("Filled areas with legend, hover crosshair, and stacked mode.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
