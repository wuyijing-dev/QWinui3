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

    readonly property bool _horizontal: orientation === Qt.Horizontal || orientation === undefined
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

    implicitWidth: _horizontal ? 200 : trackThickness
    implicitHeight: (_horizontal ? trackThickness : 200)
                    + (_hasChrome ? chrome.height + Theme.spacing : 0)
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
        implicitWidth: control._horizontal ? 200 : control.trackThickness
        implicitHeight: control._horizontal ? control.trackThickness : 200

        Rectangle {
            id: determinateFill
            visible: !control.indeterminate
            // Vertical: grow from bottom (matches Qt / WinUI thick-rail expectation)
            x: 0
            y: control._horizontal ? 0
               : Math.max(0, parent.height * (1 - control.position))
            width: control._horizontal
                   ? Math.max(0, control.position * parent.width)
                   : parent.width
            height: control._horizontal
                    ? parent.height
                    : Math.max(0, control.position * parent.height)
            radius: Math.min(width, height) / 2
            color: control._fillColor
            opacity: 1

            Behavior on width {
                enabled: control._horizontal && !Theme.reducedMotion && control.visible
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on height {
                enabled: !control._horizontal && !Theme.reducedMotion && control.visible
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on y {
                enabled: !control._horizontal && !Theme.reducedMotion && control.visible
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
                anchors.verticalCenter: control._horizontal ? parent.verticalCenter : undefined
                anchors.horizontalCenter: control._horizontal ? undefined : parent.horizontalCenter
                anchors.right: control._horizontal ? parent.right : undefined
                anchors.top: control._horizontal ? undefined : parent.top
                width: control._horizontal ? Math.min(parent.width, 24) : parent.width
                height: control._horizontal ? parent.height : Math.min(parent.height, 24)
                radius: Math.min(width, height) / 2
                visible: (control._horizontal ? parent.width > 8 : parent.height > 8)
                         && !control.showError
                gradient: Gradient {
                    orientation: control._horizontal ? Gradient.Horizontal : Gradient.Vertical
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
            width: control._horizontal ? Math.max(48, parent.width * 0.32) : parent.width
            height: control._horizontal ? parent.height : Math.max(48, parent.height * 0.32)
            radius: Math.min(width, height) / 2
            color: control._fillColor
            opacity: Theme.reducedMotion || control.showPaused || control.showError ? 0.85 : 1
            x: control._horizontal ? indeterminateBar._travel : 0
            y: control._horizontal ? 0 : indeterminateBar._travel

            property real _travel: 0

            SequentialAnimation on _travel {
                loops: Animation.Infinite
                running: control.indeterminate && control.visible
                         && !Theme.reducedMotion && !control.showPaused && !control.showError
                NumberAnimation {
                    from: 0
                    to: control._horizontal
                        ? Math.max(0, indeterminateBar.parent.width - indeterminateBar.width)
                        : Math.max(0, indeterminateBar.parent.height - indeterminateBar.height)
                    duration: Math.max(900, (control._horizontal
                              ? indeterminateBar.parent.width
                              : indeterminateBar.parent.height) * 8)
                    easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    from: control._horizontal
                          ? Math.max(0, indeterminateBar.parent.width - indeterminateBar.width)
                          : Math.max(0, indeterminateBar.parent.height - indeterminateBar.height)
                    to: 0
                    duration: Math.max(600, (control._horizontal
                              ? indeterminateBar.parent.width
                              : indeterminateBar.parent.height) * 5)
                    easing.type: Easing.InOutCubic
                }
            }

            Binding {
                when: (Theme.reducedMotion || control.showPaused || control.showError)
                      && control.indeterminate
                target: indeterminateBar
                property: "_travel"
                value: control._horizontal
                       ? Math.max(0, (indeterminateBar.parent.width - indeterminateBar.width) / 2)
                       : Math.max(0, (indeterminateBar.parent.height - indeterminateBar.height) / 2)
            }
        }
    }

    background: Rectangle {
        implicitWidth: control._horizontal ? 200 : control.trackThickness
        implicitHeight: control._horizontal ? control.trackThickness : 200
        radius: Math.min(width, height) / 2
        color: Theme.dark ? "#15FFFFFF" : "#0F000000"
    }
}
