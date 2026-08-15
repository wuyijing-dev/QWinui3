import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// MetadataItem — One label/value pair for MetadataControl.
//
//   MetadataControl {
//       MetadataItem { label: qsTr("Author"); value: "Ada" }
//       MetadataItem { label: qsTr("Size"); value: "12 KB" }
//   }

T.Control {
    id: root

    // Field label
    property string label: ""
    // Current value
    property string value: ""
    // Secondary value line
    property string secondary: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Vertical
    // Value / series color
    property color valueColor: Theme.textPrimary

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)
    readonly property real _iconSlot: effectiveIconGlyph.length > 0 ? 14 + Theme.spacing : 0

    implicitWidth: orientation === Qt.Horizontal
            ? (_iconSlot + hLabel.implicitWidth + Theme.spacing + hValue.implicitWidth
               + (secondary.length ? Theme.spacing + hSec.implicitWidth : 0))
            : Math.max(120, _iconSlot + Math.max(vLabel.implicitWidth, vValue.implicitWidth))
    implicitHeight: orientation === Qt.Horizontal
            ? Math.max(Theme.fontBody + 4, 14)
            : Math.max(icon.visible ? 16 : 0,
                       vLabel.implicitHeight + 2 + vValue.implicitHeight
                       + (secondary.length ? 2 + vSec.implicitHeight : 0))

    height: implicitHeight
    padding: 0
    Accessible.name: label
    Accessible.description: value

    contentItem: Item {
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight

        FontIcon {
            id: icon
            visible: root.effectiveIconGlyph.length > 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: root.orientation === Qt.Vertical ? 2 : 1
            symbol: root.symbol
            glyph: root.iconGlyph
            fontSize: 14
            iconColor: Theme.textSecondary
        }

        Column {
            visible: root.orientation === Qt.Vertical
            anchors.left: parent.left
            anchors.leftMargin: root._iconSlot
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: 2

            Text {
                id: vLabel
                width: parent.width
                text: root.label
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                elide: Text.ElideRight
            }
            Text {
                id: vValue
                width: parent.width
                text: root.value
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: root.valueColor
                wrapMode: Text.Wrap
            }
            Text {
                id: vSec
                visible: root.secondary.length > 0
                width: parent.width
                text: root.secondary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.Wrap
            }
        }

        Row {
            visible: root.orientation === Qt.Horizontal
            anchors.left: parent.left
            anchors.leftMargin: root._iconSlot
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacing

            Text {
                id: hLabel
                text: root.label
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                id: hValue
                text: root.value
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: root.valueColor
            }
            Text {
                id: hSec
                visible: root.secondary.length > 0
                text: root.secondary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }
    }

    background: Item {}
}
