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
    // WinUI LargeChange — used with PageUp/PageDown / wheel+Ctrl
    property real largeChange: 10
    property int decimals: 0
    property string prefix: ""
    property string suffix: ""
    property string header: ""
    property string description: ""
    property string errorMessage: ""
    property string placeholderText: ""
    property bool inputInvalid: false
    // WinUI SpinButtonPlacementMode: "inline" | "compact" | "hidden"
    property string spinButtonPlacementMode: "inline"
    // WinUI ValidationMode: "invalidInputOverValue" | "disabled"
    property string validationMode: "invalidInputOverValue"
    property bool acceptWheel: true

    readonly property bool hasError: errorMessage.length > 0 || inputInvalid
    signal valueModified()

    implicitWidth: 180
    implicitHeight: column.implicitHeight
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.SpinBox
    Accessible.name: header.length ? header : qsTr("Number")
    Accessible.value: value
    Accessible.description: hasError ? (errorMessage.length ? errorMessage : qsTr("Invalid value"))
                                     : description

    readonly property bool _spinnersVisible: {
        if (spinButtonPlacementMode === "hidden")
            return false
        if (spinButtonPlacementMode === "compact")
            return root.hovered || field.activeFocus || root.visualFocus || shellHover.hovered
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
        if (root.validationMode === "disabled")
            return
        root.inputInvalid = true
        invalidTimer.restart()
    }

    function commitText() {
        var raw = field.text.replace(root.prefix, "").replace(root.suffix, "").trim()
        if (raw.length === 0 && root.placeholderText.length > 0) {
            field.text = root.format(root.value)
            return
        }
        var n = parseFloat(raw)
        if (isNaN(n)) {
            root.flashInvalid()
            field.text = root.format(root.value)
            return
        }
        if (n < root.minimum || n > root.maximum) {
            if (root.validationMode === "disabled") {
                root.value = root.clamp(n)
                root.inputInvalid = false
                root.valueModified()
                field.text = root.format(root.value)
                return
            }
            root.flashInvalid()
            field.text = root.format(root.value)
            return
        }
        root.inputInvalid = false
        root.value = root.clamp(n)
        root.valueModified()
        field.text = root.format(root.value)
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

    background: Item {}

    contentItem: ColumnLayout {
        id: column
        spacing: 4

        Text {
            visible: root.header.length > 0
            Layout.fillWidth: true
            text: root.header
            font.family: root.font.family
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: root.enabled ? Theme.textPrimary : Theme.textDisabled
            elide: Text.ElideRight
        }

        Text {
            visible: root.description.length > 0 && !root.hasError
            Layout.fillWidth: true
            text: root.description
            font.family: root.font.family
            font.pixelSize: Theme.fontCaption
            color: root.enabled ? Theme.textSecondary : Theme.textDisabled
            wrapMode: Text.Wrap
        }

        Item {
            id: shell
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.controlHeight
            Layout.preferredWidth: 140
            HoverHandler { id: shellHover }

            WheelHandler {
                enabled: root.acceptWheel && root.enabled
                onWheel: function (event) {
                    var delta = event.angleDelta.y !== 0 ? event.angleDelta.y : event.pixelDelta.y
                    if (delta === 0)
                        return
                    var step = (event.modifiers & Qt.ControlModifier) ? root.largeChange : root.stepSize
                    root.bump(delta > 0 ? step : -step)
                    event.accepted = true
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: Theme.cornerControl
                color: {
                    if (!root.enabled)
                        return Theme.dark ? "#0BFFFFFF" : "#4DF9F9F9"
                    if (field.activeFocus)
                        return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
                    if (root.hovered || shellHover.hovered)
                        return Theme.fillControlSecondary
                    return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
                }
                border.width: root.hasError ? 2 : 1
                border.color: root.hasError ? Theme.systemCritical : Theme.strokeControl

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
                    height: field.activeFocus || root.hasError ? 2 : 1
                    color: root.hasError ? Theme.systemCritical
                         : (field.activeFocus ? Theme.accent : Theme.strokeControl)
                    opacity: field.activeFocus || root.hasError ? 1 : 0.85

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
                        xScale: (field.activeFocus || root.hasError) ? 1
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

            RowLayout {
                anchors.fill: parent
                spacing: 0

                TextField {
                    id: field
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: root.format(root.value)
                    placeholderText: root.placeholderText
                    horizontalAlignment: TextInput.AlignRight
                    leftPadding: Theme.paddingControlH
                    rightPadding: 8
                    background: Item {}
                    validator: DoubleValidator {
                        bottom: root.minimum === Number.NEGATIVE_INFINITY ? -1e12 : root.minimum
                        top: root.maximum === Number.POSITIVE_INFINITY ? 1e12 : root.maximum
                        decimals: root.decimals
                    }
                    onEditingFinished: root.commitText()
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
                }

                ColumnLayout {
                    visible: root._spinnersVisible
                    Layout.preferredWidth: 28
                    Layout.fillHeight: true
                    spacing: 0

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

        Text {
            visible: root.errorMessage.length > 0 || root.inputInvalid
            Layout.fillWidth: true
            text: root.errorMessage.length > 0
                  ? root.errorMessage
                  : qsTr("Enter a value between %1 and %2")
                        .arg(root.minimum === Number.NEGATIVE_INFINITY ? "−∞" : root.minimum)
                        .arg(root.maximum === Number.POSITIVE_INFINITY ? "+∞" : root.maximum)
            font.family: root.font.family
            font.pixelSize: Theme.fontCaption
            color: Theme.systemCritical
            wrapMode: Text.Wrap
        }
    }
}
