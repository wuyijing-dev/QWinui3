import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    id: page
    padding: 0

    property string lastClick: qsTr("Click a bar")

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
                title: qsTr("BarChart")
                subtitle: qsTr("Gradient columns with title, valueUnit, and empty state.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive columns")
                qmlSource: "BarChart {\n    title: \"Monthly\"\n    valueUnit: \"k\"\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    BarChart {
                        id: bars
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        title: qsTr("Monthly")
                        interactive: true
                        valueUnit: "k"
                        values: [18, 26, 22, 34, 40, 31, 28, 36, 42, 38, 30, 24]
                        onBarClicked: (index, value) => {
                            page.lastClick = qsTr("Bar %1 → %2").arg(index + 1).arg(value)
                        }
                    }
                    RowLayout {
                        Label {
                            Layout.fillWidth: true
                            color: Theme.textSecondary
                            text: page.lastClick
                        }
                        Button {
                            text: qsTr("Replay")
                            onClicked: bars.playReveal()
                        }
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Always show values")
                qmlSource: "BarChart { showValueLabels: true }"
                BarChart {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    showValueLabels: true
                    maximum: 100
                    bars: [
                        { value: 72, color: Theme.accent },
                        { value: 48, color: Theme.systemSuccess },
                        { value: 91, color: Theme.systemCaution },
                        { value: 33, color: Theme.systemCritical },
                        { value: 60, color: Theme.accentLight1 },
                        { value: 55, color: Theme.accentDark1 }
                    ]
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
