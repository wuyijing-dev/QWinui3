import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ProgressBar — Fluent / WinUI 3 ProgressBar (Header, value label, ShowError / ShowPaused).
//
//   ProgressBar {
//       header: qsTr("Downloading")
//       showValue: true
//       value: 0.45
//   }
//
//   ProgressBar {
//       indeterminate: true
//       showPaused: true   // or showError: true
//   }
//
// @notes
//   WinUI ShowError (critical) / ShowPaused (caution; pauses indeterminate motion).
//   Optional header + percentage above the track (ProgressRing-aligned showValue / valueLabel).

T.ProgressBar {
    id: control

    // WinUI ShowError — paint the bar in the error/critical color
    property bool showError: false
    // WinUI ShowPaused — caution color; stops indeterminate motion
    property bool showPaused: false
    // Label above the track (Fluent recipe / WinUI sample pairing)
    property string header: ""
    // Show percentage (or valueLabel) opposite the header
    property bool showValue: false
    // Override formatted percentage text
    property string valueLabel: ""
    // Track thickness in px (default Theme.sliderThickness)
    property real trackThickness: Theme.sliderThickness

    readonly property bool _hasChrome: header.length > 0 || showValue
    readonly property string formattedValue: {
        if (valueLabel.length)
            return valueLabel
        if (indeterminate)
            return showError ? qsTr("Error")
                 : (showPaused ? qsTr("Paused") : qsTr("Busy"))
        return Math.round(control.position * 100) + "%"
    }

    Accessible.role: Accessible.ProgressBar
    Accessible.name: control.header.length ? control.header : qsTr("Progress")
    Accessible.description: {
        if (control.indeterminate)
            return control.showError ? qsTr("Error")
                 : (control.showPaused ? qsTr("Paused") : qsTr("In progress"))
        if (control.showError)
            return qsTr("Error — %1").arg(formattedValue)
        if (control.showPaused)
            return qsTr("Paused — %1").arg(formattedValue)
        return qsTr("%1 percent").arg(Math.round(control.position * 100))
    }

    implicitWidth: 200
    implicitHeight: trackThickness + (_hasChrome ? chrome.height + Theme.spacing : 0)
    padding: 0
    topPadding: _hasChrome ? chrome.height + Theme.spacing : 0
    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0

    readonly property color _fillColor: {
        if (!control.enabled)
            return Theme.textDisabled
        if (control.showError)
            return Theme.systemCritical
        if (control.showPaused)
            return Theme.systemCaution
        return Theme.accent
    }

    property bool _wasComplete: false

    onPositionChanged: {
        if (control.indeterminate)
            return
        if (control.position >= 1 && !_wasComplete) {
            _wasComplete = true
            if (!Theme.reducedMotion)
                completeFlash.restart()
        } else if (control.position < 0.995) {
            _wasComplete = false
        }
    }

    // Header + value row above the track (uses topPadding reservation)
    Item {
        id: chrome
        visible: control._hasChrome
        x: 0
        y: 0
        width: control.width
        height: Math.max(headerText.implicitHeight, valueText.implicitHeight)

        Text {
            id: headerText
            anchors.left: parent.left
            anchors.right: valueText.visible ? valueText.left : parent.right
            anchors.rightMargin: valueText.visible ? Theme.spacing : 0
            anchors.verticalCenter: parent.verticalCenter
            visible: control.header.length > 0
            text: control.header
            font.pixelSize: Theme.fontBody
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
            elide: Text.ElideRight
        }
        Text {
            id: valueText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            visible: control.showValue
            text: control.formattedValue
            font.pixelSize: Theme.fontBody
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control.showError)
                    return Theme.systemCritical
                if (control.showPaused)
                    return Theme.systemCaution
                return Theme.textSecondary
            }
        }
    }

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: control.trackThickness

        Rectangle {
            id: determinateFill
            visible: !control.indeterminate
            width: Math.max(0, control.position * parent.width)
            height: parent.height
            radius: height / 2
            color: control._fillColor
            opacity: 1

            Behavior on width {
                enabled: !Theme.reducedMotion && control.visible
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on opacity {
                enabled: !Theme.reducedMotion && !completeFlash.running
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            SequentialAnimation {
                id: completeFlash
                NumberAnimation {
                    target: determinateFill
                    property: "opacity"
                    to: 0.55
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
                NumberAnimation {
                    target: determinateFill
                    property: "opacity"
                    to: 1
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: Math.min(parent.width, 24)
                height: parent.height
                radius: height / 2
                visible: parent.width > 8 && !control.showError
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: "transparent" }
                    GradientStop {
                        position: 1
                        color: Qt.rgba(1, 1, 1, Theme.dark ? 0.22 : 0.35)
                    }
                }
            }
        }

        Rectangle {
            id: indeterminateBar
            visible: control.indeterminate
            width: Math.max(48, parent.width * 0.32)
            height: parent.height
            radius: height / 2
            color: control._fillColor
            opacity: Theme.reducedMotion || control.showPaused || control.showError ? 0.85 : 1

            // Stay inside the pill track — no clip:true (would square the ends).
            SequentialAnimation on x {
                loops: Animation.Infinite
                running: control.indeterminate && control.visible
                         && !Theme.reducedMotion && !control.showPaused && !control.showError
                NumberAnimation {
                    from: 0
                    to: Math.max(0, parent.width - indeterminateBar.width)
                    duration: Math.max(900, parent.width * 8)
                    easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    from: Math.max(0, parent.width - indeterminateBar.width)
                    to: 0
                    duration: Math.max(600, parent.width * 5)
                    easing.type: Easing.InOutCubic
                }
            }

            Binding {
                when: (Theme.reducedMotion || control.showPaused || control.showError)
                      && control.indeterminate
                target: indeterminateBar
                property: "x"
                value: Math.max(0, (parent.width - indeterminateBar.width) / 2)
            }
        }
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: control.trackThickness
        radius: height / 2
        color: Theme.dark ? "#15FFFFFF" : "#0F000000"
    }
}
