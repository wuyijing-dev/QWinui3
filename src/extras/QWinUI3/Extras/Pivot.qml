import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI Pivot: header tabs with sliding underline and stacked pages.
// model: [{ title, icon?, content }] or string titles with empty pages
T.Control {
    id: control

    property var model: []
    property int currentIndex: 0
    property alias selectedIndex: control.currentIndex
    signal currentIndexChangedByUser(int index)
    signal selectionChanged(int index)

    implicitWidth: 480
    implicitHeight: 280
    padding: 0
    spacing: 0

    onCurrentIndexChanged: selectionChanged(currentIndex)

    contentItem: ColumnLayout {
        spacing: 0

        Flickable {
            id: headerFlick
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            contentWidth: headerRow.implicitWidth
            contentHeight: height
            clip: true
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds

            Row {
                id: headerRow
                height: headerFlick.height
                spacing: 4

                Repeater {
                    model: control.model
                    AbstractButton {
                        id: tab
                        required property var modelData
                        required property int index
                        height: headerRow.height
                        width: Math.max(72, headerContent.implicitWidth + 24)
                        hoverEnabled: true
                        checkable: true
                        checked: index === control.currentIndex
                        onClicked: {
                            control.currentIndex = index
                            control.currentIndexChangedByUser(index)
                        }

                        readonly property string _icon: typeof modelData === "string"
                                                       ? "" : (modelData.icon || "")
                        readonly property string _title: typeof modelData === "string"
                                                        ? modelData : (modelData.title || "")

                        contentItem: Row {
                            id: headerContent
                            spacing: 8
                            anchors.centerIn: parent
                            Text {
                                visible: tab._icon.length > 0
                                anchors.verticalCenter: parent.verticalCenter
                                text: tab._icon
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 14
                                color: tab.checked ? Theme.accent : Theme.textSecondary
                                Behavior on color {
                                    enabled: !Theme.reducedMotion
                                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                                }
                            }
                            Text {
                                id: label
                                anchors.verticalCenter: parent.verticalCenter
                                text: tab._title
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontBody
                                font.weight: tab.checked ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                                color: tab.checked ? Theme.textPrimary : Theme.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                Behavior on color {
                                    enabled: !Theme.reducedMotion
                                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                                }
                            }
                        }

                        background: Item {
                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 2
                                radius: Theme.cornerControl
                                color: tab.hovered && !tab.checked ? Theme.fillSubtle : "transparent"
                            }
                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                width: tab.checked ? Math.min(parent.width - 16, headerContent.implicitWidth + 8) : 0
                                height: 3
                                radius: 1.5
                                color: Theme.accent
                                Behavior on width {
                                    enabled: !Theme.reducedMotion
                                    NumberAnimation {
                                        duration: Theme.duration(Theme.motionNormal)
                                        easing.type: Theme.easingStandard
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.strokeDivider
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: control.currentIndex

            Repeater {
                model: control.model
                Item {
                    required property var modelData
                    Label {
                        anchors.centerIn: parent
                        width: parent.width - 48
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.textSecondary
                        text: typeof modelData === "string"
                              ? modelData
                              : (modelData.content || modelData.title || "")
                    }
                }
            }
        }
    }

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
