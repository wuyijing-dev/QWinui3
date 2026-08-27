import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// CalendarDatePicker — Date field with calendar flyout.
//
//   CalendarDatePicker {
//       id: calendarDatePicker
//       selectedDate: new Date()
//   }
//
//   // --- API ---
//   // signals: onDateChosen
//   // methods: isDateAllowed(d)
//   // calendarDatePicker.isDateAllowed(d)
//
// @notes
//   Text field + calendar flyout (MonthGrid); selectedDate with min/max bounds.
//   FirstDayOfWeek remaps calendar locale (WinUI CalendarView.FirstDayOfWeek).
//   Form: header / description / errorMessage / hasError (1.28) — FormLayout.validate().

T.Control {
    id: root

    // Currently selected date
    property date selectedDate: new Date()
    // WinUI Date alias of selectedDate
    property alias date: root.selectedDate
    // Calendar flyout open
    property bool calendarOpen: false
    // Open / visible state
    property alias isOpen: root.calendarOpen
    // WinUI IsCalendarOpen
    property alias isCalendarOpen: root.calendarOpen
    // Display date format
    property string dateFormat: Locale.ShortFormat
    // Show Today button in calendar
    property bool showTodayButton: true
    // Highlight today ring (MonthGrid isToday)
    property bool isTodayHighlighted: true
    // Header label above the control
    property string header: ""
    // Supporting description text
    property string description: ""
    // Validation error text (FormLayout)
    property string errorMessage: ""
    // True when validation failed
    readonly property bool hasError: errorMessage.length > 0
    // Placeholder when empty
    property string placeholderText: ""
    // Minimum selectable date
    property date minDate
    // Maximum selectable date
    property date maxDate
    // Dates that cannot be selected — synced with CalendarView (2.69 D5)
    property var blackoutDates: []
    property var blackoutFilter: null
    // True when minDate is set
    property bool hasMinDate: false
    // True when maxDate is set
    property bool hasMaxDate: false
    // WinUI FirstDayOfWeek — Qt.Sunday..Qt.Saturday, or -1 for system default
    property int firstDayOfWeek: -1

    // Locale whose firstDayOfWeek matches the requested start day
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

    // Emitted when a date is chosen
    signal dateChosen(date date)

    implicitWidth: 200
    implicitHeight: contentItem.implicitHeight
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Calendar date")
    Accessible.description: hasError
                             ? (errorMessage.length ? errorMessage : qsTr("Invalid value"))
                             : (description.length ? description
                                : Qt.formatDate(selectedDate, dateFormat))

    // True when the date is within selectable bounds
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
            if (!isNaN(bd.getTime())
                    && day.getFullYear() === bd.getFullYear()
                    && day.getMonth() === bd.getMonth()
                    && day.getDate() === bd.getDate())
                return false
        }
        return true
    }

    contentItem: ColumnLayout {
        spacing: 4

        Text {
            visible: root.header.length > 0
            Layout.fillWidth: true
            text: root.header
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: root.enabled ? Theme.textPrimary : Theme.textDisabled
        }

        Text {
            visible: root.description.length > 0 && !root.hasError
            Layout.fillWidth: true
            text: root.description
            font.pixelSize: Theme.fontCaption
            color: root.enabled ? Theme.textSecondary : Theme.textDisabled
            wrapMode: Text.Wrap
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.controlHeight

            TextField {
                id: field
                anchors.fill: parent
                readOnly: true
                text: Qt.formatDate(root.selectedDate, root.dateFormat)
                placeholderText: root.placeholderText
                rightPadding: 36
                onPressed: root.calendarOpen = !root.calendarOpen
                Keys.onPressed: function (event) {
                    if (event.key === Qt.Key_Escape && root.calendarOpen) {
                        root.calendarOpen = false
                        event.accepted = true
                        return
                    }
                    if (event.key === Qt.Key_Space || event.key === Qt.Key_Return
                            || event.key === Qt.Key_Enter || event.key === Qt.Key_F4
                            || (event.key === Qt.Key_Down && (event.modifiers & Qt.AltModifier))) {
                        root.calendarOpen = !root.calendarOpen
                        event.accepted = true
                    }
                }
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: FluentIcons.Calendar
                font: Theme.iconFontFor(14)
                color: root.calendarOpen ? Theme.accent : Theme.textSecondary
                scale: field.hovered || root.calendarOpen ? 1.05 : 1
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }

            Popup {
                id: calPopup
                y: field.height + 4
                width: 300
                padding: 8
                visible: root.calendarOpen
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                onClosed: root.calendarOpen = false
                transformOrigin: Item.Top

                enter: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 0; to: 1
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingEnter
                    }
                    NumberAnimation {
                        property: "scale"
                        from: 0.96; to: 1
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingEnter
                    }
                }
                exit: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 1; to: 0
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingExit
                    }
                }

                background: ElevatedChrome {
                    color: Theme.bgCardElevated
                    radius: Theme.cornerOverlay
                    borderColor: Theme.strokeCard
                    borderWidth: 1
                    elevation: 6
                    shadowOpacity: Theme.dark ? 0.32 : 0.16
                }

                contentItem: ColumnLayout {
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        ToolButton {
                            text: FluentIcons.ChevronLeft
                            font: Theme.iconFontFor(14)
                            Accessible.name: qsTr("Previous month")
                            onClicked: {
                                var d = new Date(grid.year, grid.month - 1, 1)
                                grid.month = d.getMonth()
                                grid.year = d.getFullYear()
                            }
                        }
                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            text: grid.locale.standaloneMonthName(grid.month + 1) + " " + grid.year
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                        }
                        ToolButton {
                            text: FluentIcons.ChevronRight
                            font: Theme.iconFontFor(14)
                            Accessible.name: qsTr("Next month")
                            onClicked: {
                                var d = new Date(grid.year, grid.month + 1, 1)
                                grid.month = d.getMonth()
                                grid.year = d.getFullYear()
                            }
                        }
                    }

                    DayOfWeekRow {
                        locale: root.calendarLocale
                        Layout.fillWidth: true
                    }

                    MonthGrid {
                        id: grid
                        Layout.fillWidth: true
                        locale: root.calendarLocale
                        month: root.selectedDate.getMonth()
                        year: root.selectedDate.getFullYear()
                        selectedDate: root.selectedDate
                        onClicked: function (date) {
                            if (!root.isDateAllowed(date))
                                return
                            root.selectedDate = date
                            root.errorMessage = ""
                            root.dateChosen(date)
                            root.calendarOpen = false
                        }
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
                            if (!root.isDateAllowed(today))
                                return
                            grid.month = today.getMonth()
                            grid.year = today.getFullYear()
                            root.selectedDate = today
                            root.errorMessage = ""
                            root.dateChosen(today)
                            root.calendarOpen = false
                        }
                    }
                }
            }
        }

        Text {
            visible: root.errorMessage.length > 0
            Layout.fillWidth: true
            text: root.errorMessage
            font.pixelSize: Theme.fontCaption
            color: Theme.systemCritical
            wrapMode: Text.Wrap
        }
    }

    onCalendarOpenChanged: {
        if (calendarOpen) {
            grid.month = root.selectedDate.getMonth()
            grid.year = root.selectedDate.getFullYear()
            calPopup.open()
        } else {
            calPopup.close()
        }
    }
}
