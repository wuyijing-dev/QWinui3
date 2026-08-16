import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// MonthGrid — Fluent calendar month grid for DatePicker / CalendarDatePicker.
//
//   MonthGrid {
//       id: grid
//       month: (new Date()).getMonth()
//       year: (new Date()).getFullYear()
//       onClicked: (date) => pick(date)
//   }
//   // --- API ---
//   // grid.month / year / locale / title / clicked(date)
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls MonthGrid.
//   Public API is the Qt Quick Controls MonthGrid type; this file supplies visuals/metrics only.

T.AbstractMonthGrid {
    id: control

    Accessible.role: Accessible.Table
    Accessible.name: control.title.length ? control.title : qsTr("Calendar month")

    // Selected date
    property date selectedDate: new Date(NaN)

    implicitWidth: 280
    implicitHeight: 240
    spacing: 2
    leftPadding: 8
    rightPadding: 8
    topPadding: 4
    bottomPadding: 8
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    // True when two dates are the same calendar day
    function sameDay(a, b) {
        if (isNaN(a.getTime()) || isNaN(b.getTime()))
            return false
        return a.getFullYear() === b.getFullYear()
            && a.getMonth() === b.getMonth()
            && a.getDate() === b.getDate()
    }

    delegate: Item {
        id: cell
        // Data model
        required property var model
        implicitWidth: 36
        implicitHeight: 36

        // True when the day is in the displayed month
        readonly property bool inMonth: model.month === control.month
        // True when the day is today
        readonly property bool isToday: !!model.today
        // Selected state
        readonly property bool isSelected: control.sameDay(model.date, control.selectedDate)

        HoverHandler { id: cellHover }

        Rectangle {
            anchors.centerIn: parent
            width: 32
            height: 32
            radius: width / 2
            color: {
                if (cell.isSelected)
                    return Theme.accent
                if (cellHover.hovered && cell.inMonth)
                    return Theme.fillSubtle
                return "transparent"
            }
            border.width: cell.isToday && !cell.isSelected ? 1 : 0
            border.color: Theme.accent
            scale: cellHover.hovered && !cell.isSelected ? 1.04 : 1
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Text {
            anchors.centerIn: parent
            opacity: cell.inMonth ? 1 : 0.35
            text: model.day
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            font.weight: (cell.isToday || cell.isSelected)
                         ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
            color: {
                if (cell.isSelected)
                    return Theme.textOnAccent
                if (cell.isToday)
                    return Theme.accent
                return Theme.textPrimary
            }
        }

        TapHandler {
            onTapped: control.clicked(model.date)
        }
    }

    contentItem: Grid {
        rows: 6
        columns: 7
        rowSpacing: control.spacing
        columnSpacing: control.spacing

        Repeater {
            model: control.source
            delegate: control.delegate
        }
    }

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
