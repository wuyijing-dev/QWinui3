import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TimePicker — Hour / minute (and period) selectors.
//
//   TimePicker { }

T.Control {
    id: control

    property int hour: 12
    property int minute: 0
    property bool isAm: true
    property bool use24Hour: false
    // Picker flyout open
    property bool pickerOpen: false
    // Open / visible state
    property alias isOpen: control.pickerOpen
    // Header label above the control
    property string header: ""
    // WinUI MinuteIncrement — e.g. 1, 5, 15
    property int minuteIncrement: 1

    // WinUI ClockIdentifier (read-only mirror of use24Hour)
    readonly property string clockIdentifier: use24Hour ? "24HourClock" : "12HourClock"

    signal timeChosen(int hour, int minute)

    implicitWidth: 160
    implicitHeight: header.length ? (Theme.fontBody + 8 + Theme.controlHeight) : Theme.controlHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Time")
    Accessible.description: displayText

    readonly property var minuteModel: {
        var step = Math.max(1, Math.min(30, minuteIncrement))
        var list = []
        for (var i = 0; i < 60; i += step)
            list.push(String(i).padStart(2, "0"))
        return list
    }

    function snapMinute(m) {
        var step = Math.max(1, Math.min(30, minuteIncrement))
        var snapped = Math.round(m / step) * step
        if (snapped >= 60)
            snapped = 60 - step
        return Math.max(0, snapped)
    }

    readonly property int displayHour: {
        if (use24Hour)
            return ((hour % 24) + 24) % 24
        var h = ((hour % 12) + 12) % 12
        return h === 0 ? 12 : h
    }

    readonly property string displayText: {
        var hh = String(displayHour).padStart(2, "0")
        var mm = String(((minute % 60) + 60) % 60).padStart(2, "0")
        if (use24Hour)
            return hh + ":" + mm
        return hh + ":" + mm + (isAm ? " AM" : " PM")
    }

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
        control.timeChosen(control.hour, control.minute)
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
