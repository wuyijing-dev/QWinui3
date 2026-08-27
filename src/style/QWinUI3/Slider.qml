import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Slider — Fluent / WinUI 3 styled Slider.
//
//   Slider {
//       from: 0; to: 100; value: 50; stepSize: 25
//       tickMarksVisible: true
//       tickPlacement: "both"   // horizontal: top | bottom | both
//   }
//
//   Slider {
//       orientation: Qt.Vertical
//       height: 220
//       from: 0; to: 100; value: 33; stepSize: 25
//       tickMarksVisible: true
//       tickPlacement: "both"   // vertical: left | right | both
//   }
//
// @notes
//   WinUI-style track fill, ring thumb, and step tick marks on both sides of the track.

T.Slider {
    id: control

    // Draw step ticks (requires stepSize > 0, or auto 10 steps across from..to)
    property bool tickMarksVisible: false
    // Tick side(s): horizontal top|bottom|both · vertical left|right|both · "" → both
    property string tickPlacement: ""
    // Vertical filled track width (WinUI thick active rail)
    property real verticalFillThickness: 8

    readonly property bool _horizontal: orientation === Qt.Horizontal || orientation === undefined
    readonly property real _tickBand: tickMarksVisible ? 10 : 0
    readonly property real _sideGutter: (!_horizontal && tickMarksVisible) ? 14 : 0

    readonly property string _tickPlacement: {
        if (!tickMarksVisible)
            return "none"
        var p = String(tickPlacement || "").toLowerCase()
        if (_horizontal) {
            if (p === "top" || p === "bottom" || p === "both")
                return p
            return "both"
        }
        if (p === "left" || p === "right" || p === "both")
            return p
        return "both"
    }

    readonly property real _step: {
        if (stepSize > 0)
            return stepSize
        if (!tickMarksVisible)
            return 0
        var span = Math.abs(to - from)
        return span > 0 ? span / 10 : 0
    }

    readonly property int _tickCount: {
        if (!tickMarksVisible || _step <= 0)
            return 0
        var span = Math.abs(to - from)
        if (span <= 0)
            return 0
        var n = Math.floor(span / _step + 0.001) + 1
        return Math.min(n, 64)
    }

    function _tickFraction(index) {
        if (_tickCount <= 1)
            return 0.5
        return index / (_tickCount - 1)
    }

    Accessible.role: Accessible.Slider
    Accessible.name: qsTr("Slider")
    Accessible.description: qsTr("%1 of %2").arg(control.value).arg(control.to)

    implicitWidth: _horizontal
                   ? Math.max(200, implicitHandleWidth + leftPadding + rightPadding)
                   : Math.max(Theme.sliderThumb + _sideGutter * 2 + 8,
                               implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: _horizontal
                    ? Math.max(Theme.sliderThumb + _tickBand * 2,
                               implicitHandleHeight + topPadding + bottomPadding)
                    : Math.max(160, implicitHandleHeight + topPadding + bottomPadding)

    padding: 8
    hoverEnabled: true
    live: true
    wheelEnabled: true

    handle: Item {
        x: control.leftPadding + (control._horizontal
           ? control.visualPosition * (control.availableWidth - width)
           : (control.availableWidth - width) / 2)
        y: control.topPadding + (control._horizontal
           ? (control.availableHeight - height) / 2
           : control.visualPosition * (control.availableHeight - height))

        implicitWidth: Theme.sliderThumb
        implicitHeight: Theme.sliderThumb

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Theme.fillSliderThumb
            border.width: 1
            border.color: Theme.strokeControl
            transformOrigin: Item.Center
            scale: control.pressed ? 0.96 : (control.hovered ? 1.12 : 1)

            Behavior on scale {
                enabled: !Theme.reducedMotion && (control.hovered || control.pressed)
                NumberAnimation {
                    duration: Theme.motionMs("fast")
                    easing.type: Theme.motionEasing("standard")
                }
            }

            Rectangle {
                anchors.centerIn: parent
                readonly property real diameter: !control.enabled ? 10
                    : control.pressed ? 8
                    : control.hovered ? 14 : 10
                width: diameter
                height: diameter
                radius: diameter / 2
                color: {
                    if (!control.enabled)
                        return Theme.textDisabled
                    if (control.hovered && !control.pressed)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.902)
                    if (control.pressed)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.8)
                    return Theme.accent
                }

                Behavior on width {
                    enabled: !Theme.reducedMotion && (control.hovered || control.pressed)
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on height {
                    enabled: !Theme.reducedMotion && (control.hovered || control.pressed)
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on color {
                    enabled: !Theme.reducedMotion && (control.hovered || control.pressed)
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: width / 2
        }
    }

    background: Item {
        id: trackHost

        // Match handle's coordinate space so the rail centers on the thumb
        x: control.leftPadding
        y: control.topPadding
        width: control.availableWidth
        height: control.availableHeight
        implicitWidth: control._horizontal ? 200 : Theme.sliderThumb + control._sideGutter * 2
        implicitHeight: control._horizontal ? Theme.sliderThumb + control._tickBand * 2 : 160

        readonly property real trackW: control._horizontal
            ? Math.max(0, width - Theme.sliderThumb)
            : Theme.sliderThickness
        readonly property real trackH: control._horizontal
            ? Theme.sliderThickness
            : Math.max(0, height - Theme.sliderThumb)
        readonly property real trackX: control._horizontal
            ? Theme.sliderThumb / 2
            : (control._sideGutter + (width - control._sideGutter * 2 - trackW) / 2)
        // Same vertical centering as the handle: (availableHeight - size) / 2
        readonly property real trackY: control._horizontal
            ? (height - trackH) / 2
            : Theme.sliderThumb / 2

        // Inactive rail (full span — thin)
        Rectangle {
            id: inactiveRail
            x: trackHost.trackX
            y: trackHost.trackY
            width: trackHost.trackW
            height: trackHost.trackH
            radius: control._horizontal ? height / 2 : width / 2
            color: Theme.dark ? "#15FFFFFF" : "#0F000000"
        }

        // Active fill — ends at thumb center (visualPosition)
        Rectangle {
            id: activeFill
            x: trackHost.trackX + (control._horizontal ? 0 : (trackHost.trackW - width) / 2)
            y: trackHost.trackY + (control._horizontal ? 0 : trackHost.trackH * (1 - control.visualPosition))
            width: control._horizontal
                   ? Math.max(0, trackHost.trackW * control.visualPosition)
                   : control.verticalFillThickness
            height: control._horizontal
                    ? trackHost.trackH
                    : Math.max(0, trackHost.trackH * control.visualPosition)
            radius: control._horizontal ? height / 2 : width / 2
            color: control.enabled ? Theme.accent : Theme.textDisabled

            // No width Behavior — keeps fill locked to the thumb (avoids lag / gap)
            Behavior on height {
                enabled: !control._horizontal && !control.pressed && !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on y {
                enabled: !control._horizontal && !control.pressed && !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        // --- Tick marks (WinUI: both sides of track) ---
        Repeater {
            model: control._horizontal && control._tickCount > 0
                   && (control._tickPlacement === "both" || control._tickPlacement === "top")
                   ? control._tickCount : 0
            delegate: Rectangle {
                required property int index
                width: 2
                height: 7
                radius: 1
                color: Theme.strokeControlStrong
                opacity: 1
                x: trackHost.trackX + trackHost.trackW * control._tickFraction(index) - width / 2
                y: trackHost.trackY - height - 2
            }
        }
        Repeater {
            model: control._horizontal && control._tickCount > 0
                   && (control._tickPlacement === "both" || control._tickPlacement === "bottom")
                   ? control._tickCount : 0
            delegate: Rectangle {
                required property int index
                width: 2
                height: 7
                radius: 1
                color: Theme.strokeControlStrong
                opacity: 1
                x: trackHost.trackX + trackHost.trackW * control._tickFraction(index) - width / 2
                y: trackHost.trackY + trackHost.trackH + 2
            }
        }
        Repeater {
            model: !control._horizontal && control._tickCount > 0
                   && (control._tickPlacement === "both" || control._tickPlacement === "left")
                   ? control._tickCount : 0
            delegate: Rectangle {
                required property int index
                width: 7
                height: 2
                radius: 1
                color: Theme.strokeControlStrong
                opacity: 1
                x: trackHost.trackX - width - 3
                y: trackHost.trackY + trackHost.trackH * (1 - control._tickFraction(index)) - height / 2
            }
        }
        Repeater {
            model: !control._horizontal && control._tickCount > 0
                   && (control._tickPlacement === "both" || control._tickPlacement === "right")
                   ? control._tickCount : 0
            delegate: Rectangle {
                required property int index
                width: 7
                height: 2
                radius: 1
                color: Theme.strokeControlStrong
                opacity: 1
                x: trackHost.trackX + trackHost.trackW + 3
                y: trackHost.trackY + trackHost.trackH * (1 - control._tickFraction(index)) - height / 2
            }
        }
    }
}
