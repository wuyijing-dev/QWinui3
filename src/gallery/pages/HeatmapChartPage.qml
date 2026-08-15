import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    id: page
    padding: 0

    property string status: qsTr("Hover a cell")
    readonly property var matrix: {
        var rows = []
        for (var r = 0; r < 6; ++r) {
            var row = []
            for (var c = 0; c < 8; ++c)
                row.push(Math.round(20 + Math.sin(r * 0.9 + c * 0.55) * 30 + c * 4 + r * 3))
            rows.push(row)
        }
        return rows
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
                title: qsTr("HeatmapChart")
                subtitle: qsTr("Density grid with title, empty state, and hover readout.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Activity matrix")
                qmlSource: "HeatmapChart {\n    title: \"Week\"\n    values: matrix\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    HeatmapChart {
                        id: heat
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                        title: qsTr("Week")
                        values: page.matrix
                        rowLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                        columnLabels: ["0", "3", "6", "9", "12", "15", "18", "21"]
                        onCellClicked: (row, col, value) => {
                            page.status = qsTr("Cell [%1,%2] = %3").arg(row).arg(col).arg(value)
                        }
                    }
                    RowLayout {
                        Label {
                            Layout.fillWidth: true
                            color: Theme.textSecondary
                            text: page.status
                        }
                        Button {
                            text: qsTr("Replay")
                            onClicked: heat.playReveal()
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
