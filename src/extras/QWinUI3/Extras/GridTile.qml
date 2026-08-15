import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI GridView item: glyph or image, title, subtitle; optional checkable selection.
T.AbstractButton {
    id: control

    property string title: text
    property string subtitle: ""
    property string glyph: "\uE8B7"
    property url source: ""
    property real tileWidth: 160
    property real tileHeight: 148
    property alias isSelected: control.checked
    property string badgeText: ""
    property bool badgeVisible: badgeText.length > 0

    checkable: true
    hoverEnabled: true
    implicitWidth: tileWidth
    implicitHeight: tileHeight
    padding: 12
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 72

            Rectangle {
                anchors.fill: parent
                radius: Theme.cornerControl
                color: Theme.fillSubtle
                clip: true

                Image {
                    anchors.fill: parent
                    visible: control.source.toString().length > 0
                    source: control.source
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    sourceSize.width: 320
                    sourceSize.height: 144
                }

                Text {
                    anchors.centerIn: parent
                    visible: control.source.toString().length === 0
                    text: control.glyph
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 28
                    color: control.enabled ? Theme.accent : Theme.textDisabled
                }
            }

            Rectangle {
                visible: control.badgeVisible && !control.checked
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 6
                height: 18
                width: Math.max(18, tileBadge.implicitWidth + 10)
                radius: 9
                color: Theme.accent

                Text {
                    id: tileBadge
                    anchors.centerIn: parent
                    text: control.badgeText
                    font.family: Theme.fontFamily
                    font.pixelSize: 10
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textOnAccent
                }
            }

            Rectangle {
                visible: control.checked
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 6
                width: 22
                height: 22
                radius: 11
                color: Theme.accent

                Text {
                    anchors.centerIn: parent
                    text: "\uE73E"
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 12
                    color: Theme.textOnAccent
                }
            }
        }

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
            visible: control.subtitle.length > 0
            Layout.fillWidth: true
            text: control.subtitle
            font.family: control.font.family
            font.pixelSize: Theme.fontCaption
            color: control.enabled ? Theme.textSecondary : Theme.textDisabled
            elide: Text.ElideRight
        }
    }

    background: ElevatedChrome {
        color: {
            if (control.checked)
                return Theme.fillSubtle
            if (!control.enabled)
                return Theme.bgCard
            if (control.down)
                return Theme.fillSubtleTertiary
            if (control.hovered)
                return Theme.fillSubtleSecondary
            return Theme.bgCard
        }
        radius: Theme.cornerCard
        borderWidth: control.visualFocus ? 2 : 1
        borderColor: control.visualFocus ? Theme.focusOuter
                     : (control.checked ? Theme.accent : Theme.strokeCard)
        elevation: 2
        shadowOpacity: Theme.dark ? 0.18 : 0.08

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on borderColor {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
            }
        }
    }
}
