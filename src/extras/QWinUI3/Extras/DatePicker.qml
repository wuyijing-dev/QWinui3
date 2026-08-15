import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: control

    property int year: new Date().getFullYear()
    property int month: new Date().getMonth() + 1 // 1-12
    property int day: new Date().getDate()
    property int minYear: 1970
    property int maxYear: 2100
    property bool pickerOpen: false
    property alias isOpen: control.pickerOpen
    property string header: ""
    property string placeholderText: ""
    // yyyy-MM-dd | MM/dd/yyyy | dd/MM/yyyy
    property string dateFormat: "yyyy-MM-dd"

    signal dateChosen(int year, int month, int day)

    property date selectedDate: new Date(year, month - 1, day)

    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Date")
    Accessible.description: displayText

    property bool _syncingDate: false

    onYearChanged: syncSelectedDateFromParts()
    onMonthChanged: syncSelectedDateFromParts()
    onDayChanged: syncSelectedDateFromParts()
    onSelectedDateChanged: {
        if (_syncingDate)
            return
        _syncingDate = true
        year = selectedDate.getFullYear()
        month = selectedDate.getMonth() + 1
        day = selectedDate.getDate()
        _syncingDate = false
    }

    function syncSelectedDateFromParts() {
        if (_syncingDate)
            return
        _syncingDate = true
        selectedDate = new Date(year, month - 1, day)
        _syncingDate = false
    }

    implicitWidth: 180
    implicitHeight: header.length ? (headerLabel.implicitHeight + 4 + Theme.controlHeight)
                                  : Theme.controlHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    readonly property string displayText: {
        var y = String(year)
        var m = String(month).padStart(2, "0")
        var d = String(day).padStart(2, "0")
        switch (dateFormat) {
        case "MM/dd/yyyy": return m + "/" + d + "/" + y
        case "dd/MM/yyyy": return d + "/" + m + "/" + y
        default: return y + "-" + m + "-" + d
        }
    }

    readonly property int daysInMonth: {
        return new Date(year, month, 0).getDate()
    }

    function clampDay() {
        day = Math.max(1, Math.min(daysInMonth, day))
    }

    function applyFromTumblers() {
        year = minYear + yearTumbler.currentIndex
        month = monthTumbler.currentIndex + 1
        clampDay()
        var maxD = new Date(year, month, 0).getDate()
        day = Math.min(maxD, dayTumbler.currentIndex + 1)
        dayTumbler.model = maxD
        dayTumbler.currentIndex = day - 1
        dateChosen(year, month, day)
        syncSelectedDateFromParts()
    }

    function syncTumblers() {
        yearTumbler.currentIndex = Math.max(0, Math.min(maxYear - minYear, year - minYear))
        monthTumbler.currentIndex = Math.max(0, Math.min(11, month - 1))
        dayTumbler.model = daysInMonth
        dayTumbler.currentIndex = Math.max(0, Math.min(daysInMonth - 1, day - 1))
    }

    contentItem: ColumnLayout {
        spacing: 4

        Text {
            id: headerLabel
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
            placeholderText: control.placeholderText
            rightPadding: 36
            onPressed: {
                control.syncTumblers()
                control.pickerOpen = !control.pickerOpen
            }
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: FluentIcons.Calendar
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
            onOpened: control.syncTumblers()
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
                        id: yearTumbler
                        Layout.preferredWidth: 72
                        Layout.preferredHeight: 140
                        model: control.maxYear - control.minYear + 1
                        visibleItemCount: 5
                        delegate: Text {
                            text: control.minYear + modelData
                            font.family: control.font.family
                            font.pixelSize: control.font.pixelSize
                            font.weight: Math.abs(Tumbler.displacement) < 0.5
                                         ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                            color: Math.abs(Tumbler.displacement) < 0.5
                                   ? Theme.textPrimary : Theme.textSecondary
                            opacity: 1.0 - Math.abs(Tumbler.displacement) / (yearTumbler.visibleItemCount / 2)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Tumbler {
                        id: monthTumbler
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 140
                        model: 12
                        visibleItemCount: 5
                        onCurrentIndexChanged: {
                            if (!popup.visible)
                                return
                            var y = control.minYear + yearTumbler.currentIndex
                            var m = currentIndex + 1
                            var maxD = new Date(y, m, 0).getDate()
                            if (dayTumbler.model !== maxD) {
                                var prev = dayTumbler.currentIndex
                                dayTumbler.model = maxD
                                dayTumbler.currentIndex = Math.min(prev, maxD - 1)
                            }
                        }
                        delegate: Text {
                            text: String(modelData + 1).padStart(2, "0")
                            font.family: control.font.family
                            font.pixelSize: control.font.pixelSize
                            font.weight: Math.abs(Tumbler.displacement) < 0.5
                                         ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                            color: Math.abs(Tumbler.displacement) < 0.5
                                   ? Theme.textPrimary : Theme.textSecondary
                            opacity: 1.0 - Math.abs(Tumbler.displacement) / (monthTumbler.visibleItemCount / 2)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Tumbler {
                        id: dayTumbler
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 140
                        model: control.daysInMonth
                        visibleItemCount: 5
                        delegate: Text {
                            text: String(modelData + 1).padStart(2, "0")
                            font.family: control.font.family
                            font.pixelSize: control.font.pixelSize
                            font.weight: Math.abs(Tumbler.displacement) < 0.5
                                         ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                            color: Math.abs(Tumbler.displacement) < 0.5
                                   ? Theme.textPrimary : Theme.textSecondary
                            opacity: 1.0 - Math.abs(Tumbler.displacement) / (dayTumbler.visibleItemCount / 2)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
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
                        text: qsTr("Accept")
                        highlighted: true
                        onClicked: {
                            control.applyFromTumblers()
                            control.pickerOpen = false
                        }
                    }
                }
            }
        }
        } // field host Item
    }

    background: Item {}
}
