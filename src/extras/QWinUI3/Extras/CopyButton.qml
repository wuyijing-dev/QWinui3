import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// CopyButton — Copies textToCopy and flashes a success glyph.
//
//   CopyButton {
//       id: copyButton
//       textToCopy: code
//       onCopyCompleted: (text) => { /* … */ }
//       onCopyFailed: { /* … */ }
//   }
//
//   // --- API ---
//   // signals: onCopyCompleted, onCopyFailed
//   // methods: copy(optionalText)
//   // copyButton.copy()
//   // copyButton.copy("override text")
//   // inherits AbstractButton (+ text, enabled, clicked, …)

T.AbstractButton {
    id: control

    // Clipboard payload to copy
    property string textToCopy: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Glyph before copy succeeds
    property string idleGlyph: ""
    // Glyph shown after copy
    property string doneGlyph: ""
    // Success feedback duration in ms
    property int feedbackMs: 1600
    // Emitted after a successful copy
    property bool copied: false
    // Hide text; show glyph only
    property bool iconOnly: text.length === 0
    // Emitted after a successful copy
    signal copyCompleted(string text)
    // Emitted when copy fails
    signal copyFailed()

    readonly property string _idleGlyph: {
        var g = IconSource.resolve(symbol, idleGlyph)
        return g.length ? g : FluentIcons.Copy
    }
    readonly property string _doneGlyph: doneGlyph.length ? doneGlyph : FluentIcons.Accept

    implicitWidth: Math.max(32, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(32, contentItem.implicitHeight + topPadding + bottomPadding)
    padding: 6
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption
    text: iconOnly ? "" : (copied ? qsTr("Copied") : qsTr("Copy"))
    Accessible.name: copied ? qsTr("Copied") : qsTr("Copy to clipboard")
    ToolTip.visible: hovered
    ToolTip.text: copied ? qsTr("Copied") : qsTr("Copy to clipboard")

    scale: down && !Theme.reducedMotion ? 0.96 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    // Copy to clipboard
    function copy(optionalText) {
        var value = optionalText !== undefined ? String(optionalText) : textToCopy
        if (!value.length) {
            copyFailed()
            return false
        }
        helper.text = value
        helper.selectAll()
        helper.copy()
        copied = true
        resetTimer.restart()
        copyCompleted(value)
        return true
    }

    onClicked: copy()

    TextEdit {
        id: helper
        visible: false
        width: 1
        height: 1
        readOnly: true
    }

    Timer {
        id: resetTimer
        interval: control.feedbackMs
        onTriggered: control.copied = false
    }

    contentItem: Row {
        spacing: 6
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: control.copied ? control._doneGlyph : control._idleGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: control.copied ? Theme.systemSuccess
                 : (control.enabled ? Theme.textPrimary : Theme.textDisabled)
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
            Behavior on text {
                enabled: false
            }
            scale: control.copied && !Theme.reducedMotion ? 1.08 : 1
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
            visible: !control.iconOnly && control.text.length > 0
            text: control.text
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        }
    }

    background: Item {
        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: {
                if (!control.enabled)
                    return "transparent"
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.hovered || control.copied)
                    return Theme.fillSubtle
                return "transparent"
            }
            border.width: control.iconOnly ? 0 : 1
            border.color: control.copied ? Theme.systemSuccess : Theme.strokeControl
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
            Behavior on border.color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
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
