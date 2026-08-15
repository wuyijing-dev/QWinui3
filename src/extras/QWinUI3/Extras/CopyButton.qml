import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// Copies textToCopy to the clipboard and briefly shows a success glyph.
T.AbstractButton {
    id: control

    property string textToCopy: ""
    property string idleGlyph: "\uE8C8"
    property string doneGlyph: "\uE73E"
    property int feedbackMs: 1600
    property bool copied: false
    property bool iconOnly: text.length === 0
    signal copyCompleted(string text)
    signal copyFailed()

    implicitWidth: Math.max(32, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(32, contentItem.implicitHeight + topPadding + bottomPadding)
    padding: 6
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption
    text: iconOnly ? "" : (copied ? qsTr("Copied") : qsTr("Copy"))
    ToolTip.visible: hovered
    ToolTip.text: copied ? qsTr("Copied") : qsTr("Copy to clipboard")

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
            text: control.copied ? control.doneGlyph : control.idleGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: control.copied ? Theme.systemSuccess
                 : (control.enabled ? Theme.textPrimary : Theme.textDisabled)
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
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

    background: Rectangle {
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
        border.color: Theme.strokeControl
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
