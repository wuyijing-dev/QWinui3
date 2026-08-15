import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// InfoBadge — Count / status / glyph badge.
//
//   InfoBadge { value: 3; severity: informational }

T.Control {
    id: root

    // Informational severity constant
    readonly property int informational: 0
    // Success severity constant
    readonly property int success: 1
    // Warning severity constant
    readonly property int warning: 2
    // Error severity constant
    readonly property int error: 3
    // Attention severity constant
    readonly property int attention: 4
    // Neutral severity constant
    readonly property int neutral: 5

    // informational | success | warning | error | attention | neutral
    property int severity: error
    // Numeric count; shown when text/symbol are empty (clamped by maxValue)
    property int value: 0
    // Explicit badge label (wins over value)
    property string text: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Clamp / overflow threshold for counts
    property int maxValue: 99
    // Badge fill color
    property color badgeColor: {
        switch (severity) {
        case success: return Theme.systemSuccess
        case warning: return Theme.systemCaution
        case informational:
        case attention: return Theme.systemAttention
        case neutral: return Theme.dark ? "#8BFFFFFF" : "#9C000000"
        default: return Theme.systemCritical
        }
    }
    // Badge / content text color
    property color textColor: {
        if (severity === warning)
            return Theme.dark ? "#000000" : "#000000"
        if (severity === neutral)
            return Theme.textOnAccent
        return Theme.textOnAccent
    }

    // Severity as string name
    readonly property string severityName: {
        switch (severity) {
        case success: return "success"
        case warning: return "warning"
        case informational: return "informational"
        case attention: return "attention"
        case neutral: return "neutral"
        default: return "error"
        }
    }

    // Set Severity Name
    function setSeverityName(name) {
        switch (String(name).toLowerCase()) {
        case "success": severity = success; break
        case "warning": severity = warning; break
        case "informational": severity = informational; break
        case "attention": severity = attention; break
        case "neutral": severity = neutral; break
        default: severity = error; break
        }
    }

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)
    // Dot
    property bool dot: displayText.length === 0 && effectiveIconGlyph.length === 0
    // Hide when value/text empty
    property bool hideWhenEmpty: false

    // Text shown to the user
    readonly property string displayText: {
        if (effectiveIconGlyph.length > 0)
            return ""
        if (text.length > 0)
            return text
        if (value <= 0)
            return ""
        return value > maxValue ? (maxValue + "+") : String(value)
    }

    // True when there is no data
    readonly property bool isEmpty: value <= 0 && text.length === 0 && effectiveIconGlyph.length === 0
    // Open / visible state
    readonly property bool isOpen: opacity > 0.01

    opacity: (hideWhenEmpty && isEmpty) ? 0 : 1
    visible: opacity > 0.01

    implicitWidth: Math.max(dot ? 10 : 18, label.implicitWidth + (dot ? 0 : 12))
    implicitHeight: Math.max(dot ? 10 : 18, label.implicitHeight + (dot ? 0 : 6))
    padding: 0
    scale: 1
    Accessible.role: Accessible.StatusBar
    Accessible.name: displayText.length ? displayText
                   : (effectiveIconGlyph.length ? qsTr("Badge") : qsTr("Status"))
    Accessible.description: severityName

    background: Rectangle {
        radius: height / 2
        color: root.badgeColor
        border.width: 2
        border.color: Theme.bgLayer

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }

    contentItem: Item {
        Text {
            id: label
            anchors.centerIn: parent
            visible: !root.dot
            text: root.effectiveIconGlyph.length > 0 ? root.effectiveIconGlyph : root.displayText
            font.family: root.effectiveIconGlyph.length > 0 ? Theme.fontFamilyIcon : Theme.fontFamily
            font.pixelSize: 10
            font.weight: Theme.fontWeightSemiBold
            color: root.textColor
        }
    }

    onValueChanged: bump()
    onTextChanged: bump()
    onSymbolChanged: bump()

    function bump() {
        if (Theme.reducedMotion || !isOpen)
            return
        scale = 0.82
        scale = 1
    }

    Component.onCompleted: {
        if (!Theme.reducedMotion) {
            scale = 0.7
            scale = 1
        }
    }

    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }
    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
    }
}
