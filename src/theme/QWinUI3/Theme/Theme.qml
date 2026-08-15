pragma Singleton
import QtQuick

// Theme — Fluent color / type / motion token singleton.
//
//   import QWinUI3.Theme
//
//   Theme.dark = true
//   Theme.reducedMotion = false
//   Theme.followSystemAccessibility = true
//   Theme.accent = "#005FB8"
//
//   Rectangle {
//       color: Theme.bgCard
//       radius: Theme.cornerControl
//       Behavior on color {
//           ColorAnimation { duration: Theme.duration(Theme.motionNormal) }
//       }
//   }
//   // --- API ---
//   Theme.duration(ms)
//   Theme.controlFill(hovered, pressed, disabled)
//   Theme.accentFill(hovered, pressed, disabled)

QtObject {
    id: root

    // Dark color scheme when true
    property bool dark: false
    // Collapse Theme.duration() animations when true
    property bool reducedMotion: false
    // When true, strengthen borders/focus for high-contrast / accessibility themes.
    property bool highContrast: false
    // When true, Gallery/apps should copy WindowHelper system a11y into the flags above.
    property bool followSystemAccessibility: true

    // Fluent / WinUI 3 system accent (matches FluentWinUI3 defaults)
    readonly property color accent: dark ? "#60CDFF" : "#005FB8"
    // Lighter accent step
    readonly property color accentLight1: dark ? "#6CD0FF" : "#1A6FB8"
    // Darker accent step
    readonly property color accentDark1: dark ? "#4AB4E8" : "#004E99"

    // Primary text brush
    readonly property color textPrimary: dark ? "#FFFFFF" : "#E4000000"
    // Secondary text brush
    readonly property color textSecondary: dark ? "#C5FFFFFF" : "#9E000000"
    // Disabled text brush
    readonly property color textDisabled: dark ? "#5DFFFFFF" : "#5C000000"
    // Text on accent fill
    readonly property color textOnAccent: dark ? "#000000" : "#FFFFFF"
    // Secondary text on accent fill
    readonly property color textOnAccentSecondary: dark ? "#80000000" : "#B3FFFFFF"

    // Control fills — WinUI ControlFillColor*
    readonly property color fillControl: dark ? "#0FFFFFFF" : "#B3FFFFFF"
    // Control fill (hover)
    readonly property color fillControlSecondary: dark ? "#15FFFFFF" : "#80F9F9F9"
    // Control fill (pressed)
    readonly property color fillControlTertiary: dark ? "#08FFFFFF" : "#4DF9F9F9"
    // Control fill (disabled)
    readonly property color fillControlDisabled: dark ? "#0BFFFFFF" : "#4DF9F9F9"
    // Accent fill (rest) — same as accent brush
    readonly property color fillAccent: accent
    // Accent fill (hover)
    readonly property color fillAccentSecondary: dark ? Qt.rgba(accent.r, accent.g, accent.b, 0.9)
                                                      : Qt.rgba(accent.r, accent.g, accent.b, 0.9)
    // Accent fill (pressed)
    readonly property color fillAccentTertiary: dark ? Qt.rgba(accent.r, accent.g, accent.b, 0.8)
                                                     : Qt.rgba(accent.r, accent.g, accent.b, 0.8)
    // Subtle hover/press wash
    readonly property color fillSubtle: dark ? "#0FFFFFFF" : "#0A000000"
    // Subtle secondary wash
    readonly property color fillSubtleSecondary: dark ? "#0BFFFFFF" : "#06000000"
    // Subtle tertiary wash
    readonly property color fillSubtleTertiary: dark ? "#08FFFFFF" : "#05000000"

    // Strokes — ControlStrokeColor*
    readonly property color strokeControl: dark ? "#12FFFFFF" : "#0F000000"
    // Strong control border
    readonly property color strokeControlStrong: dark ? "#8BFFFFFF" : "#9C000000"
    // Stroke on accent-filled controls
    readonly property color strokeControlOnAccent: dark ? "#14FFFFFF" : "#14FFFFFF"
    // Focus ring outer color
    readonly property color focusOuter: dark ? "#FFFFFF" : "#000000"
    // Focus ring inner color
    readonly property color focusInner: dark ? "#000000" : "#FFFFFF"
    // Card border stroke
    readonly property color strokeCard: dark ? "#15FFFFFF" : "#0F000000"
    // Divider stroke
    readonly property color strokeDivider: dark ? "#15FFFFFF" : "#0F000000"

    // Layer / solid backgrounds — LayerFill / SolidBackground
    readonly property color bgLayer: dark ? "#202020" : "#F3F3F3"
    // Alternate layer (zebra / secondary surface)
    readonly property color bgLayerAlt: dark ? "#282828" : "#EEEEEE"
    // Opaque solid window fill (no acrylic/mica)
    readonly property color bgSolid: dark ? "#202020" : "#F3F3F3"
    // Card surface background
    readonly property color bgCard: dark ? "#2C2C2C" : "#FFFFFF"
    // Elevated card (dialog / flyout surface)
    readonly property color bgCardElevated: dark ? "#323232" : "#FFFFFF"
    // Modal smoke / light-dismiss scrim
    readonly property color bgSmoke: dark ? "#4D000000" : "#4D000000"
    // Acrylic / chrome background
    readonly property color bgAcrylic: dark ? "#2C2C2C" : "#F9F9F9"
    // Mica base fill under system backdrop
    readonly property color bgMica: dark ? "#202020" : "#F3F3F3"

    // Attention / info color
    readonly property color systemAttention: accent
    // Success status color
    readonly property color systemSuccess: dark ? "#6CCB5F" : "#0F7B0F"
    // Warning / caution color
    readonly property color systemCaution: dark ? "#FCE100" : "#9D5D00"
    // Error / critical color
    readonly property color systemCritical: dark ? "#FF99A4" : "#C42B1C"
    // Attention banner background
    readonly property color systemAttentionBg: dark ? "#FF272727" : "#FFF3F9FD"
    // Success banner background
    readonly property color systemSuccessBg: dark ? "#FF393D1B" : "#FFDFF6DD"
    // Caution banner background
    readonly property color systemCautionBg: dark ? "#FF433519" : "#FFFFF4CE"
    // Critical banner background
    readonly property color systemCriticalBg: dark ? "#FF442726" : "#FFFDE7E9"

    // Typography — Segoe UI Variable / WinUI type ramp
    readonly property string fontFamily: "Segoe UI Variable"
    // Segoe UI Variable Text face
    readonly property string fontFamilyText: "Segoe UI Variable Text"
    // Segoe UI Variable Display face (large titles)
    readonly property string fontFamilyDisplay: "Segoe UI Variable Display"
    // Fluent Icons font family
    readonly property string fontFamilyIcon: "Segoe Fluent Icons"
    // Caption font size (12)
    readonly property int fontCaption: 12
    // Body font size (14)
    readonly property int fontBody: 14
    // Body Large font size (18)
    readonly property int fontBodyLarge: 18
    // Subtitle font size (20)
    readonly property int fontSubtitle: 20
    // Title font size (28)
    readonly property int fontTitle: 28
    // Title Large font size (40)
    readonly property int fontTitleLarge: 40
    // Regular / normal font weight
    readonly property int fontWeightRegular: Font.Normal
    // Semi-bold weight
    readonly property int fontWeightSemiBold: Font.DemiBold

    // Motion — Windows UI 3 Animation Values
    // Fast motion duration (ms)
    readonly property int motionFast: 83
    // Normal motion duration (ms)
    readonly property int motionNormal: 167
    // Slow motion duration (ms)
    readonly property int motionSlow: 250
    // Flyout / popup enter duration (ms)
    readonly property int motionFlyout: 250
    // Enter easing curve
    readonly property int easingEnter: Easing.OutCubic
    // Exit easing curve
    readonly property int easingExit: Easing.InCubic
    // Standard easing curve
    readonly property int easingStandard: Easing.OutCubic
    // Emphasized easing (slight overshoot)
    readonly property int easingEmphasized: Easing.OutBack

    // Control metrics (FluentWinUI3 Config)
    readonly property real cornerControl: 4
    // Overlay / flyout corner radius
    readonly property real cornerOverlay: 8
    // Default 1px hairline stroke
    readonly property real strokeThin: 1
    // Focus ring outer width
    readonly property real strokeFocusOuter: 2
    // Focus ring inner width
    readonly property real strokeFocusInner: 1
    // Default control height
    readonly property real controlHeight: 36
    // Minimum control width
    readonly property real controlMinWidth: 96
    // SearchBox height
    readonly property real searchBoxHeight: 36
    // Navigation item row height
    readonly property real navItemHeight: 40
    // Expanded NavigationView pane width
    readonly property real navPaneWidth: 280
    // Compact NavigationView pane width
    readonly property real navPaneCompactWidth: 48
    // Horizontal control padding
    readonly property real paddingControlH: 12
    // Vertical control padding
    readonly property real paddingControlV: 7
    // Child spacing
    readonly property real spacing: 8
    // Loose spacing
    readonly property real spacingLoose: 12
    // Section spacing
    readonly property real spacingSection: 24
    // Card corner radius
    readonly property real cornerCard: 8
    // Switch track width
    readonly property real switchWidth: 44
    // Switch track height
    readonly property real switchHeight: 22
    // Switch thumb diameter
    readonly property real switchThumb: 16
    // CheckBox box size
    readonly property real checkSize: 22
    // RadioButton outer size
    readonly property real radioSize: 22
    // Slider track thickness
    readonly property real sliderThickness: 5
    // Slider thumb diameter
    readonly property real sliderThumb: 22

    // Returns ms, or 1 when reducedMotion is on
    function duration(ms) {
        return reducedMotion ? 1 : ms
    }

    // Rest/hover/pressed/disabled control fill helper
    function controlFill(hovered, pressed, disabled) {
        if (disabled)
            return fillControlDisabled
        if (pressed)
            return fillControlTertiary
        if (hovered)
            return fillControlSecondary
        return fillControl
    }

    // Rest/hover/pressed/disabled accent fill helper
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
