import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CalendarView (2.31).
//
// Month grid with single / multiple / range selection. Recipe: docs/calendar-view.md

CatalogPage {
    id: page
    title: qsTr("CalendarView")
    subtitle: qsTr("Month grid for scheduling — single, multiple, range. Experimental — docs/calendar-view.md (2.31).")

    property string statusText: qsTr("Pick a mode and click days")

    ControlExample {
        headerText: qsTr("Why CalendarView (2.31)")
        qmlSource: "CalendarView { selectionMode: \"range\" }"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("CalendarDatePicker is a field + flyout. DatePicker uses tumblers. CalendarView is an always-visible month grid for booking, PTO, and room schedules. For raw MonthGrid styling, see Calendar page.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Selection modes")
        qmlSource: "CalendarView {\n    selectionMode: \"single\" | \"multiple\" | \"range\"\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Label { text: qsTr("Mode"); color: Theme.textSecondary }
                ComboBox {
                    id: modeBox
                    Layout.preferredWidth: 180
                    model: ["single", "multiple", "range"]
                    currentIndex: 0
                    onActivated: {
                        demoCal.clearSelection()
                        demoCal.selectionMode = currentText
                        page.statusText = qsTr("Mode: %1").arg(currentText)
                    }
                }
                Button {
                    text: qsTr("Clear")
                    onClicked: demoCal.clearSelection()
                }
            }

            CalendarView {
                id: demoCal
                Layout.fillWidth: true
                Layout.maximumWidth: 320
                accessibleName: qsTr("Booking calendar")
                selectionMode: modeBox.currentText
                hasMinDate: true
                minDate: new Date(2020, 0, 1)
                hasMaxDate: true
                maxDate: new Date(2030, 11, 31)
                onSelectionChanged: page._refreshStatus()
                onDateClicked: function (d) {
                    page.statusText = qsTr("Clicked %1").arg(Qt.formatDate(d, Qt.DefaultLocaleLongDate))
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: page.statusText
            }
        }
    }

    function _refreshStatus() {
        if (demoCal.selectionMode === "single") {
            statusText = isNaN(demoCal.selectedDate.getTime())
                     ? qsTr("No date selected")
                     : qsTr("Selected: %1").arg(Qt.formatDate(demoCal.selectedDate, Qt.DefaultLocaleLongDate))
        } else if (demoCal.selectionMode === "multiple") {
            statusText = qsTr("%1 dates selected").arg((demoCal.selectedDates || []).length)
        } else {
            if (isNaN(demoCal.rangeStart.getTime()))
                statusText = qsTr("Click start of range")
            else if (sameDay(demoCal.rangeStart, demoCal.rangeEnd))
                statusText = qsTr("Range start: %1 — click end")
                    .arg(Qt.formatDate(demoCal.rangeStart, Qt.DefaultLocaleLongDate))
            else
                statusText = qsTr("Range: %1 → %2")
                    .arg(Qt.formatDate(demoCal.rangeStart, Qt.DefaultLocaleShortDate))
                    .arg(Qt.formatDate(demoCal.rangeEnd, Qt.DefaultLocaleShortDate))
        }
    }

    function sameDay(a, b) {
        return a.getFullYear() === b.getFullYear()
            && a.getMonth() === b.getMonth()
            && a.getDate() === b.getDate()
    }

    Component.onCompleted: _refreshStatus()
}
