import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    id: page
    padding: 0

    property real gaugeValue: 64
    property var spark: {
        var a = []
        for (var i = 0; i < 36; ++i)
            a.push(40 + Math.sin(i * 0.35) * 12)
        return a
    }

    Timer {
        interval: 1200
        running: page.visible
        repeat: true
        onTriggered: page.gaugeValue = 35 + Math.round(Math.random() * 55)
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
                title: qsTr("ChartCard")
                subtitle: qsTr("Dashboard chrome with ElevatedChrome, symbol, footer, and entrance motion.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Dashboard cards")
                qmlSource: "ChartCard {\n    title: …\n    elevated: true\n    footer: \"Updated just now\"\n}"
                GridLayout {
                    Layout.fillWidth: true
                    columns: width > 700 ? 2 : 1
                    rowSpacing: Theme.spacingLoose
                    columnSpacing: Theme.spacingLoose

                    ChartCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260
                        title: qsTr("Throughput")
                        subtitle: qsTr("Requests / min")
                        symbol: FluentIcons.Play
                        footer: qsTr("Updated just now")
                        elevated: true
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 8
                            LineChart {
                                id: cardLine
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                showLegend: false
                                values: page.spark
                            }
                            Button {
                                text: qsTr("Replay")
                                onClicked: cardLine.playReveal()
                            }
                        }
                    }

                    ChartCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                        title: qsTr("Capacity")
                        subtitle: qsTr("Live gauge")
                        footer: qsTr("%1% utilized").arg(Math.round(page.gaugeValue))
                        RadialGauge {
                            anchors.centerIn: parent
                            width: 150
                            height: 150
                            value: page.gaugeValue
                            unit: "%"
                            showNeedle: true
                        }
                    }

                    ChartCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        Layout.columnSpan: parent.columns
                        title: qsTr("Storage mix")
                        subtitle: qsTr("Interactive meter")
                        MeterBar {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            maximum: 100
                            showLegend: true
                            trackHeight: 12
                            segments: [
                                { value: 42, color: Theme.accent, label: qsTr("Apps") },
                                { value: 18, color: Theme.systemCaution, label: qsTr("Media") },
                                { value: 12, color: Theme.systemSuccess, label: qsTr("Docs") }
                            ]
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
