import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    id: page
    padding: 0
    property string status: qsTr("Hover a slice")

    property var slices: [
        { value: 36, label: qsTr("Compute"), color: Theme.accent },
        { value: 28, label: qsTr("Storage"), color: Theme.systemSuccess },
        { value: 20, label: qsTr("Network"), color: Theme.systemCaution },
        { value: 16, label: qsTr("Other"), color: Theme.systemCritical }
    ]

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
                title: qsTr("PieChart")
                subtitle: qsTr("Interactive pie with title, selectedIndex, and synchronized legend.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Workload mix")
                qmlSource: "PieChart {\n    title: \"Workload\"\n    interactive: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    PieChart {
                        id: pie
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        title: qsTr("Workload")
                        slices: page.slices
                        onSliceClicked: (index, value) => {
                            page.status = qsTr("%1 → %2").arg(page.slices[index].label).arg(value)
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
                            onClicked: pie.playReveal()
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
