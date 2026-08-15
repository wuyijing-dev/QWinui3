import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: control

    property string header: ""
    property string description: ""
    property var model: []
    property int currentIndex: 0
    property alias selectedIndex: control.currentIndex
    property bool horizontal: false
    signal selected(int index, var item)
    signal selectionChanged(int index)

    onCurrentIndexChanged: selectionChanged(currentIndex)

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    padding: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        Label {
            visible: control.header.length > 0
            text: control.header
            color: Theme.textPrimary
            font.weight: Theme.fontWeightSemiBold
            Layout.fillWidth: true
        }
        Label {
            visible: control.description.length > 0
            text: control.description
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        GridLayout {
            columns: control.horizontal ? Math.max(1, control.model.length) : 1
            rows: control.horizontal ? 1 : Math.max(1, control.model.length)
            rowSpacing: 2
            columnSpacing: Theme.spacingLoose
            Layout.fillWidth: true

            Repeater {
                model: control.model
                ColumnLayout {
                    required property var modelData
                    required property int index
                    spacing: 0
                    Layout.fillWidth: !control.horizontal

                    RadioButton {
                        id: radio
                        Layout.fillWidth: true
                        text: typeof modelData === "string" ? modelData
                              : (modelData.title || modelData.text || "")
                        checked: index === control.currentIndex
                        enabled: typeof modelData === "string" ? true
                                 : (modelData.enabled === undefined ? true : !!modelData.enabled)
                        padding: 8
                        leftPadding: 10
                        rightPadding: 12
                        onClicked: {
                            control.currentIndex = index
                            control.selected(index, modelData)
                        }

                        background: Rectangle {
                            radius: Theme.cornerControl
                            color: radio.hovered || radio.checked ? Theme.fillSubtleSecondary : "transparent"
                            Behavior on color {
                                enabled: !Theme.reducedMotion
                                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                        }
                    }
                    Text {
                        visible: typeof modelData === "object" && !!(modelData.description)
                        Layout.fillWidth: true
                        Layout.leftMargin: 34
                        Layout.rightMargin: 12
                        Layout.bottomMargin: 6
                        text: typeof modelData === "object" ? (modelData.description || "") : ""
                        font.family: control.font.family
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
    }
}
