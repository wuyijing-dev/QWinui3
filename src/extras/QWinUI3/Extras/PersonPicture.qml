import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// PersonPicture — Avatar from image or initials.
//
//   PersonPicture {
//       id: avatar
//       displayName: "Ada Lovelace"
//       // source: "file:///…"
//   }
//   // --- API ---
//   // avatar.initials / displayName / source
//
// @notes
//   Avatar from source image or displayName initials.

T.Control {
    id: root

    // Person / avatar display name
    property string displayName: ""
    // Image URL
    property url imageSource: ""
    // Diameter or box size in px
    property real size: 48
    // Fallback avatar fill
    property color profileColor: Theme.accent
    // Show avatar badge
    property bool badgeVisible: false
    // Badge fill color
    property color badgeColor: Theme.systemSuccess
    // Badge FluentIcons symbol
    property var badgeSymbol: ""
    // Badge Fluent glyph string
    property string badgeGlyph: ""
    // Badge severity
    property int badgeSeverity: -1 // -1 custom; else InfoBadge-like 0..3
    // WinUI-style count / text overlay (takes precedence over glyph when set)
    property int badgeValue: 0
    // Badge caption
    property string badgeText: ""
    // Badge max before +
    property int badgeMaxValue: 99
    // Selected state
    property bool selected: false

    implicitWidth: size
    implicitHeight: size
    padding: 0
    opacity: enabled ? 1 : 0.5
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.Graphic
    Accessible.name: displayName.length ? displayName : qsTr("Person")

    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
    }

    // Initials shown when no image
    readonly property string initials: {
        var parts = String(displayName).trim().split(/\s+/).filter(function (p) { return p.length })
        if (!parts.length)
            return ""
        if (parts.length === 1)
            return parts[0].charAt(0).toUpperCase()
        return (parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase()
    }

    readonly property string _emptyGlyph: FluentIcons.Contact
    readonly property string _badgeIcon: IconSource.resolve(badgeSymbol, badgeGlyph)

    readonly property color _badgeColor: {
        switch (badgeSeverity) {
        case 1: return Theme.systemSuccess
        case 2: return Theme.systemCaution
        case 3: return Theme.systemCritical
        case 0: return Theme.systemAttention
        default: return root.badgeColor
        }
    }

    readonly property string _badgeLabel: {
        if (badgeText.length > 0)
            return badgeText
        if (badgeValue <= 0)
            return ""
        return badgeValue > badgeMaxValue ? (badgeMaxValue + "+") : String(badgeValue)
    }

    readonly property bool _badgeHasLabel: _badgeLabel.length > 0 || _badgeIcon.length > 0

    background: Item {
        width: root.size
        height: root.size

        Rectangle {
            id: focusRing
            anchors.fill: parent
            anchors.margins: -3
            radius: width / 2
            color: "transparent"
            border.width: (root.activeFocus || root.selected) ? 2 : 0
            border.color: Theme.accent
            Behavior on border.width {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        Rectangle {
            id: avatar
            anchors.fill: parent
            radius: width / 2
            color: root.imageSource.toString().length ? "transparent" : root.profileColor
            border.width: 1
            border.color: Theme.strokeCard
            clip: true
            scale: root.activeFocus && !Theme.reducedMotion ? 1.04 : 1
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Image {
                anchors.fill: parent
                visible: root.imageSource.toString().length > 0
                source: root.imageSource
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                sourceSize.width: root.size
                sourceSize.height: root.size
            }

            Text {
                anchors.centerIn: parent
                visible: root.imageSource.toString().length === 0 && root.initials.length > 0
                text: root.initials
                font.family: Theme.fontFamily
                font.pixelSize: Math.max(10, root.size * 0.36)
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textOnAccent
            }

            Text {
                anchors.centerIn: parent
                visible: root.imageSource.toString().length === 0 && root.initials.length === 0
                text: root._emptyGlyph
                font.family: Theme.fontFamilyIcon
                font.pixelSize: Math.max(12, root.size * 0.42)
                color: Theme.textOnAccent
                opacity: 0.92
            }
        }

        Rectangle {
            id: badge
            visible: root.badgeVisible
            width: {
                if (root._badgeLabel.length > 0)
                    return Math.max(Math.max(12, root.size * 0.32), badgeLabel.implicitWidth + 8)
                return Math.max(12, root.size * 0.32)
            }
            height: Math.max(12, root.size * 0.32)
            radius: height / 2
            color: root._badgeColor
            border.width: 2
            border.color: Theme.bgLayer
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: root._badgeLabel.length > 1 ? -4 : -1
            anchors.bottomMargin: -1

            Text {
                id: badgeLabel
                anchors.centerIn: parent
                visible: root._badgeHasLabel
                text: root._badgeLabel.length > 0 ? root._badgeLabel : root._badgeIcon
                font.family: root._badgeLabel.length > 0 ? Theme.fontFamily : Theme.fontFamilyIcon
                font.pixelSize: Math.max(8, parent.height * 0.55)
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textOnAccent
            }
        }
    }

    contentItem: Item {}
}
