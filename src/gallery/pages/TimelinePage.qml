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
                subtitle: qsTr("Chronological events with selectedIndex, symbol nodes, and keyboard nav.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Activity")
                qmlSource: "Timeline {\n    selectedIndex: 1\n    model: [{ symbol: FluentIcons.Play, … }]\n}"
                Timeline {
                    id: timeline
                    Layout.fillWidth: true
                    Layout.maximumWidth: 420
                    selectedIndex: stepSlider.value
                    isInteractive: true
                    onItemClicked: function (i) { stepSlider.value = i }
                    model: [
                        {
                            time: "09:00",
                            title: qsTr("Build started"),
                            subtitle: qsTr("CI pipeline #4821"),
                            symbol: FluentIcons.Play,
                            color: Theme.accent
                        },
                        {
                            time: "09:04",
                            title: qsTr("Tests passed"),
                            subtitle: qsTr("128 / 128"),
                            symbol: FluentIcons.Accept,
                            color: Theme.systemSuccess
                        },
                        {
                            time: "09:07",
                            title: qsTr("Packaging"),
                            subtitle: qsTr("Creating installer"),
                            symbol: FluentIcons.Warning,
                            color: Theme.systemCaution
                        },
                        {
                            time: "09:12",
                            title: qsTr("Published"),
                            subtitle: qsTr("Release channel"),
                            symbol: FluentIcons.Accept,
                            color: Theme.systemSuccess
                        }
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
                        value: 1
                    }
                    Button { text: qsTr("Prev"); onClicked: timeline.previous() }
                    Button { text: qsTr("Next"); onClicked: timeline.next() }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
