import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// GridTile — Icon + title tile for launchers / galleries.
//
//   GridTile {
//       id: tile
//       title: qsTr("Photos")
//       subtitle: qsTr("12 items")
//       symbol: FluentIcons.Photo
//       onClicked: open()
//   }
//   // --- API ---
//   // inherits AbstractButton: text/enabled/clicked
//
// @notes
//   Icon + title tile for grids; onClicked.

T.AbstractButton {
    id: control

    // Primary title text
    property string title: text
    // Secondary subtitle text
    property string subtitle: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Fluent glyph drawn in the button
    property string glyph: ""
    // Image / media source
    property url source: ""
    // Tile width
    property real tileWidth: 160
    // Tile height
    property real tileHeight: 148
    // Selected state
    property alias isSelected: control.checked
    // Badge caption
    property string badgeText: ""
    // Show avatar badge
    property bool badgeVisible: badgeText.length > 0

    // Resolved glyph string
    readonly property string effectiveGlyph: {
        var g = IconSource.resolve(symbol, glyph)
        return g.length ? g : FluentIcons.Folder
    }

    checkable: true
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    implicitWidth: tileWidth
    implicitHeight: tileHeight
    padding: 12
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.CheckBox
    Accessible.name: title.length ? title : qsTr("Tile")
    Accessible.description: subtitle
    Accessible.checkable: true
    Accessible.checked: checked
    Accessible.onPressAction: if (enabled) clicked()

    scale: down && !Theme.reducedMotion ? 0.98 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

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
                    text: control.effectiveGlyph
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
                scale: control.checked && !Theme.reducedMotion ? 1 : 0.6
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingEnter
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: FluentIcons.Accept
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
        elevation: control.hovered || control.checked ? 4 : 2
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
        Behavior on elevation {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
