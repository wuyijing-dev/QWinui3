import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    id: page
    padding: 0

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
                title: qsTr("Charts")
                subtitle: qsTr("WinUI-style Canvas charts. Open each control in the Charts category for focused demos.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Trend + columns")
                qmlSource: "LineChart / BarChart"
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
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Part-to-whole")
                qmlSource: "DonutChart / PieChart"
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
                        slices: [
                            { value: 50, label: qsTr("A"), color: Theme.accent },
                            { value: 30, label: qsTr("B"), color: Theme.systemSuccess },
                            { value: 20, label: qsTr("C"), color: Theme.systemCritical }
                        ]
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
