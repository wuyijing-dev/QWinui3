import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// Button that shows an inline determinate / indeterminate progress fill.
T.AbstractButton {
    id: control

    property real progress: 0 // 0..1 when determinate
    property bool indeterminate: false
    property alias isIndeterminate: control.indeterminate
    property bool showProgress: true
    // idle | progressing | completed | error
    property string progressState: "idle"
    property string progressingText: ""
    property string completedText: ""
    property string errorText: ""
    signal progressCompleted()
    signal progressFailed()

    readonly property string displayText: {
        if (progressState === "completed" && completedText.length)
            return completedText
        if (progressState === "error" && errorText.length)
            return errorText
        if ((progressState === "progressing" || indeterminate) && progressingText.length)
            return progressingText
        return text
    }

    readonly property bool _showBar: showProgress
                                     && (progressState === "progressing" || progressState === "idle"
                                         || indeterminate || progress > 0)
    readonly property color _fillColor: {
        if (progressState === "error")
            return Qt.rgba(Theme.systemCritical.r, Theme.systemCritical.g, Theme.systemCritical.b, 0.35)
        if (progressState === "completed")
            return Qt.rgba(Theme.systemSuccess.r, Theme.systemSuccess.g, Theme.systemSuccess.b, 0.35)
        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.28)
    }

    onProgressChanged: {
        if (indeterminate || progressState === "error")
            return
        if (progress >= 0.999) {
            if (progressState !== "completed") {
                progressState = "completed"
                progressCompleted()
            }
        } else if (progress > 0 && progressState === "idle") {
            progressState = "progressing"
        }
    }

    function reset() {
        progress = 0
        indeterminate = false
        progressState = "idle"
    }

    function start(indeterminateMode) {
        progressState = "progressing"
        if (indeterminateMode === true) {
            indeterminate = true
            progress = 0
        } else {
            indeterminate = false
            if (progress <= 0)
                progress = 0.01
        }
    }

    function complete() {
        indeterminate = false
        progress = 1
        progressState = "completed"
        progressCompleted()
    }

    function fail() {
        progressState = "error"
        progressFailed()
    }

    implicitWidth: Math.max(Theme.controlMinWidth,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Theme.controlHeight
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight
        Row {
            id: row
            anchors.centerIn: parent
            spacing: 8
            Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: control.progressState === "completed" || control.progressState === "error"
                text: control.progressState === "completed" ? "\uE73E" : "\uE783"
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 14
                color: control.progressState === "completed" ? Theme.systemSuccess : Theme.systemCritical
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: control.displayText
                font: control.font
                color: control.enabled ? Theme.textPrimary : Theme.textDisabled
                elide: Text.ElideRight
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }
        }
    }

    background: Rectangle {
        id: bg
        radius: Theme.cornerControl
        color: {
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.progressState === "completed")
                return Qt.rgba(Theme.systemSuccess.r, Theme.systemSuccess.g, Theme.systemSuccess.b, 0.12)
            if (control.progressState === "error")
                return Qt.rgba(Theme.systemCritical.r, Theme.systemCritical.g, Theme.systemCritical.b, 0.12)
            if (control.down)
                return Theme.fillControlTertiary
            if (control.hovered)
                return Theme.fillControlSecondary
            return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
        }
        border.width: 1
        border.color: {
            if (control.progressState === "completed")
                return Theme.systemSuccess
            if (control.progressState === "error")
                return Theme.systemCritical
            return Theme.strokeControl
        }

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }

        readonly property real innerRadius: Math.max(0, radius - 1)
        readonly property real innerWidth: Math.max(0, width - 2)

        Rectangle {
            visible: control._showBar && !control.indeterminate && control.progressState !== "error"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 1
            width: bg.innerWidth * (control.progressState === "completed" ? 1
                                   : Math.max(0, Math.min(1, control.progress)))
            radius: bg.innerRadius
            color: control._fillColor
            Behavior on width {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Item {
            id: indClip
            anchors.fill: parent
            anchors.margins: 1
            visible: control._showBar && control.indeterminate && control.progressState === "progressing"
            clip: true

            Rectangle {
                id: indBar
                y: 0
                width: Math.max(40, parent.width * 0.35)
                height: parent.height
                radius: bg.innerRadius
                color: control._fillColor
                SequentialAnimation on x {
                    loops: Animation.Infinite
                    running: control.indeterminate && control.visible
                             && control.progressState === "progressing" && !Theme.reducedMotion
                    NumberAnimation {
                        from: -indBar.width
                        to: indClip.width
                        duration: 1100
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: Theme.cornerControl + 2
            color: "transparent"
            border.width: control.visualFocus ? 2 : 0
            border.color: Theme.focusOuter
            visible: control.visualFocus
        }
    }
}
