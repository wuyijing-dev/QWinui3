import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// Button — Fluent / WinUI 3 Button (appearances, icon, loading).
//
//   Button {
//       text: qsTr("Save")
//       leadingSymbol: FluentIcons.Save
//       appearance: "filled"   // filled | subtle | outline | ghost
//       onClicked: save()
//   }
//
//   Button {
//       text: qsTr("Submit")
//       loading: true
//   }
//
// @notes
//   Appearances + optional leading Fluent icon. loading shows BusyIndicator and blocks click.
//   Accent chrome: highlighted: true (or AccentButton).

T.Button {
    id: control

    // Async action in flight — disables click and shows inline ring
    property bool loading: false
    // Visual variant: filled | subtle | outline | ghost | "" (legacy)
    property string appearance: ""
    // Leading FluentIcons symbol (preferred) or raw glyph
    property var leadingSymbol: ""
    property string leadingGlyph: ""
    // Keep width stable while loading (avoids toolbar reflow)
    property bool preserveWidthWhileLoading: true
    property real _loadingWidthCache: 0

    readonly property string _leadingGlyph: {
        var fromSym = IconSource.resolve(leadingSymbol, "")
        if (fromSym.length)
            return fromSym
        return IconSource.resolve(leadingGlyph, "")
    }
    readonly property bool _showLeading: _leadingGlyph.length > 0 && !loading

    onLoadingChanged: {
        if (loading && preserveWidthWhileLoading)
            _loadingWidthCache = implicitWidth
    }

    Accessible.role: Accessible.Button
    Accessible.name: control.text.length ? control.text : qsTr("Button")
    Accessible.description: loading ? qsTr("Loading") : ""
    hoverEnabled: enabled && !loading
    opacity: enabled && !loading ? 1 : (enabled ? 0.72 : 1)

    Accessible.onPressAction: if (control.enabled && !loading) control.clicked()

    PointerCursor {
        shape: enabled && !loading ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    readonly property string _effectiveAppearance: {
        if (control.appearance.length)
            return control.appearance
        if (control.accented)
            return "filled"
        return control.flat ? "subtle" : "filled"
    }

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            loading && preserveWidthWhileLoading && _loadingWidthCache > 0
                                ? _loadingWidthCache : 0)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    spacing: Theme.spacing
    font.pixelSize: Theme.fontBody

    // Use accent chrome
    readonly property bool accented: control.highlighted || control.checked
    // True in light theme
    readonly property bool lightScheme: !Theme.dark

    readonly property color __buttonText: {
        if (control.down) {
            if (control.accented)
                return Theme.textOnAccentSecondary
            return Theme.dark
                ? Qt.rgba(1, 1, 1, 0.7725)
                : Qt.rgba(0, 0, 0, 0.62)
        }
        if (control.accented) {
            if (!control.enabled)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.5302) : Theme.textOnAccent
            return Theme.textOnAccent
        }
        if (!control.enabled)
            return Theme.textDisabled
        return Theme.textPrimary
    }

    readonly property color __fill: {
        var mode = control._effectiveAppearance
        if (control.accented) {
            if (!control.enabled)
                return Theme.dark ? "#28FFFFFF" : "#37000000"
            if (control.down)
                return control.lightScheme
                    ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.2))
                    : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.2))
            if (control.hovered)
                return control.lightScheme
                    ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.1))
                    : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.1))
            return Theme.accent
        }
        if (mode === "ghost") {
            if (!control.enabled)
                return "transparent"
            if (control.down)
                return Theme.fillSubtleTertiary
            if (control.hovered)
                return Theme.fillSubtleSecondary
            return "transparent"
        }
        if (mode === "outline") {
            if (!control.enabled)
                return "transparent"
            if (control.down)
                return Theme.fillSubtleTertiary
            if (control.hovered)
                return Theme.fillSubtleSecondary
            return "transparent"
        }
        if (mode === "subtle") {
            if (control.down)
                return Theme.fillSubtleTertiary
            if (control.hovered)
                return Theme.fillSubtleSecondary
            return "transparent"
        }
        // filled (default)
        if (!control.enabled)
            return Theme.fillControlDisabled
        if (control.down)
            return Theme.fillControlTertiary
        if (control.hovered)
            return Theme.fillControlSecondary
        return Theme.bgControlRest
    }

    readonly property bool __showStroke: {
        var mode = control._effectiveAppearance
        if (control.accented)
            return control.down || !control.enabled
        if (mode === "outline")
            return true
        if (mode === "ghost")
            return control.down || control.hovered
        if (mode === "subtle")
            return control.down || control.hovered
        return !control.flat || control.down || control.hovered
    }

    contentItem: Row {
        spacing: Theme.spacing
        anchors.centerIn: parent

        BusyIndicator {
            visible: control.loading
            running: control.loading
            width: Theme.dp(16)
            height: Theme.dp(16)
            Accessible.ignored: true
        }
        Text {
            visible: control._showLeading
            anchors.verticalCenter: parent.verticalCenter
            text: control._leadingGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: control.__buttonText
            Accessible.ignored: true
        }
        Text {
            visible: control.text.length > 0
            text: control.text
            font: control.font
            color: control.__buttonText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            opacity: control.loading ? 0.72 : 1
            scale: control.down && !Theme.reducedMotion && !control.loading ? 0.98 : 1

            Behavior on color {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down || control.accented)
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion && (control.down || control.hovered) && !control.loading
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }

    background: Item {
        implicitWidth: Math.max(Theme.controlMinWidth, control.contentItem.implicitWidth + 24)
        implicitHeight: Theme.controlHeight
        scale: control.down && !Theme.reducedMotion ? 0.98 : 1

        Behavior on scale {
            enabled: !Theme.reducedMotion && (control.down || control.hovered)
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        Rectangle {
            id: strokeShell
            anchors.fill: parent
            radius: Theme.cornerControl
            visible: control.accented
                     ? true
                     : (control._effectiveAppearance === "filled" || control.__showStroke)

            // Draw solid stroke chrome
            readonly property bool hasSolidStroke: {
                if (control._effectiveAppearance === "outline")
                    return control.enabled
                return !control.flat && control._effectiveAppearance !== "ghost"
                    && (control.down || (!control.enabled && !control.accented)
                        || (Theme.dark && !control.accented))
            }
            // Draw gradient stroke chrome
            readonly property bool hasGradientStroke: control._effectiveAppearance === "filled"
                && !hasSolidStroke && control.enabled && !control.accented
            // WinUI ControlStrokeDefault / Secondary — keep soft, not StrongStroke
            readonly property color topStroke: Theme.dark ? "#12FFFFFF" : "#0F000000"
            // Bottom edge stroke width
            readonly property color bottomStroke: Theme.dark ? "#18FFFFFF" : "#29000000"

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: strokeShell.hasGradientStroke ? strokeShell.topStroke : "transparent"
                }
                GradientStop {
                    position: 0.91
                    color: strokeShell.hasGradientStroke ? strokeShell.topStroke : "transparent"
                }
                GradientStop {
                    position: 1.0
                    color: strokeShell.hasGradientStroke ? strokeShell.bottomStroke : "transparent"
                }
            }

            Rectangle {
                // Content inset
                readonly property bool inset: strokeShell.hasGradientStroke
                x: inset ? 1 : 0
                y: inset ? 1 : 0
                width: inset ? parent.width - 2 : parent.width
                height: inset ? parent.height - 2 : parent.height
                radius: inset ? Theme.cornerControl - 1 : Theme.cornerControl
                border.width: {
                    if (control._effectiveAppearance === "outline")
                        return 1
                    if (control.flat && control._effectiveAppearance !== "outline")
                        return strokeShell.hasSolidStroke ? 1 : 0
                    if (strokeShell.hasGradientStroke)
                        return 0
                    if (control.accented)
                        return control.enabled && !control.down ? 0 : 0
                    return strokeShell.hasSolidStroke ? 1 : 0
                }
                border.color: Theme.strokeControl
                color: control.__fill

                Behavior on color {
                    enabled: !Theme.reducedMotion
                             && (control.hovered || control.down || control.accented
                                 || (!control.flat && control.enabled))
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }

        MouseArea {
            anchors.fill: parent
            enabled: control.loading
            z: 20
            onClicked: function (mouse) { mouse.accepted = true }
        }
    }
}
