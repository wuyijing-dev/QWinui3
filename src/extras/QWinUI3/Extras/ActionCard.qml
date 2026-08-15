import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

// WinUI-style actionable surface card with glyph, title, description, and chevron.
T.AbstractButton {
    id: control

    property string title: text
    property string description: ""
    property string glyph: "\uE8A5"
    property color glyphColor: Theme.accent
    property color glyphBackground: Theme.fillSubtle
    property bool showChevron: true
    property bool badgeVisible: false
    property int badgeValue: 0
    property string badgeText: ""
    property int badgeSeverity: 0

    hoverEnabled: true
    implicitWidth: 280
    implicitHeight: Math.max(88, contentItem.implicitHeight + topPadding + bottomPadding)
    padding: 16
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.name: title

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

                Text {
                    anchors.centerIn: parent
                    text: control.glyph
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
            text: "\uE76C"
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 12
            color: Theme.textSecondary
            opacity: control.enabled ? 0.85 : 0.4
        }
    }

    background: Rectangle {
        radius: Theme.cornerCard
        color: {
            if (!control.enabled)
                return Theme.bgCard
            if (control.down)
                return Theme.fillSubtle
            if (control.hovered)
                return Theme.bgCardElevated
            return Theme.bgCard
        }
        border.width: control.visualFocus ? 2 : 1
        border.color: control.visualFocus ? Theme.focusOuter : Theme.strokeCard
        scale: control.down && !Theme.reducedMotion ? 0.985 : 1

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: control.hovered ? (Theme.dark ? 0.26 : 0.12) : (Theme.dark ? 0.16 : 0.07)
            shadowColor: "#000000"
            shadowVerticalOffset: control.hovered ? 5 : 2
            blurMax: 16
            autoPaddingEnabled: true
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
