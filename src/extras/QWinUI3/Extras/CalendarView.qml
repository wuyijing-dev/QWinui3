import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// CalendarView — month grid for scheduling / booking surfaces (2.31).
//
//   CalendarView {
//       selectionMode: "single"   // single | multiple | range
//       selectedDate: new Date()
//   }
//
//   // --- API ---
//   // properties: month, year, selectionMode, selectedDate, selectedDates,
//   //             rangeStart, rangeEnd, firstDayOfWeek, minDate, maxDate,
//   //             showTodayButton, accessibleName, announceChanges
//   // signals: dateClicked(date), selectionChanged()
//   // methods: isDateAllowed(d), clearSelection(), goToToday()
//
// @notes
//   Distinct from CalendarDatePicker (field + flyout) and DatePicker (tumblers).
//   Composes MonthGrid + DayOfWeekRow. Experimental — see docs/calendar-view.md.

T.Control {
    id: root

    property int month: (new Date()).getMonth()
    property int year: (new Date()).getFullYear()
    property string selectionMode: "single"
    property date selectedDate: new Date()
    property var selectedDates: []
    property date rangeStart: new Date(NaN)
    property date rangeEnd: new Date(NaN)
    property int firstDayOfWeek: -1
    property date minDate
    property date maxDate
    // Dates that cannot be selected — Date[] or ISO strings (2.69 D5)
    property var blackoutDates: []
    // Optional predicate (date) → bool; return false to black out
    property var blackoutFilter: null
    property bool hasMinDate: false
    property bool hasMaxDate: false
    property bool showTodayButton: true
    property bool showNavigation: true
    property string accessibleName: qsTr("Calendar")
    property bool announceChanges: true

    signal dateClicked(date date)
    signal selectionChanged()

    property int _rangePass: 0

    readonly property var calendarLocale: {
        if (firstDayOfWeek < 0)
            return Qt.locale()
        var candidates = ["en_US", "en_GB", "de_DE", "fr_FR", "zh_CN", "ja_JP", "ar_SA", "he_IL"]
        for (var i = 0; i < candidates.length; ++i) {
            var loc = Qt.locale(candidates[i])
            if (loc.firstDayOfWeek === firstDayOfWeek)
                return loc
        }
        return Qt.locale()
    }

    implicitWidth: 320
    implicitHeight: contentItem.implicitHeight
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true

    Accessible.role: Accessible.Table
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Calendar")
    Accessible.description: grid.locale.standaloneMonthName(month + 1) + " " + year

    function _announce(text) {
        if (!root.announceChanges || !text || text.length === 0)
            return
        if (typeof Accessible.announce === "function")
            Accessible.announce(text)
    }

    function _dayTime(d) {
        return new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime()
    }

    function sameDay(a, b) {
        if (isNaN(a.getTime()) || isNaN(b.getTime()))
            return false
        return a.getFullYear() === b.getFullYear()
            && a.getMonth() === b.getMonth()
            && a.getDate() === b.getDate()
    }

    function isDateAllowed(d) {
        var day = new Date(d.getFullYear(), d.getMonth(), d.getDate())
        if (hasMinDate) {
            var min = new Date(minDate.getFullYear(), minDate.getMonth(), minDate.getDate())
            if (day < min)
                return false
        }
        if (hasMaxDate) {
            var max = new Date(maxDate.getFullYear(), maxDate.getMonth(), maxDate.getDate())
            if (day > max)
                return false
        }
        if (typeof blackoutFilter === "function") {
            try {
                if (!blackoutFilter(day))
                    return false
            } catch (e) { /* ignore */ }
        }
        var list = blackoutDates || []
        for (var i = 0; i < list.length; ++i) {
            var b = list[i]
            var bd = (b instanceof Date) ? b : new Date(b)
            if (!isNaN(bd.getTime()) && sameDay(day, bd))
                return false
        }
        return true
    }

    function clearSelection() {
        selectedDate = new Date(NaN)
        selectedDates = []
        rangeStart = new Date(NaN)
        rangeEnd = new Date(NaN)
        _rangePass = 0
        grid.selectedDate = selectedDate
        grid.selectedDates = selectedDates
        grid.rangeStart = rangeStart
        grid.rangeEnd = rangeEnd
        selectionChanged()
        _announce(qsTr("Selection cleared"))
    }

    function goToToday() {
        var today = new Date()
        if (!isDateAllowed(today))
            return
        month = today.getMonth()
        year = today.getFullYear()
        _announce(qsTr("Showing %1").arg(Qt.formatDate(today, Qt.DefaultLocaleLongDate)))
    }

    function goToMonth(m, y) {
        month = m
        year = y
    }

    function _syncGridSelection() {
        grid.selectionMode = selectionMode
        grid.selectedDate = selectedDate
        grid.selectedDates = selectedDates
        grid.rangeStart = rangeStart
        grid.rangeEnd = rangeEnd
    }

    function _handleDateClick(date) {
        if (!isDateAllowed(date))
            return
        dateClicked(date)
        if (selectionMode === "single") {
            selectedDate = date
            _syncGridSelection()
            selectionChanged()
            _announce(Qt.formatDate(date, Qt.DefaultLocaleLongDate))
            return
        }
        if (selectionMode === "multiple") {
            var next = (selectedDates || []).slice()
            var found = -1
            for (var i = 0; i < next.length; ++i) {
                if (sameDay(next[i], date)) {
                    found = i
                    break
                }
            }
            if (found >= 0)
                next.splice(found, 1)
            else
                next.push(new Date(date.getTime()))
            selectedDates = next
            _syncGridSelection()
            selectionChanged()
            _announce(qsTr("%1 dates selected").arg(next.length))
            return
        }
        if (selectionMode === "range") {
            if (_rangePass === 0 || isNaN(rangeStart.getTime())) {
                rangeStart = date
                rangeEnd = date
                _rangePass = 1
            } else {
                rangeEnd = date
                if (_dayTime(rangeEnd) < _dayTime(rangeStart)) {
                    var tmp = rangeStart
                    rangeStart = rangeEnd
                    rangeEnd = tmp
                }
                _rangePass = 0
            }
            _syncGridSelection()
            selectionChanged()
            if (!isNaN(rangeStart.getTime()) && !isNaN(rangeEnd.getTime())
                    && !sameDay(rangeStart, rangeEnd)) {
                _announce(qsTr("Range %1 to %2")
                           .arg(Qt.formatDate(rangeStart, Qt.DefaultLocaleShortDate))
                           .arg(Qt.formatDate(rangeEnd, Qt.DefaultLocaleShortDate)))
            } else {
                _announce(Qt.formatDate(date, Qt.DefaultLocaleLongDate))
            }
        }
    }

    onSelectionModeChanged: _syncGridSelection()
    onSelectedDateChanged: _syncGridSelection()
    onSelectedDatesChanged: _syncGridSelection()
    onRangeStartChanged: _syncGridSelection()
    onRangeEndChanged: _syncGridSelection()
    Component.onCompleted: _syncGridSelection()

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        RowLayout {
            visible: root.showNavigation
            Layout.fillWidth: true
            ToolButton {
                text: FluentIcons.ChevronLeft
                font.family: Theme.fontFamilyIcon
                Accessible.name: qsTr("Previous month")
                onClicked: {
                    var d = new Date(root.year, root.month - 1, 1)
                    root.month = d.getMonth()
                    root.year = d.getFullYear()
                    root._announce(grid.locale.standaloneMonthName(root.month + 1) + " " + root.year)
                }
            }
            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: grid.locale.standaloneMonthName(root.month + 1) + " " + root.year
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            ToolButton {
                text: FluentIcons.ChevronRight
                font.family: Theme.fontFamilyIcon
                Accessible.name: qsTr("Next month")
                onClicked: {
                    var d = new Date(root.year, root.month + 1, 1)
                    root.month = d.getMonth()
                    root.year = d.getFullYear()
                    root._announce(grid.locale.standaloneMonthName(root.month + 1) + " " + root.year)
                }
            }
        }

        DayOfWeekRow {
            Layout.fillWidth: true
            locale: root.calendarLocale
        }

        MonthGrid {
            id: grid
            Layout.fillWidth: true
            locale: root.calendarLocale
            month: root.month
            year: root.year
            selectionMode: root.selectionMode
            selectedDate: root.selectedDate
            selectedDates: root.selectedDates
            rangeStart: root.rangeStart
            rangeEnd: root.rangeEnd
            onClicked: function (date) { root._handleDateClick(date) }
        }

        Rectangle {
            visible: root.showTodayButton
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.strokeDivider
        }

        Button {
            visible: root.showTodayButton
            Layout.alignment: Qt.AlignHCenter
            flat: true
            text: qsTr("Today")
            enabled: root.isDateAllowed(new Date())
            onClicked: {
                var today = new Date()
                root.month = today.getMonth()
                root.year = today.getFullYear()
                if (root.selectionMode === "single")
                    root._handleDateClick(today)
                else
                    root.goToToday()
            }
        }
    }

    background: Item {}
}
