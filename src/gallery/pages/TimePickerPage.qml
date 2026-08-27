import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TimePicker.
//
// Tumbler time + header / errorMessage. Recipe: docs/pickers.md

CatalogPage {
    title: qsTr("TimePicker")
    subtitle: qsTr("Clock tumblers + FormLayout errorMessage — docs/pickers.md.")

    ControlExample {
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
            RowLayout {
                Label { text: qsTr("ClockIdentifier"); color: Theme.textSecondary }
                ComboBox {
                    id: clockBox
                    model: ["12HourClock", "24HourClock"]
                    currentIndex: 0
                    Layout.preferredWidth: 160
                    onActivated: picker12.clockIdentifier = currentText
                }
            }
            Label {
                text: qsTr("Chosen: %1 · time %2 · %3")
                      .arg(picker12.displayText)
                      .arg(Qt.formatTime(picker12.time, "hh:mm"))
                      .arg(picker12.clockIdentifier)
                color: Theme.textSecondary
            }
        }
    }
    ControlExample {
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
}
