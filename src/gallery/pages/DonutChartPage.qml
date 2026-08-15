import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    id: page
    padding: 0

    property var slices: [
        { value: 42, label: qsTr("Apps"), color: Theme.accent },
        { value: 24, label: qsTr("Media"), color: Theme.systemCaution },
        { value: 18, label: qsTr("Docs"), color: Theme.systemSuccess },
        { value: 16, label: qsTr("Other"), color: Theme.systemCritical }
    ]
    property string status: qsTr("Hover a slice or legend row")

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
                title: qsTr("DonutChart")
                subtitle: qsTr("Animated reveal, hover emphasis, and synchronized legend.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive donut")
                qmlSource: "DonutChart {\n    title: \"Capacity\"\n    interactive: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    DonutChart {
                        id: donut
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        title: qsTr("Capacity")
                        centerText: "100%"
                        centerSubText: qsTr("Total")
                        slices: page.slices
                        onSliceClicked: (index, value) => {
                            var label = page.slices[index].label
                            page.status = qsTr("Selected %1 (%2)").arg(label).arg(value)
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
                            onClicked: donut.playReveal()
                        }
                        Button {
                            text: qsTr("Shuffle")
                            onClicked: {
                                var next = []
                                for (var i = 0; i < page.slices.length; ++i) {
                                    var s = page.slices[i]
                                    next.push({
                                        value: 10 + Math.round(Math.random() * 40),
                                        label: s.label,
                                        color: s.color
                                    })
                                }
                                page.slices = next
                            }
                        }
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Compact ring")
                qmlSource: "DonutChart { showLegend: false; thickness: 10 }"
                DonutChart {
                    Layout.preferredWidth: 148
                    Layout.preferredHeight: 148
                    Layout.alignment: Qt.AlignHCenter
                    showLegend: false
                    thickness: 10
                    centerText: "68%"
                    centerSubText: qsTr("Used")
                    slices: [
                        { value: 68, color: Theme.accent },
                        { value: 32, color: Theme.strokeDivider }
                    ]
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
