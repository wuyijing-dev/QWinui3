import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
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
                title: qsTr("SegmentedControl")
                subtitle: qsTr("Exclusive segmented options. Supports equalWidth/stretch and disabled items.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Basic")
                qmlSource: "SegmentedControl {\n    equalWidth: true\n    model: [\"Day\", \"Week\", \"Month\"]\n}"
                SegmentedControl {
                    Layout.fillWidth: true
                    stretch: true
                    model: [qsTr("Day"), qsTr("Week"), qsTr("Month")]
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("With icons")
                qmlSource: "SegmentedControl {\n    model: [{ text: \"List\", icon: \"\\uE8FD\" }, ...]\n}"
                SegmentedControl {
                    model: [
                        { text: qsTr("List"), icon: "\uE8FD" },
                        { text: qsTr("Grid"), icon: "\uE8A5" },
                        { text: qsTr("Map"), icon: "\uE707", enabled: false }
                    ]
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
