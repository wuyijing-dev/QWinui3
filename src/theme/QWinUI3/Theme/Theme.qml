pragma Singleton
import QtQuick

QtObject {
    id: root

    property bool dark: false
    property bool reducedMotion: false
    // When true, strengthen borders/focus for high-contrast / accessibility themes.
    property bool highContrast: false
    // When true, Gallery/apps should copy WindowHelper system a11y into the flags above.
    property bool followSystemAccessibility: true

    // Fluent / WinUI 3 system accent (matches FluentWinUI3 defaults)
    readonly property color accent: dark ? "#60CDFF" : "#005FB8"
    readonly property color accentLight1: dark ? "#6CD0FF" : "#1A6FB8"
    readonly property color accentDark1: dark ? "#4AB4E8" : "#004E99"

    readonly property color textPrimary: dark ? "#FFFFFF" : "#E4000000"
    readonly property color textSecondary: dark ? "#C5FFFFFF" : "#9E000000"
    readonly property color textDisabled: dark ? "#5DFFFFFF" : "#5C000000"
    readonly property color textOnAccent: dark ? "#000000" : "#FFFFFF"
    readonly property color textOnAccentSecondary: dark ? "#80000000" : "#B3FFFFFF"

    // Control fills — WinUI ControlFillColor*
    readonly property color fillControl: dark ? "#0FFFFFFF" : "#B3FFFFFF"
    readonly property color fillControlSecondary: dark ? "#15FFFFFF" : "#80F9F9F9"
    readonly property color fillControlTertiary: dark ? "#08FFFFFF" : "#4DF9F9F9"
    readonly property color fillControlDisabled: dark ? "#0BFFFFFF" : "#4DF9F9F9"
    readonly property color fillAccent: accent
    readonly property color fillAccentSecondary: dark ? Qt.rgba(accent.r, accent.g, accent.b, 0.9)
                                                      : Qt.rgba(accent.r, accent.g, accent.b, 0.9)
    readonly property color fillAccentTertiary: dark ? Qt.rgba(accent.r, accent.g, accent.b, 0.8)
                                                     : Qt.rgba(accent.r, accent.g, accent.b, 0.8)
    readonly property color fillSubtle: dark ? "#0FFFFFFF" : "#0A000000"
    readonly property color fillSubtleSecondary: dark ? "#0BFFFFFF" : "#06000000"
    readonly property color fillSubtleTertiary: dark ? "#08FFFFFF" : "#05000000"

    // Strokes — ControlStrokeColor*
    readonly property color strokeControl: dark ? "#12FFFFFF" : "#0F000000"
    readonly property color strokeControlStrong: dark ? "#8BFFFFFF" : "#9C000000"
    readonly property color strokeControlOnAccent: dark ? "#14FFFFFF" : "#14FFFFFF"
    readonly property color focusOuter: dark ? "#FFFFFF" : "#000000"
    readonly property color focusInner: dark ? "#000000" : "#FFFFFF"
    readonly property color strokeCard: dark ? "#15FFFFFF" : "#0F000000"
    readonly property color strokeDivider: dark ? "#15FFFFFF" : "#0F000000"

    // Layer / solid backgrounds — LayerFill / SolidBackground
    readonly property color bgLayer: dark ? "#202020" : "#F3F3F3"
    readonly property color bgLayerAlt: dark ? "#282828" : "#EEEEEE"
    readonly property color bgSolid: dark ? "#202020" : "#F3F3F3"
    readonly property color bgCard: dark ? "#2C2C2C" : "#FFFFFF"
    readonly property color bgCardElevated: dark ? "#323232" : "#FFFFFF"
    readonly property color bgSmoke: dark ? "#4D000000" : "#4D000000"
    readonly property color bgAcrylic: dark ? "#2C2C2C" : "#F9F9F9"
    readonly property color bgMica: dark ? "#202020" : "#F3F3F3"

    readonly property color systemAttention: accent
    readonly property color systemSuccess: dark ? "#6CCB5F" : "#0F7B0F"
    readonly property color systemCaution: dark ? "#FCE100" : "#9D5D00"
    readonly property color systemCritical: dark ? "#FF99A4" : "#C42B1C"
    readonly property color systemAttentionBg: dark ? "#FF272727" : "#FFF3F9FD"
    readonly property color systemSuccessBg: dark ? "#FF393D1B" : "#FFDFF6DD"
    readonly property color systemCautionBg: dark ? "#FF433519" : "#FFFFF4CE"
    readonly property color systemCriticalBg: dark ? "#FF442726" : "#FFFDE7E9"

    // Typography — Segoe UI Variable / WinUI type ramp
    readonly property string fontFamily: "Segoe UI Variable"
    readonly property string fontFamilyText: "Segoe UI Variable Text"
    readonly property string fontFamilyDisplay: "Segoe UI Variable Display"
    readonly property string fontFamilyIcon: "Segoe Fluent Icons"
    readonly property int fontCaption: 12
    readonly property int fontBody: 14
    readonly property int fontBodyLarge: 18
    readonly property int fontSubtitle: 20
    readonly property int fontTitle: 28
    readonly property int fontTitleLarge: 40
    readonly property int fontWeightRegular: Font.Normal
    readonly property int fontWeightSemiBold: Font.DemiBold

    // Motion — Windows UI 3 Animation Values
    readonly property int motionFast: 83
    readonly property int motionNormal: 167
    readonly property int motionSlow: 250
    readonly property int motionFlyout: 250
    readonly property int easingEnter: Easing.OutCubic
    readonly property int easingExit: Easing.InCubic
    readonly property int easingStandard: Easing.OutCubic
    readonly property int easingEmphasized: Easing.OutBack

    // Control metrics (FluentWinUI3 Config)
    readonly property real cornerControl: 4
    readonly property real cornerOverlay: 8
    readonly property real strokeThin: 1
    readonly property real strokeFocusOuter: 2
    readonly property real strokeFocusInner: 1
    readonly property real controlHeight: 36
    readonly property real controlMinWidth: 96
    readonly property real searchBoxHeight: 36
    readonly property real navItemHeight: 40
    readonly property real navPaneWidth: 280
    readonly property real navPaneCompactWidth: 48
    readonly property real paddingControlH: 12
    readonly property real paddingControlV: 7
    readonly property real spacing: 8
    readonly property real spacingLoose: 12
    readonly property real spacingSection: 24
    readonly property real cornerCard: 8
    readonly property real switchWidth: 44
    readonly property real switchHeight: 22
    readonly property real switchThumb: 16
    readonly property real checkSize: 22
    readonly property real radioSize: 22
    readonly property real sliderThickness: 5
    readonly property real sliderThumb: 22

    function duration(ms) {
        return reducedMotion ? 1 : ms
    }

    function controlFill(hovered, pressed, disabled) {
        if (disabled)
            return fillControlDisabled
        if (pressed)
            return fillControlTertiary
        if (hovered)
            return fillControlSecondary
        return fillControl
    }

    function accentFill(hovered, pressed, disabled) {
        if (disabled)
            return fillControlDisabled
        if (pressed)
            return fillAccentTertiary
        if (hovered)
            return fillAccentSecondary
        return fillAccent
    }
}
