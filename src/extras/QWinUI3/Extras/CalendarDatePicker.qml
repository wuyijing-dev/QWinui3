import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// CalendarDatePicker — Date field with calendar flyout.
//
//   CalendarDatePicker { selectedDate: new Date() }

T.Control {
    id: root

    // Currently selected date
    property date selectedDate: new Date()
    // Calendar flyout open
    property bool calendarOpen: false
    // Open / visible state
    property alias isOpen: root.calendarOpen
    property string dateFormat: Locale.ShortFormat
    property bool showTodayButton: true
    // Header label above the control
    property string header: ""
    // Placeholder when empty
    property string placeholderText: ""
    property date minDate
    property date maxDate
    property bool hasMinDate: false
    property bool hasMaxDate: false

    signal dateChosen(date date)

    implicitWidth: 200
    implicitHeight: header.length ? (Theme.fontBody + 8 + Theme.controlHeight) : Theme.controlHeight
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Calendar date")
    Accessible.description: Qt.formatDate(selectedDate, dateFormat)

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
        return true
    }

    contentItem: ColumnLayout {
        spacing: 4

        Text {
            visible: root.header.length > 0
            Layout.fillWidth: true
            text: root.header
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: root.enabled ? Theme.textPrimary : Theme.textDisabled
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
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: FluentIcons.Calendar
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 14
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
                            font.family: Theme.fontFamilyIcon
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
                            font.family: Theme.fontFamilyIcon
                            Accessible.name: qsTr("Next month")
                            onClicked: {
                                var d = new Date(grid.year, grid.month + 1, 1)
                                grid.month = d.getMonth()
                                grid.year = d.getFullYear()
                            }
                        }
                    }

                    DayOfWeekRow {
                        locale: grid.locale
                        Layout.fillWidth: true
                    }

                    MonthGrid {
                        id: grid
                        Layout.fillWidth: true
                        month: root.selectedDate.getMonth()
                        year: root.selectedDate.getFullYear()
                        selectedDate: root.selectedDate
                        onClicked: function (date) {
                            if (!root.isDateAllowed(date))
                                return
                            root.selectedDate = date
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
                            root.dateChosen(today)
                            root.calendarOpen = false
                        }
                    }
                }
            }
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
