import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// RatingControl — Star rating; stepSize supports halves (WinUI InitialSetValue / ItemInfo).
//
//   RatingControl {
//       id: ratingControl
//       value: 0
//       initialSetValue: 3
//       stepSize: 0.5
//       emptyGlyph: FluentIcons.OutlineStar
//       filledGlyph: FluentIcons.FavoriteStarFill
//   }
//
//   // --- API ---
//   // signals: onValueEdited
//   // methods: clampValue(v), valueFromPos(x), commitValue(next)
//
// @notes
//   Star rating; value / maxRating; isReadOnly disables input.
//   initialSetValue applies on first pick when value is unset; empty/filled/placeholder glyphs customize ItemInfo.

T.Control {
    id: root

    // Current value
    property real value: 0
    // Shown when value unset
    property real placeholderValue: -1
    // WinUI InitialSetValue — used for the first commit when value is unset (≤0)
    property real initialSetValue: -1
    // Maximum star count
    property int maxRating: 5
    // Read-only when true
    property bool readOnly: false
    // Alias of readOnly
    property alias isReadOnly: root.readOnly
    // Allow clearing the rating
    property bool isClearEnabled: true
    // 1 = whole, 0.5 = half, 0.1 / 0.25 = fine-grained mouse pick
    property real stepSize: 0.5
    // Preview value on hover
    property bool previewEnabled: true
    // Hovered preview value
    property real previewValue: -1
    // Caption under / beside the value
    property string caption: ""
    // WinUI ItemInfo — empty / outline glyph
    property string emptyGlyph: ""
    // WinUI ItemInfo — filled glyph
    property string filledGlyph: ""
    // Glyph used for placeholder (unset) fill
    property string placeholderGlyph: ""
    // WinUI RatingItemInfo.DisabledGlyph — used when !enabled
    property string disabledGlyph: ""

    // Emitted when user commits a value
    signal valueEdited(real value)

    readonly property string _emptyGlyph: emptyGlyph.length ? emptyGlyph : FluentIcons.OutlineStar
    readonly property string _filledGlyph: filledGlyph.length ? filledGlyph : FluentIcons.FavoriteStarFill
    readonly property string _placeholderGlyph: placeholderGlyph.length ? placeholderGlyph : _filledGlyph
    readonly property string _disabledGlyph: disabledGlyph.length ? disabledGlyph : _emptyGlyph

    implicitWidth: Math.max(28 * maxRating + 2 * Math.max(0, maxRating - 1), 28)
    implicitHeight: caption.length ? (Theme.controlHeight + Theme.fontCaption + 4) : Theme.controlHeight
    hoverEnabled: true
    padding: 0
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: !readOnly && enabled
    font.family: Theme.fontFamilyIcon
    font.pixelSize: 18
    Accessible.role: Accessible.Slider
    Accessible.name: caption.length ? caption : qsTr("Rating")
    Accessible.description: qsTr("%1 of %2").arg(Math.round(value * 10) / 10).arg(maxRating)
    Keys.onLeftPressed: nudge(-1)
    Keys.onRightPressed: nudge(1)
    Keys.onDownPressed: nudge(-1)
    Keys.onUpPressed: nudge(1)
    // Keys has no onHomePressed / onEndPressed — handle via onPressed
    Keys.onPressed: function (event) {
        if (readOnly || !enabled)
            return
        if (event.key === Qt.Key_Home) {
            commitValue(isClearEnabled ? 0 : clampValue(stepSize))
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            commitValue(maxRating)
            event.accepted = true
        }
    }

    WheelHandler {
        enabled: !root.readOnly && root.enabled
        onWheel: function (event) {
            var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
            if (dir === 0)
                return
            root.nudge(dir > 0 ? 1 : -1)
            event.accepted = true
        }
    }

    function nudge(dir) {
        if (readOnly || !enabled)
            return
        commitValue(clampValue(value + dir * Math.max(0.01, stepSize)))
    }

    readonly property real _displayValue: {
        if (!readOnly && previewEnabled && previewValue >= 0)
            return previewValue
        if (value <= 0 && placeholderValue > 0)
            return placeholderValue
        return value
    }

    // Clamp value into min..max
    function clampValue(v) {
        var max = Math.max(1, maxRating)
        var x = Math.max(0, Math.min(max, Number(v)))
        var step = Math.max(0.01, stepSize)
        if (x <= 0)
            return 0
        var snapped = Math.round(x / step) * step
        if (snapped > max)
            snapped = max
        if (snapped < 0)
            snapped = 0
        return Math.round(snapped * 1000) / 1000
    }

    // Map a pointer position to a value
    function valueFromPos(x) {
        var w = Math.max(1, starsRow.width)
        // Map pointer into [0, maxRating]; tiny left margin clears when clear enabled
        if (x <= 2 && isClearEnabled)
            return 0
        var ratio = Math.max(0, Math.min(1, x / w))
        return clampValue(ratio * maxRating)
    }

    // Commit the edited value
    function commitValue(next) {
        var v = clampValue(next)
        // First set: prefer InitialSetValue when unset
        if (value <= 0 && initialSetValue > 0 && v > 0)
            v = clampValue(initialSetValue)
        else if (isClearEnabled && value > 0
                && Math.abs(value - v) < Math.max(stepSize * 0.5, 0.05)) {
            v = 0
        }
        value = v
        valueEdited(value)
        previewValue = -1
    }

    contentItem: Column {
        spacing: 4

        Text {
            visible: root.caption.length > 0
            text: root.caption
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }

        Item {
            id: body
            width: starsRow.implicitWidth
            height: 28
            implicitWidth: starsRow.implicitWidth
            implicitHeight: 28

            FocusStroke {
                anchors.fill: parent
                anchors.margins: -4
                show: root.visualFocus
                frameRadius: Theme.cornerControl
            }

            Row {
                id: starsRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Repeater {
                    model: root.maxRating
                    Item {
                        id: star
                        required property int index
                        width: 28
                        height: 28

                        // Fill color / fill factor
                        readonly property real fill: {
                            var v = root._displayValue
                            var i = index + 1
                            if (v >= i)
                                return 1
                            if (v <= i - 1)
                                return 0
                            return v - (i - 1)
                        }
                        // True when showing placeholder
                        readonly property bool isPlaceholder: root.value <= 0
                                                             && root.placeholderValue > 0
                                                             && root.previewValue < 0

                        Text {
                            anchors.centerIn: parent
                            text: root.enabled ? root._emptyGlyph : root._disabledGlyph
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: root.font.pixelSize
                            color: Theme.textSecondary
                            opacity: root.enabled ? (star.isPlaceholder ? 0.4 : 0.85) : 0.55
                        }

                        // Filled portion (left → right clip)
                        Item {
                            width: star.width * star.fill
                            height: star.height
                            clip: true
                            visible: root.enabled || star.fill > 0

                            Text {
                                width: star.width
                                height: star.height
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: !root.enabled ? root._disabledGlyph
                                      : (star.isPlaceholder ? root._placeholderGlyph : root._filledGlyph)
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: root.font.pixelSize
                                color: star.isPlaceholder || !root.enabled ? Theme.textSecondary : Theme.systemCaution
                                opacity: root.enabled ? 1 : 0.55
                            }
                        }

                        scale: {
                            if (root.readOnly || !root.enabled || root.previewValue < 0)
                                return 1
                            return (index + 1) <= Math.ceil(root.previewValue) ? 1.08 : 1
                        }
                        Behavior on scale {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.duration(Theme.motionFast)
                                easing.type: Theme.easingStandard
                            }
                        }
                    }
                }
            }

            MouseArea {
                id: ma
                anchors.fill: starsRow
                enabled: !root.readOnly && root.enabled
                hoverEnabled: root.previewEnabled && !root.readOnly && root.enabled
                preventStealing: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                // True after a drag gesture
                property bool didDrag: false
                // Value captured on press
                property real pressValue: -1

                onPositionChanged: (mouse) => {
                    if (!enabled)
                        return
                    root.previewValue = root.valueFromPos(mouse.x)
                    if (pressed)
                        didDrag = true
                }
                onExited: {
                    if (!pressed)
                        root.previewValue = -1
                }
                onPressed: (mouse) => {
                    didDrag = false
                    pressValue = root.valueFromPos(mouse.x)
                    root.previewValue = pressValue
                }
                onReleased: (mouse) => {
                    var next = root.valueFromPos(mouse.x)
                    root.commitValue(next)
                    didDrag = false
                }
                onCanceled: {
                    root.previewValue = -1
                    didDrag = false
                }
            }
        }
    }

    background: Item {}
}
