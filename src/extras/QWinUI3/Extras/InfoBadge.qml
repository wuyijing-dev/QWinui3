import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Compact badge for counts, status, or a Fluent glyph.
T.Control {
    id: root

    readonly property int informational: 0
    readonly property int success: 1
    readonly property int warning: 2
    readonly property int error: 3
    readonly property int attention: 4
    readonly property int neutral: 5

    property int severity: error
    property int value: 0
    property string text: ""
    property string iconGlyph: ""
    property int maxValue: 99
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
    property color textColor: {
        if (severity === warning)
            return Theme.dark ? "#000000" : "#000000"
        if (severity === neutral)
            return Theme.textOnAccent
        return Theme.textOnAccent
    }
    property bool dot: displayText.length === 0 && iconGlyph.length === 0
    // Hide when there is no count/text/icon (status dots remain visible)
    property bool hideWhenEmpty: false

    readonly property string displayText: {
        if (iconGlyph.length > 0)
            return ""
        if (text.length > 0)
            return text
        if (value <= 0)
            return ""
        return value > maxValue ? (maxValue + "+") : String(value)
    }

    readonly property bool isEmpty: value <= 0 && text.length === 0 && iconGlyph.length === 0
    readonly property bool isOpen: opacity > 0.01

    opacity: (hideWhenEmpty && isEmpty) ? 0 : 1
    visible: opacity > 0.01

    implicitWidth: Math.max(dot ? 10 : 18, label.implicitWidth + (dot ? 0 : 12))
    implicitHeight: Math.max(dot ? 10 : 18, label.implicitHeight + (dot ? 0 : 6))
    padding: 0
    scale: 1
    Accessible.role: Accessible.StatusBar
    Accessible.name: displayText.length ? displayText : (iconGlyph.length ? iconGlyph : qsTr("Badge"))

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
            text: root.iconGlyph.length > 0 ? root.iconGlyph : root.displayText
            font.family: root.iconGlyph.length > 0 ? Theme.fontFamilyIcon : Theme.fontFamily
            font.pixelSize: 10
            font.weight: Theme.fontWeightSemiBold
            color: root.textColor
        }
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
