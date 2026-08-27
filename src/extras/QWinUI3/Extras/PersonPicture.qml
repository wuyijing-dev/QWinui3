import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// PersonPicture — Avatar from image or initials (WinUI IsGroup / BadgeImageSource).
//
//   PersonPicture {
//       id: avatar
//       displayName: "Ada Lovelace"
//       // profilePicture: "file:///…"
//       isGroup: false
//   }
//
// @notes
//   Avatar from profilePicture/imageSource or displayName initials.
//   initials is settable (WinUI); empty uses computedInitials from displayName.
//   isGroup uses People glyph when empty; badgeImageSource paints an image badge.
//   isOutOfOffice (WinUI) shows a purple Clock presence badge when no other badge is set.

T.Control {
    id: root

    // Person / avatar display name
    property string displayName: ""
    // Image URL (WinUI ProfilePicture)
    property url imageSource: ""
    // WinUI ProfilePicture alias
    property alias profilePicture: root.imageSource
    // Diameter or box size in px
    property real size: 48
    // Fallback avatar fill
    property color profileColor: Theme.accent
    // WinUI IsGroup — group avatar empty glyph
    property bool isGroup: false
    // WinUI IsOutOfOffice — presence badge (Clock / purple) when no custom badge
    property bool isOutOfOffice: false
    // Show avatar badge
    property bool badgeVisible: false
    // Badge fill color
    property color badgeColor: Theme.systemSuccess
    // Badge FluentIcons symbol
    property var badgeSymbol: ""
    // Badge Fluent glyph string
    property string badgeGlyph: ""
    // WinUI BadgeImageSource — image in the badge (overrides glyph/text when set)
    property url badgeImageSource: ""
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
    // WinUI Initials — settable; empty falls back to displayName-derived letters
    property string initials: ""

    implicitWidth: size
    implicitHeight: size
    padding: 0
    opacity: enabled ? 1 : 0.5
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.Graphic
    Accessible.name: {
        var n = displayName.length ? displayName
                : (isGroup ? qsTr("Group") : qsTr("Person"))
        if (isOutOfOffice)
            n = qsTr("%1 (out of office)").arg(n)
        return n
    }

    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
    }

    // Initials derived from displayName when initials is empty
    readonly property string computedInitials: {
        if (root.isGroup)
            return ""
        var parts = String(displayName).trim().split(/\s+/).filter(function (p) { return p.length })
        if (!parts.length)
            return ""
        if (parts.length === 1)
            return parts[0].charAt(0).toUpperCase()
        return (parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase()
    }
    // Effective glyph letters for the avatar
    readonly property string effectiveInitials: {
        if (root.isGroup)
            return ""
        if (String(initials).trim().length)
            return String(initials).trim().toUpperCase().substring(0, 3)
        return computedInitials
    }

    readonly property string _emptyGlyph: root.isGroup ? FluentIcons.People : FluentIcons.Contact
    readonly property string _badgeIcon: IconSource.resolve(badgeSymbol, badgeGlyph)
    readonly property bool _hasBadgeImage: badgeImageSource.toString().length > 0

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

    readonly property bool _badgeHasLabel: _badgeLabel.length > 0 || _badgeIcon.length > 0 || _hasBadgeImage
    readonly property bool _showBadge: badgeVisible || isOutOfOffice
    readonly property bool _oofDefault: isOutOfOffice && !badgeVisible
    readonly property color _effectiveBadgeColor: _oofDefault ? "#8764B8" : _badgeColor
    readonly property string _effectiveBadgeGlyph: {
        if (_badgeHasLabel)
            return _badgeLabel.length > 0 ? _badgeLabel : _badgeIcon
        if (_oofDefault)
            return FluentIcons.Clock
        return ""
    }
    readonly property bool _effectiveBadgeHasContent: _badgeHasLabel || _oofDefault || _hasBadgeImage

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
                visible: root.imageSource.toString().length === 0 && root.effectiveInitials.length > 0
                text: root.effectiveInitials
                font.pixelSize: Math.max(10, root.size * 0.36)
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textOnAccent
            }

            Text {
                anchors.centerIn: parent
                visible: root.imageSource.toString().length === 0 && root.effectiveInitials.length === 0
                text: root._emptyGlyph
                font: Theme.iconFontFor(Math.max(12, root.size * 0.42))
                color: Theme.textOnAccent
                opacity: 0.92
            }
        }

        Rectangle {
            id: badge
            visible: root._showBadge
            width: {
                if (root._badgeLabel.length > 0)
                    return Math.max(Math.max(12, root.size * 0.32), badgeLabel.implicitWidth + 8)
                return Math.max(12, root.size * 0.32)
            }
            height: Math.max(12, root.size * 0.32)
            radius: height / 2
            color: root._effectiveBadgeColor
            border.width: 2
            border.color: Theme.bgLayer
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: root._badgeLabel.length > 1 ? -4 : -1
            anchors.bottomMargin: -1

            Text {
                id: badgeLabel
                anchors.centerIn: parent
                visible: root._effectiveBadgeHasContent && !root._hasBadgeImage
                text: root._effectiveBadgeGlyph
                font: {
                    if (root._badgeLabel.length > 0) {
                        var f = Theme.uiFontFor(Math.max(8, Math.round(parent.height * 0.55)))
                        f.weight = Theme.fontWeightSemiBold
                        return f
                    }
                    return Theme.iconFontFor(Math.max(8, Math.round(parent.height * 0.55)),
                                             Theme.fontWeightSemiBold)
                }
                color: Theme.textOnAccent
            }

            Image {
                anchors.fill: parent
                anchors.margins: 2
                visible: root._hasBadgeImage
                source: root.badgeImageSource
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                // 3.47 H16 — decode at badge size, not full source pixels.
                sourceSize.width: Math.ceil(badge.width)
                sourceSize.height: Math.ceil(badge.height)
                clip: true
            }
        }
    }

    contentItem: Item {}
}
