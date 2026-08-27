import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CalendarDatePicker.
//
// Calendar flyout + header / errorMessage. Recipe: docs/pickers.md

CatalogPage {
    title: qsTr("CalendarDatePicker")
    subtitle: qsTr("MonthGrid flyout + FormLayout errorMessage — docs/pickers.md.")

    ControlExample {
        headerText: qsTr("Select a date")
        qmlSource: "CalendarDatePicker {\n    header: \"Start date\"\n    isOpen: false\n}"
        ColumnLayout {
            spacing: Theme.spacing
            CalendarDatePicker {
                id: picker
                Layout.preferredWidth: 240
                header: qsTr("Start date")
                showTodayButton: true
                hasMinDate: true
                minDate: new Date(2020, 0, 1)
                hasMaxDate: true
                maxDate: new Date(2030, 11, 31)
                firstDayOfWeek: weekStart.currentValue
                onDateChosen: function (d) {
                    chosenLabel.text = qsTr("Chosen: %1").arg(Qt.formatDate(d, Qt.DefaultLocaleLongDate))
                }
            }
            RowLayout {
                Label { text: qsTr("FirstDayOfWeek"); color: Theme.textSecondary }
                ComboBox {
                    id: weekStart
                    Layout.preferredWidth: 160
                    textRole: "label"
                    valueRole: "value"
                    model: [
                        { label: qsTr("System"), value: -1 },
                        { label: qsTr("Sunday"), value: Qt.Sunday },
                        { label: qsTr("Monday"), value: Qt.Monday },
                        { label: qsTr("Saturday"), value: Qt.Saturday }
                    ]
                    currentIndex: 0
                }
            }
            Label {
                text: qsTr("Selected: %1 · date alias %2 · open %3")
                      .arg(Qt.formatDate(picker.selectedDate, Qt.DefaultLocaleLongDate))
                      .arg(Qt.formatDate(picker.date, "yyyy-MM-dd"))
                      .arg(picker.isCalendarOpen)
                color: Theme.textSecondary
            }
            Label {
                id: chosenLabel
                text: qsTr("Waiting for dateChosen…")
                color: Theme.textSecondary
            }
        }
    }
}
