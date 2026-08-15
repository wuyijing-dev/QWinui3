import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ActionCard — Clickable card with symbol, title, description, and chevron.
//
//   ActionCard {
//       title: qsTr("Accounts")
//       description: qsTr("Manage profiles")
//       onClicked: open()
//   }

T.AbstractButton {
    id: control

    // Primary title text
    property string title: text
    // Supporting description text
    property string description: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    property string glyph: ""
    property color glyphColor: Theme.accent
    property color glyphBackground: Theme.fillSubtle
    property bool showChevron: true
    // Show avatar badge
    property bool badgeVisible: false
    property int badgeValue: 0
    property string badgeText: ""
    property int badgeSeverity: 0

    readonly property string effectiveGlyph: {
        var g = IconSource.resolve(symbol, glyph)
        return g.length ? g : FluentIcons.Document
    }

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    implicitWidth: 280
    implicitHeight: Math.max(88, contentItem.implicitHeight + topPadding + bottomPadding)
    padding: 16
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.name: title
    Accessible.description: description

    contentItem: RowLayout {
        spacing: Theme.spacingLoose

        Item {
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.fill: parent
                radius: Theme.cornerControl
                color: control.glyphBackground
                scale: control.hovered && !Theme.reducedMotion ? 1.04 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: control.effectiveGlyph
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 22
                    color: control.enabled ? control.glyphColor : Theme.textDisabled
                }
            }

            InfoBadge {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: -4
                visible: control.badgeVisible
                value: control.badgeValue
                text: control.badgeText
                severity: control.badgeSeverity
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 4

            Text {
                Layout.fillWidth: true
                text: control.title
                font.family: control.font.family
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: control.enabled ? Theme.textPrimary : Theme.textDisabled
                elide: Text.ElideRight
            }
            Text {
                visible: control.description.length > 0
                Layout.fillWidth: true
                text: control.description
                font.family: control.font.family
                font.pixelSize: Theme.fontCaption
                color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                wrapMode: Text.Wrap
            }
        }

        Text {
            visible: control.showChevron
            Layout.alignment: Qt.AlignVCenter
            text: FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 12
            color: Theme.textSecondary
            opacity: control.enabled ? (control.hovered ? 1 : 0.85) : 0.4
            x: control.hovered && !Theme.reducedMotion ? 2 : 0
            Behavior on x {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }
    }

    background: ElevatedChrome {
        color: {
            if (!control.enabled)
                return Theme.bgCard
            if (control.down)
                return Theme.fillSubtle
            if (control.hovered)
                return Theme.bgCardElevated
            return Theme.bgCard
        }
        radius: Theme.cornerCard
        borderWidth: control.visualFocus ? 2 : 1
        borderColor: control.visualFocus ? Theme.focusOuter : Theme.strokeCard
        elevation: control.hovered ? 5 : 2
        shadowOpacity: control.hovered ? (Theme.dark ? 0.26 : 0.12) : (Theme.dark ? 0.16 : 0.07)
        scale: control.down && !Theme.reducedMotion ? 0.985 : 1

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
        Behavior on elevation {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
