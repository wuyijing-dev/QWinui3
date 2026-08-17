import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// AnimatedIcon — Thin state glyph swap (1.53). Not Lottie / WinUI AnimatedIcon parity.
//
//   AnimatedIcon {
//       id: playIcon
//       checked: playing
//       symbol: FluentIcons.Play
//       symbolChecked: FluentIcons.Pause
//       accessibleName: playing ? qsTr("Pause") : qsTr("Play")
//   }
//
//   // Multi-state map:
//   AnimatedIcon {
//       iconState: expanded ? "open" : "closed"
//       iconStates: [
//           { name: "closed", symbol: FluentIcons.ChevronDown },
//           { name: "open", symbol: FluentIcons.ChevronUp }
//       ]
//   }
//
//   // --- API ---
//   // iconState / iconStates / checked / symbol / symbolChecked / fontSize / iconColor
//   // microMotionEnabled (1.49) · honors Theme.reducedMotion
//
// @notes
//   Crossfade + light scale between FluentIcons glyphs. Experimental — no Lottie runtime.
//   Prefer named FluentIcons; set accessibleName (never the raw PUA glyph).
//   Uses iconState/iconStates (not Item.state/states) to avoid Qt Quick state machine clash.

Item {
    id: root

    // Current state key ("" → use checked / normal). Not Item.state.
    property string iconState: ""
    // Optional multi-state table: [{ name, symbol|glyph }, …]. Not Item.states.
    property var iconStates: []
    // Two-state convenience (when iconStates is empty)
    property bool checked: false
    // FluentIcons for unchecked / normal
    property var symbol: ""
    // FluentIcons for checked
    property var symbolChecked: ""
    // Raw glyph fallbacks
    property string glyph: ""
    property string glyphChecked: ""
    // Font size in px
    property real fontSize: 20
    // Icon color
    property color iconColor: Theme.textPrimary
    // Mirror glyph for RTL
    property bool mirrorGlyph: false
    // Font weight
    property int fontWeight: Theme.fontWeightRegular
    // Tooltip text
    property string toolTipText: ""
    // Accessible name override
    property string accessibleName: ""
    // Hover/press micro-motion on the visible glyph (1.49)
    property bool microMotionEnabled: true
    property real hoverScale: 1.06
    property real pressScale: 0.92
    // Transition scale kick (1 = none); ignored when Theme.reducedMotion
    property real transitionScale: 0.86

    readonly property string effectiveState: {
        if (root.iconState.length)
            return root.iconState
        return root.checked ? "checked" : "normal"
    }

    readonly property string effectiveGlyph: {
        var list = root.iconStates
        if (list && list.length) {
            var key = root.effectiveState
            for (var i = 0; i < list.length; ++i) {
                var e = list[i]
                if (!e)
                    continue
                if (String(e.name || "") === key) {
                    var fromSym = IconSource.resolve(e.symbol !== undefined ? e.symbol : "", "")
                    if (fromSym.length)
                        return fromSym
                    return IconSource.resolve(e.glyph !== undefined ? e.glyph : "", FluentIcons.Placeholder)
                }
            }
        }
        if (root.effectiveState === "checked" || root.checked) {
            var checkedSym = IconSource.resolve(root.symbolChecked, "")
            if (checkedSym.length)
                return checkedSym
            var checkedGlyph = IconSource.resolve(root.glyphChecked, "")
            if (checkedGlyph.length)
                return checkedGlyph
        }
        var normalSym = IconSource.resolve(root.symbol, "")
        if (normalSym.length)
            return normalSym
        return IconSource.resolve(root.glyph, FluentIcons.Placeholder)
    }

    readonly property real effectiveIconScale: {
        if (!root.microMotionEnabled || Theme.reducedMotion || !root.enabled)
            return root._transitScale
        if (press.pressed)
            return root.pressScale * root._transitScale
        if (hover.hovered)
            return root.hoverScale * root._transitScale
        return root._transitScale
    }

    property real _transitScale: 1
    property string _shownGlyph: ""

    implicitWidth: Math.ceil(fontSize * 1.25)
    implicitHeight: Math.ceil(fontSize * 1.25)
    width: implicitWidth
    height: implicitHeight
    Accessible.role: Accessible.Graphic
    Accessible.name: {
        if (root.accessibleName.length)
            return root.accessibleName
        if (root.toolTipText.length)
            return root.toolTipText
        return ""
    }
    Accessible.ignored: root.accessibleName.length === 0 && root.toolTipText.length === 0

    Component.onCompleted: root._shownGlyph = root.effectiveGlyph
    onEffectiveGlyphChanged: root._applyGlyph(root.effectiveGlyph)

    function _applyGlyph(next) {
        if (!next || next === root._shownGlyph)
            return
        if (Theme.reducedMotion) {
            root._shownGlyph = next
            root._transitScale = 1
            glyphText.opacity = 1
            return
        }
        // Quick squash → swap → restore
        transitAnim.stop()
        root._transitScale = root.transitionScale
        glyphText.opacity = 0.35
        swapTimer.restart()
    }

    Timer {
        id: swapTimer
        interval: Math.max(1, Math.floor(Theme.duration(Theme.motionFast) * 0.45))
        repeat: false
        onTriggered: {
            root._shownGlyph = root.effectiveGlyph
            transitAnim.start()
        }
    }

    ParallelAnimation {
        id: transitAnim
        NumberAnimation {
            target: root
            property: "_transitScale"
            to: 1
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
        NumberAnimation {
            target: glyphText
            property: "opacity"
            to: 1
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    HoverHandler {
        id: hover
        enabled: root.microMotionEnabled || root.toolTipText.length > 0
    }
    TapHandler {
        id: press
        enabled: root.microMotionEnabled
        acceptedButtons: Qt.LeftButton
        gesturePolicy: TapHandler.WithinBounds
    }
    ToolTip.visible: hover.hovered && root.toolTipText.length > 0
    ToolTip.text: root.toolTipText
    ToolTip.delay: 400

    Text {
        id: glyphText
        anchors.centerIn: parent
        text: root._shownGlyph.length ? root._shownGlyph : root.effectiveGlyph
        font.family: Theme.fontFamilyIcon
        font.pixelSize: root.fontSize
        font.weight: root.fontWeight
        color: root.enabled ? root.iconColor : Theme.textDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
        scale: root.effectiveIconScale
        transform: Scale {
            origin.x: glyphText.width / 2
            origin.y: glyphText.height / 2
            xScale: root.mirrorGlyph ? -1 : 1
        }

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
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
