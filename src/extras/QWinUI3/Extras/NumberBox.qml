import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: root

    property real value: 0
    property real minimum: Number.NEGATIVE_INFINITY
    property real maximum: Number.POSITIVE_INFINITY
    property real stepSize: 1
    // WinUI LargeChange — used with PageUp/PageDown
    property real largeChange: 10
    property int decimals: 0
    property string prefix: ""
    property string suffix: ""
    property bool inputInvalid: false
    // WinUI SpinButtonPlacementMode: "inline" | "compact" | "hidden"
    property string spinButtonPlacementMode: "inline"

    signal valueModified()

    implicitWidth: 140
    implicitHeight: Theme.controlHeight
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    readonly property bool _spinnersVisible: {
        if (spinButtonPlacementMode === "hidden")
            return false
        if (spinButtonPlacementMode === "compact")
            return root.hovered || field.activeFocus || root.visualFocus
        return true
    }

    function clamp(v) {
        return Math.min(root.maximum, Math.max(root.minimum, v))
    }

    function format(v) {
        return root.prefix + Number(v).toFixed(root.decimals) + root.suffix
    }

    function bump(delta) {
        root.inputInvalid = false
        root.value = root.clamp(root.value + delta)
        field.text = root.format(root.value)
        root.valueModified()
    }

    function flashInvalid() {
        root.inputInvalid = true
        invalidTimer.restart()
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Up) {
            bump(stepSize)
            event.accepted = true
        } else if (event.key === Qt.Key_Down) {
            bump(-stepSize)
            event.accepted = true
        } else if (event.key === Qt.Key_PageUp) {
            bump(largeChange)
            event.accepted = true
        } else if (event.key === Qt.Key_PageDown) {
            bump(-largeChange)
            event.accepted = true
        }
    }

    Timer {
        id: invalidTimer
        interval: 1200
        onTriggered: root.inputInvalid = false
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: {
            if (!root.enabled)
                return Theme.dark ? "#0BFFFFFF" : "#4DF9F9F9"
            if (field.activeFocus)
                return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
            if (root.hovered)
                return Theme.fillControlSecondary
            return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
        }
        border.width: root.inputInvalid ? 2 : 1
        border.color: root.inputInvalid ? Theme.systemCritical : Theme.strokeControl

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on border.color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        Rectangle {
            id: underline
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: field.activeFocus || root.inputInvalid ? 2 : 1
            color: root.inputInvalid ? Theme.systemCritical
                 : (field.activeFocus ? Theme.accent : Theme.strokeControl)
            opacity: field.activeFocus || root.inputInvalid ? 1 : 0.85

            Behavior on height {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            transform: Scale {
                origin.x: underline.width / 2
                xScale: (field.activeFocus || root.inputInvalid) ? 1
                      : (Theme.reducedMotion ? 1 : 0.28)
                Behavior on xScale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }
    }

    contentItem: RowLayout {
        spacing: 0

        TextField {
            id: field
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: root.format(root.value)
            horizontalAlignment: TextInput.AlignRight
            leftPadding: Theme.paddingControlH
            rightPadding: 8
            background: Item {}
            validator: DoubleValidator {
                bottom: root.minimum === Number.NEGATIVE_INFINITY ? -1e12 : root.minimum
                top: root.maximum === Number.POSITIVE_INFINITY ? 1e12 : root.maximum
                decimals: root.decimals
            }
            onEditingFinished: {
                var raw = text.replace(root.prefix, "").replace(root.suffix, "")
                var n = parseFloat(raw)
                if (isNaN(n) || n < root.minimum || n > root.maximum) {
                    root.flashInvalid()
                    text = root.format(root.value)
                    return
                }
                root.inputInvalid = false
                root.value = root.clamp(n)
                root.valueModified()
                text = root.format(root.value)
            }
            onTextEdited: {
                if (root.inputInvalid)
                    root.inputInvalid = false
            }
        }

        Rectangle {
            visible: root._spinnersVisible
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            Layout.topMargin: 6
            Layout.bottomMargin: 6
            color: Theme.strokeDivider
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        ColumnLayout {
            visible: root._spinnersVisible
            Layout.preferredWidth: 28
            Layout.fillHeight: true
            spacing: 0
            opacity: root._spinnersVisible ? 1 : 0

            ToolButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "\uE70E"
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 8
                onClicked: root.bump(root.stepSize)
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.strokeDivider
            }
            ToolButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "\uE70D"
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 8
                onClicked: root.bump(-root.stepSize)
            }
        }
    }
}
