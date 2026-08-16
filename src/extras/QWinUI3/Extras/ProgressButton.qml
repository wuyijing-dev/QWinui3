import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ProgressButton — Button with inline determinate/indeterminate fill.
//
//   ProgressButton {
//       id: progressButton
//       text: qsTr("Upload"); progress: 0.4
//   }
//
//   // --- API ---
//   // signals: onProgressCompleted, onProgressFailed
//   // methods: setProgress(value), reset(), start(indeterminateMode), complete(), fail()
//   // progressButton.setProgress(value)
//   // progressButton.reset()
//   // progressButton.start(indeterminateMode)
//   // progressButton.complete()
//   // inherits AbstractButton (+ Qt Quick Controls base API)
//
// @notes
//   Button that shows determinate/indeterminate progress while busy.
//   setProgress / progressCompleted / progressFailed.

T.AbstractButton {
    id: control

    // 0..1 progress (determinate)
    property real progress: 0 // 0..1 when determinate
    // Show indeterminate animation when true
    property bool indeterminate: false
    // Alias of indeterminate
    property alias isIndeterminate: control.indeterminate
    // Show progress indicator
    property bool showProgress: true
    // Show percentage readout
    property bool showPercentage: false
    // idle | progressing | completed | error
    property string progressState: "idle"
    // Text while progress is running
    property string progressingText: ""
    // Text shown when complete
    property string completedText: ""
    // Error message text
    property string errorText: ""
    // Emitted when progress reaches completion
    signal progressCompleted()
    // Emitted when progress fails
    signal progressFailed()

    // Value as 0..100 percentage
    readonly property real percentage: Math.round(Math.max(0, Math.min(1, progress)) * 100)
    // Text shown to the user
    readonly property string displayText: {
        if (progressState === "completed" && completedText.length)
            return completedText
        if (progressState === "error" && errorText.length)
            return errorText
        if ((progressState === "progressing" || indeterminate) && progressingText.length)
            return progressingText
        if (showPercentage && progressState === "progressing" && !indeterminate)
            return text.length ? (text + " " + percentage + "%") : (percentage + "%")
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

    // Set progress 0..1
    function setProgress(value) {
        indeterminate = false
        progress = Math.max(0, Math.min(1, value))
        if (progress >= 0.999)
            return
        if (progress > 0 && progressState !== "error")
            progressState = "progressing"
        else if (progress <= 0)
            progressState = "idle"
    }

    // Reset to defaults
    function reset() {
        progress = 0
        indeterminate = false
        progressState = "idle"
    }

    // Start animation / operation
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

    // Mark the step / task complete
    function complete() {
        indeterminate = false
        progress = 1
        progressState = "completed"
        progressCompleted()
    }

    // Mark the operation failed
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
    focusPolicy: Qt.StrongFocus
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.Button
    Accessible.name: displayText
    Accessible.description: {
        if (indeterminate)
            return qsTr("In progress")
        if (progressState === "completed")
            return qsTr("Completed")
        if (progressState === "error")
            return qsTr("Failed")
        if (progress > 0)
            return qsTr("%1 percent").arg(percentage)
        return ""
    }

    scale: down && !Theme.reducedMotion ? 0.98 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

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
                text: control.progressState === "completed" ? FluentIcons.Accept : FluentIcons.Error
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 14
                color: control.progressState === "completed" ? Theme.systemSuccess : Theme.systemCritical
                scale: visible && !Theme.reducedMotion ? 1 : 0.7
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingEnter
                    }
                }
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

        // Inner radius
        readonly property real innerRadius: Math.max(0, radius - 1)
        // Inner width
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

        // Keep the indeterminate bar inside the rounded host — do not use clip:true
        // (axis-aligned only); a rectangular clip makes the fill cover rounded corners.
        Item {
            id: indHost
            anchors.fill: parent
            anchors.margins: 1
            visible: control._showBar && control.indeterminate && control.progressState === "progressing"

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
                        from: 0
                        to: Math.max(0, indHost.width - indBar.width)
                        duration: 1100
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }
    }
}
