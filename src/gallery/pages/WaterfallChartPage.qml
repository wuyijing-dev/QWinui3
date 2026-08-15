import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — WaterfallChart.
//
// Cumulative bridge with title, valueUnit, and empty state. API: docs/components/WaterfallChart.md

Page {
    id: page
    padding: 0
    property string status: qsTr("Hover a step")

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
                title: qsTr("WaterfallChart")
                subtitle: qsTr("Cumulative bridge with title, valueUnit, and empty state.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("P&L bridge")
                qmlSource: "WaterfallChart {\n    title: \"P&L\"\n    valueUnit: \"k\"\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    WaterfallChart {
                        id: water
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260
                        title: qsTr("P&L")
                        valueUnit: "k"
                        steps: [
                            { value: 40, label: qsTr("Start") },
                            { value: 18, label: qsTr("Sales") },
                            { value: -8, label: qsTr("Cost") },
                            { value: 12, label: qsTr("Upsell") },
                            { value: -6, label: qsTr("Refund") },
                            { value: 5, label: qsTr("Other") }
                        ]
                        onStepClicked: (index, value) => {
                            page.status = qsTr("Step %1 → %2").arg(index + 1).arg(value)
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
                            onClicked: water.playReveal()
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
