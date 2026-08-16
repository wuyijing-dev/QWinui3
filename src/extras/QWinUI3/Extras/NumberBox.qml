import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// NumberBox — Numeric spin/edit with validation (WinUI AcceptsExpression / IsWrapEnabled).
//
//   NumberBox {
//       id: numberBox
//       value: 10; minimum: 0; maximum: 100
//       acceptsExpression: true
//       isWrapEnabled: true
//   }
//
//   // --- API ---
//   // signals: onValueModified
//   // methods: clamp(v), format(v), bump(delta), flashInvalid(), focusField(), commitText(), evalExpression(text)
//   // numberBox.bump(1); numberBox.acceptsExpression
//
// @notes
//   Numeric TextField with spin buttons / wheel / validation.
//   acceptsExpression evaluates +−*/() on commit; isWrapEnabled wraps past min/max when spinning.

T.Control {
    id: root

    // Current value
    property real value: 0
    // Minimum value
    property real minimum: Number.NEGATIVE_INFINITY
    // Maximum value
    property real maximum: Number.POSITIVE_INFINITY
    // Value step (e.g. 0.5 for half stars)
    property real stepSize: 1
    // WinUI SmallChange — alias of stepSize (arrows / spin / wheel)
    property alias smallChange: root.stepSize
    // WinUI LargeChange — used with PageUp/PageDown / wheel+Ctrl
    property real largeChange: 10
    // Decimal places for formatting
    property int decimals: 0
    // Leading text prefix
    property string prefix: ""
    // Trailing text suffix
    property string suffix: ""
    // Header label above the control
    property string header: ""
    // Supporting description text
    property string description: ""
    // Validation error text
    property string errorMessage: ""
    // WinUI HeaderPlacement: top | left
    property string headerPlacement: "top"
    // Label column width when headerPlacement is left
    property real labelWidth: 120
    // Placeholder when empty
    property string placeholderText: ""
    // True when input fails validation
    property bool inputInvalid: false
    readonly property bool _headerLeft: headerPlacement === "left"
    // WinUI SpinButtonPlacementMode: "inline" | "compact" | "hidden"
    property string spinButtonPlacementMode: "inline"
    // WinUI ValidationMode: "invalidInputOverValue" | "disabled"
    property string validationMode: "invalidInputOverValue"
    // Handle mouse-wheel value changes
    property bool acceptWheel: true
    // WinUI AcceptsExpression — allow 1+2*3 style input on commit
    property bool acceptsExpression: false
    // WinUI IsWrapEnabled — wrap past min/max when spinning
    property bool isWrapEnabled: false

    // True when validation failed
    readonly property bool hasError: errorMessage.length > 0 || inputInvalid
    // Emitted when the value is modified by the user
    signal valueModified()

    implicitWidth: 180
    implicitHeight: column.implicitHeight
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.SpinBox
    Accessible.name: header.length ? header : qsTr("Number")
    Accessible.description: {
        var base = hasError
                   ? (errorMessage.length ? errorMessage : qsTr("Invalid value"))
                   : description
        var v = qsTr("Value %1").arg(value)
        return base.length ? (base + ". " + v) : v
    }

    readonly property bool _spinnersVisible: {
        if (spinButtonPlacementMode === "hidden")
            return false
        if (spinButtonPlacementMode === "compact")
            return root.hovered || field.activeFocus || root.visualFocus || shellHover.hovered
        return true
    }

    // Clamp to the valid range
    function clamp(v) {
        return Math.min(root.maximum, Math.max(root.minimum, v))
    }

    // Wrap into [minimum, maximum] when both are finite
    function wrap(v) {
        if (!isFinite(root.minimum) || !isFinite(root.maximum) || root.maximum <= root.minimum)
            return root.clamp(v)
        var span = root.maximum - root.minimum
        var x = Number(v)
        // Bring into range by wrapping (inclusive max maps to min on overflow)
        while (x > root.maximum)
            x -= span
        while (x < root.minimum)
            x += span
        return x
    }

    // Format / formatter callback
    function format(v) {
        return root.prefix + Number(v).toFixed(root.decimals) + root.suffix
    }

    // Safe arithmetic expression (digits, + − * / ( ) . only)
    function evalExpression(text) {
        var s = String(text).replace(/\s+/g, "")
        if (!s.length || !/^[0-9+\-*/().]+$/.test(s))
            return NaN
        try {
            var r = Function("\"use strict\"; return (" + s + ");")()
            return typeof r === "number" && isFinite(r) ? r : NaN
        } catch (e) {
            return NaN
        }
    }

    // Nudge value by one step
    function bump(delta) {
        root.inputInvalid = false
        var next = root.value + delta
        if (root.isWrapEnabled && isFinite(root.minimum) && isFinite(root.maximum)
                && root.maximum > root.minimum) {
            if (next > root.maximum)
                next = root.minimum
            else if (next < root.minimum)
                next = root.maximum
            else
                next = root.wrap(next)
        } else {
            next = root.clamp(next)
        }
        root.value = next
        field.text = root.format(root.value)
        root.valueModified()
    }

    // Flash invalid-input feedback
    function flashInvalid() {
        if (root.validationMode === "disabled")
            return
        root.inputInvalid = true
        invalidTimer.restart()
    }

    // Move keyboard focus to the text field
    function focusField() { field.forceActiveFocus() }

    // Commit edited text
    function commitText() {
        var raw = field.text.replace(root.prefix, "").replace(root.suffix, "").trim()
        if (raw.length === 0 && root.placeholderText.length > 0) {
            field.text = root.format(root.value)
            return
        }
        var n = root.acceptsExpression ? root.evalExpression(raw) : parseFloat(raw)
        if (isNaN(n) && root.acceptsExpression)
            n = parseFloat(raw)
        if (isNaN(n)) {
            root.flashInvalid()
            field.text = root.format(root.value)
            return
        }
        if (n < root.minimum || n > root.maximum) {
            if (root.isWrapEnabled && isFinite(root.minimum) && isFinite(root.maximum)) {
                n = root.wrap(n)
            } else if (root.validationMode === "disabled") {
                root.value = root.clamp(n)
                root.inputInvalid = false
                root.valueModified()
                field.text = root.format(root.value)
                return
            } else {
                root.flashInvalid()
                field.text = root.format(root.value)
                return
            }
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

    contentItem: GridLayout {
        id: grid
        columns: root._headerLeft ? 2 : 1
        columnSpacing: Theme.spacingLoose
        rowSpacing: 4

        Text {
            visible: root.header.length > 0
            Layout.row: 0
            Layout.column: 0
            Layout.fillWidth: !root._headerLeft
            Layout.preferredWidth: root._headerLeft ? root.labelWidth : -1
            Layout.maximumWidth: root._headerLeft ? root.labelWidth : -1
            Layout.alignment: root._headerLeft ? Qt.AlignTop : Qt.AlignLeft
            text: root.header
            font.family: root.font.family
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: root.enabled ? Theme.textPrimary : Theme.textDisabled
            elide: Text.ElideRight
            wrapMode: root._headerLeft ? Text.WordWrap : Text.NoWrap
        }

        ColumnLayout {
            id: column
            Layout.row: root._headerLeft ? 0 : 1
            Layout.column: root._headerLeft ? 1 : 0
            Layout.fillWidth: true
            spacing: 4

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
                        text: FluentIcons.ChevronUp
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 8
                        Accessible.name: qsTr("Increase")
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
                        text: FluentIcons.ChevronDown
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 8
                        Accessible.name: qsTr("Decrease")
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
        } // ColumnLayout column
    } // GridLayout grid
}
