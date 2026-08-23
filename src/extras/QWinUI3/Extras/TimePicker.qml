import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TimePicker — Hour / minute (and period) selectors.
//
//   TimePicker {
//       id: time
//       selectedTime: new Date()
//       clockIdentifier: "12HourClock"
//       onTimeChosen: apply(time.selectedTime)
//   }
//   // --- API ---
//   // time.hour / minute / selectedTime / clockIdentifier
//
// @notes
//   Tumbler time picker; selectedTime + clockIdentifier 12HourClock|24HourClock.
//   minuteIncrement snaps minutes (WinUI MinuteIncrement).
//   Form: header / description / errorMessage / hasError (1.28) — FormLayout.validate().

T.Control {
    id: control

    // Selected hour (0..23)
    property int hour: 12
    // Selected minute
    property int minute: 0
    // True in AM for 12-hour clock
    property bool isAm: true
    // Use 24-hour clock
    property bool use24Hour: false
    // WinUI ClockIdentifier: "12HourClock" | "24HourClock"
    property string clockIdentifier: "12HourClock"
    // WinUI SelectedTime — date whose time-of-day mirrors hour/minute
    property date selectedTime: new Date()
    // WinUI Time alias of selectedTime
    property alias time: control.selectedTime
    // Picker flyout open
    property bool pickerOpen: false
    // Open / visible state
    property alias isOpen: control.pickerOpen
    // Header label above the control
    property string header: ""
    // Supporting description text
    property string description: ""
    // Validation error text (FormLayout)
    property string errorMessage: ""
    // True when validation failed
    readonly property bool hasError: errorMessage.length > 0
    // WinUI MinuteIncrement — e.g. 1, 5, 15
    property int minuteIncrement: 1

    property bool _syncingTime: false
    property bool _syncingClock: false

    // Emitted when a time is chosen
    signal timeChosen(int hour, int minute)
    // Emitted when selectedTime changes via accept
    signal accepted(date time)

    Component.onCompleted: {
        _syncingClock = true
        clockIdentifier = use24Hour ? "24HourClock" : "12HourClock"
        _syncingClock = false
        syncSelectedTimeFromParts()
    }

    onClockIdentifierChanged: {
        if (_syncingClock)
            return
        _syncingClock = true
        var id = String(clockIdentifier).toLowerCase()
        use24Hour = id.indexOf("24") >= 0
        _syncingClock = false
    }
    onUse24HourChanged: {
        if (_syncingClock)
            return
        _syncingClock = true
        clockIdentifier = use24Hour ? "24HourClock" : "12HourClock"
        _syncingClock = false
    }

    onHourChanged: syncSelectedTimeFromParts()
    onMinuteChanged: syncSelectedTimeFromParts()
    onSelectedTimeChanged: {
        if (_syncingTime || isNaN(selectedTime.getTime()))
            return
        _syncingTime = true
        hour = selectedTime.getHours()
        minute = snapMinute(selectedTime.getMinutes())
        isAm = hour < 12
        _syncingTime = false
    }

    // Push hour/minute into selectedTime
    function syncSelectedTimeFromParts() {
        if (_syncingTime)
            return
        _syncingTime = true
        var d = new Date(selectedTime.getTime())
        if (isNaN(d.getTime()))
            d = new Date()
        d.setHours(hour, minute, 0, 0)
        selectedTime = d
        _syncingTime = false
    }

    implicitWidth: 160
    implicitHeight: contentItem.implicitHeight
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Time")
    Accessible.description: hasError
                             ? (errorMessage.length ? errorMessage : qsTr("Invalid value"))
                             : (description.length ? description : displayText)

    // Minute tumbler model
    readonly property var minuteModel: {
        var step = Math.max(1, Math.min(30, minuteIncrement))
        var list = []
        for (var i = 0; i < 60; i += step)
            list.push(String(i).padStart(2, "0"))
        return list
    }

    // Snap minutes to the increment
    function snapMinute(m) {
        var step = Math.max(1, Math.min(30, minuteIncrement))
        var snapped = Math.round(m / step) * step
        if (snapped >= 60)
            snapped = 60 - step
        return Math.max(0, snapped)
    }

    // Hour shown in the current clock format
    readonly property int displayHour: {
        if (use24Hour)
            return ((hour % 24) + 24) % 24
        var h = ((hour % 12) + 12) % 12
        return h === 0 ? 12 : h
    }

    // Text shown to the user
    readonly property string displayText: {
        var hh = String(displayHour).padStart(2, "0")
        var mm = String(((minute % 60) + 60) % 60).padStart(2, "0")
        if (use24Hour)
            return hh + ":" + mm
        return hh + ":" + mm + (isAm ? " AM" : " PM")
    }

    // Commit tumbler selection into the value
    function applyFromTumblers() {
        var h = hourTumbler.currentIndex
        var m = parseInt(control.minuteModel[minuteTumbler.currentIndex], 10)
        if (isNaN(m))
            m = 0
        if (use24Hour) {
            control.hour = h
            control.isAm = h < 12
        } else {
            var twelve = h + 1 // 0..11 -> 1..12
            control.isAm = amPmTumbler.currentIndex === 0
            control.hour = control.isAm
                    ? (twelve === 12 ? 0 : twelve)
                    : (twelve === 12 ? 12 : twelve + 12)
        }
        control.minute = control.snapMinute(m)
        control.syncSelectedTimeFromParts()
        control.timeChosen(control.hour, control.minute)
        control.accepted(control.selectedTime)
        control.errorMessage = ""
    }

    contentItem: ColumnLayout {
        spacing: 4

        Text {
            visible: control.header.length > 0
            Layout.fillWidth: true
            text: control.header
            font.family: control.font.family
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        }

        Text {
            visible: control.description.length > 0 && !control.hasError
            Layout.fillWidth: true
            text: control.description
            font.family: control.font.family
            font.pixelSize: Theme.fontCaption
            color: control.enabled ? Theme.textSecondary : Theme.textDisabled
            wrapMode: Text.Wrap
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.controlHeight

        TextField {
            id: field
            anchors.fill: parent
            readOnly: true
            text: control.displayText
            rightPadding: 36
            onPressed: control.pickerOpen = !control.pickerOpen
            Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Escape && control.pickerOpen) {
                    control.pickerOpen = false
                    event.accepted = true
                    return
                }
                if (event.key === Qt.Key_Space || event.key === Qt.Key_Return
                        || event.key === Qt.Key_Enter || event.key === Qt.Key_F4
                        || (event.key === Qt.Key_Down && (event.modifiers & Qt.AltModifier))) {
                    control.pickerOpen = !control.pickerOpen
                    event.accepted = true
                }
            }
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: FluentIcons.Clock
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: control.pickerOpen ? Theme.accent : Theme.textSecondary
            scale: field.hovered || control.pickerOpen ? 1.05 : 1
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
            id: popup
            y: field.height + 4
            padding: 12
            visible: control.pickerOpen
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            onClosed: control.pickerOpen = false
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
                spacing: Theme.spacingLoose

                RowLayout {
                    spacing: Theme.spacing
                    Layout.alignment: Qt.AlignHCenter

                    Tumbler {
                        id: hourTumbler
                        Layout.preferredWidth: 64
                        Layout.preferredHeight: 140
                        model: control.use24Hour
                               ? 24
                               : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                        visibleItemCount: 5
                    }

                    Label {
                        text: ":"
                        font.pixelSize: Theme.fontSubtitle
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }

                    Tumbler {
                        id: minuteTumbler
                        Layout.preferredWidth: 64
                        Layout.preferredHeight: 140
                        model: control.minuteModel
                        visibleItemCount: 5
                    }

                    Tumbler {
                        id: amPmTumbler
                        visible: !control.use24Hour
                        Layout.preferredWidth: 64
                        Layout.preferredHeight: 140
                        model: ["AM", "PM"]
                        visibleItemCount: 3
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Theme.strokeDivider
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: Theme.spacing
                    Button {
                        text: qsTr("Cancel")
                        flat: true
                        onClicked: control.pickerOpen = false
                    }
                    Button {
                        text: qsTr("OK")
                        highlighted: true
                        onClicked: {
                            control.applyFromTumblers()
                            control.pickerOpen = false
                        }
                    }
                }
            }
        }
        }

        Text {
            visible: control.errorMessage.length > 0
            Layout.fillWidth: true
            text: control.errorMessage
            font.family: control.font.family
            font.pixelSize: Theme.fontCaption
            color: Theme.systemCritical
            wrapMode: Text.Wrap
        }
    }

    onPickerOpenChanged: {
        if (pickerOpen) {
            if (use24Hour)
                hourTumbler.currentIndex = ((hour % 24) + 24) % 24
            else {
                var h12 = displayHour
                hourTumbler.currentIndex = Math.max(0, h12 - 1)
                amPmTumbler.currentIndex = isAm ? 0 : 1
            }
            var step = Math.max(1, Math.min(30, minuteIncrement))
            var snapped = snapMinute(minute)
            minuteTumbler.currentIndex = Math.max(0, Math.round(snapped / step))
            popup.open()
        } else {
            popup.close()
        }
    }
}
