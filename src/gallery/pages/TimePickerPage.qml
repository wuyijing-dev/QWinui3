import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TimePicker.
//
// Fluent Clock icon, minuteIncrement, and Accessible time value. API: docs/components/TimePicker.md

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
                title: qsTr("TimePicker")
                subtitle: qsTr("Fluent Clock icon, minuteIncrement, and Accessible time value.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("12-hour")
                qmlSource: "TimePicker {\n    header: \"Arrival\"\n    minuteIncrement: 5\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    RowLayout {
                        Label { text: qsTr("Minute step"); color: Theme.textSecondary }
                        ComboBox {
                            id: stepBox
                            model: [1, 5, 15]
                            currentIndex: 1
                            Layout.preferredWidth: 80
                        }
                    }
                    TimePicker {
                        id: picker12
                        header: qsTr("Arrival")
                        hour: 9
                        minute: 30
                        isAm: true
                        minuteIncrement: Number(stepBox.currentText)
                    }
                    Label {
                        text: qsTr("Chosen: %1 (%2)").arg(picker12.displayText).arg(picker12.clockIdentifier)
                        color: Theme.textSecondary
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("24-hour")
                qmlSource: "TimePicker { use24Hour: true }"
                TimePicker {
                    header: qsTr("Departure")
                    hour: 14
                    minute: 5
                    use24Hour: true
                    minuteIncrement: 5
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
