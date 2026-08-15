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
                title: qsTr("Timeline")
                subtitle: qsTr("Chronological events. Click a step to select (isInteractive).")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Activity")
                qmlSource: "Timeline {\n    isInteractive: true\n    onItemClicked: …\n}"
                Timeline {
                    id: timeline
                    Layout.fillWidth: true
                    Layout.maximumWidth: 420
                    currentIndex: stepSlider.value
                    isInteractive: true
                    onItemClicked: function (i) { stepSlider.value = i }
                    model: [
                        { time: "09:00", title: qsTr("Build started"), subtitle: qsTr("CI pipeline #4821"), color: Theme.accent },
                        { time: "09:04", title: qsTr("Tests passed"), subtitle: qsTr("128 / 128"), color: Theme.systemSuccess },
                        { time: "09:07", title: qsTr("Packaging"), subtitle: qsTr("Creating installer"), color: Theme.systemCaution },
                        { time: "09:12", title: qsTr("Published"), subtitle: qsTr("Release channel"), color: Theme.systemSuccess }
                    ]
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 420
                    Label { text: qsTr("Current step"); color: Theme.textSecondary }
                    Slider {
                        id: stepSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 3
                        stepSize: 1
                        value: 2
                        snapMode: Slider.SnapAlways
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
