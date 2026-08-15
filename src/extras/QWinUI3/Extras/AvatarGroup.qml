import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// AvatarGroup — Overlapping PersonPicture stack with overflow count.
//
//   AvatarGroup {
//       id: avatars
//       model: [
//           { displayName: "Ada" },
//           { displayName: "Bob" },
//           { displayName: "Cara" }
//       ]
//       maxVisible: 2
//       onPersonClicked: (index) => { /* … */ }
//       onOverflowClicked: { /* … */ }
//   }
//   // --- API ---
//   // avatars.overflowCount

T.Control {
    id: root

    // Data model / item list for this control
    property var model: []
    // Diameter or box size in px
    property real size: 36
    // Avatar stack overlap in px
    property real overlap: 12
    // Max visible items before overflow
    property int maxVisible: 4
    // Show +N overflow chip
    property bool showOverflowCount: true
    // Qt layout direction
    property int layoutDirection: Qt.LeftToRight
    // Avatar clicked
    signal personClicked(int index, var item)
    // Overflow chip clicked
    signal overflowClicked()

    implicitWidth: row.implicitWidth
    implicitHeight: size
    padding: 0
    Accessible.role: Accessible.List
    Accessible.name: qsTr("%1 people").arg(model ? model.length : 0)

    // Hidden avatar count
    readonly property int overflowCount: Math.max(0, (model ? model.length : 0) - maxVisible)

    contentItem: Row {
        id: row
        spacing: -root.overlap
        layoutDirection: root.layoutDirection

        Repeater {
            model: {
                var src = root.model || []
                var n = Math.min(src.length, root.maxVisible)
                var out = []
                for (var i = 0; i < n; ++i)
                    out.push(src[i])
                return out
            }
            PersonPicture {
                id: pic
                required property var modelData
                required property int index
                size: root.size
                displayName: typeof modelData === "string" ? modelData
                             : (modelData.displayName || modelData.name || "")
                imageSource: typeof modelData === "string" ? "" : (modelData.imageSource || "")
                profileColor: {
                    if (typeof modelData !== "string" && modelData.profileColor)
                        return modelData.profileColor
                    var palette = ["#005FB8", "#0F7B0F", "#9D5D00", "#C42B1C", "#8764B8", "#038387"]
                    return palette[index % palette.length]
                }
                z: index
                scale: picHover.hovered ? 1.06 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                HoverHandler { id: picHover }
                TapHandler {
                    onTapped: root.personClicked(index, modelData)
                }
            }
        }

        Rectangle {
            visible: root.showOverflowCount && root.overflowCount > 0
            width: root.size
            height: root.size
            radius: width / 2
            color: Theme.fillSubtle
            border.width: 2
            border.color: Theme.bgLayer
            z: root.maxVisible + 1
            scale: ovHover.hovered ? 1.06 : 1
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
            HoverHandler { id: ovHover }
            TapHandler { onTapped: root.overflowClicked() }
            Text {
                anchors.centerIn: parent
                text: "+" + root.overflowCount
                font.family: Theme.fontFamily
                font.pixelSize: Math.max(10, root.size * 0.32)
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textSecondary
            }
        }
    }

    background: Item {}
}
