import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI-style segmented picker: exclusive selection among string / {text,icon} items.
T.Control {
    id: control

    property var model: []
    property int currentIndex: 0
    property alias selectedIndex: control.currentIndex
    property bool stretch: false
    property bool equalWidth: stretch
    signal selected(int index, var item)
    signal selectionChanged(int index)

    onCurrentIndexChanged: selectionChanged(currentIndex)

    implicitWidth: stretch ? 240 : (row.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Theme.controlHeight
    padding: 3
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }

    contentItem: RowLayout {
        id: row
        spacing: 2

        Repeater {
            model: control.model
            AbstractButton {
                id: seg
                required property var modelData
                required property int index
                enabled: typeof modelData === "string" ? true
                         : (modelData.enabled === undefined ? true : !!modelData.enabled)
                Layout.fillWidth: control.stretch
                Layout.fillHeight: true
                Layout.preferredWidth: control.stretch ? -1
                    : Math.max(64, contentItem.implicitWidth + 20)
                checkable: true
                checked: index === control.currentIndex
                hoverEnabled: true
                onClicked: {
                    control.currentIndex = index
                    control.selected(index, modelData)
                }

                contentItem: RowLayout {
                    spacing: 6
                    Text {
                        visible: typeof modelData !== "string" && !!(modelData.icon || modelData.glyph)
                        text: typeof modelData === "string" ? "" : (modelData.icon || modelData.glyph || "")
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 14
                        color: seg.checked ? Theme.textPrimary : Theme.textSecondary
                        Layout.leftMargin: 8
                    }
                    Text {
                        Layout.fillWidth: control.stretch
                        Layout.leftMargin: (typeof modelData !== "string" && (modelData.icon || modelData.glyph)) ? 0 : 10
                        Layout.rightMargin: 10
                        text: typeof modelData === "string" ? modelData : (modelData.text || modelData.title || "")
                        font.family: control.font.family
                        font.pixelSize: control.font.pixelSize
                        font.weight: seg.checked ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                        color: control.enabled
                             ? (seg.checked ? Theme.textPrimary : Theme.textSecondary)
                             : Theme.textDisabled
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }

                background: Rectangle {
                    radius: Theme.cornerControl - 1
                    color: {
                        if (seg.checked)
                            return Theme.bgCard
                        if (seg.hovered)
                            return Theme.fillSubtleSecondary
                        return "transparent"
                    }
                    border.width: seg.checked ? 1 : 0
                    border.color: Theme.strokeCard
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                }
            }
        }
    }
}
