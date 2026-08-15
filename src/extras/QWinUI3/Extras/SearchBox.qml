import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: control

    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property bool clearButtonVisible: true
    property string queryIcon: "\uE721"
    signal accepted(string text)
    // WinUI QuerySubmitted
    signal querySubmitted(string query)
    signal cleared()

    implicitWidth: 280
    implicitHeight: Theme.searchBoxHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    function clear() {
        field.text = ""
        cleared()
    }

    contentItem: Item {
        TextField {
            id: field
            anchors.fill: parent
            leftPadding: 36
            rightPadding: clearBtn.visible ? 36 : Theme.paddingControlH
            placeholderText: control.placeholderText.length ? control.placeholderText : qsTr("Search")
            onAccepted: {
                control.accepted(text)
                control.querySubmitted(text)
            }
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: control.queryIcon
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: field.activeFocus ? Theme.accent : Theme.textSecondary
            z: 1
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        ToolButton {
            id: clearBtn
            visible: control.clearButtonVisible && field.text.length > 0
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 32
            height: 32
            opacity: visible ? 1 : 0
            scale: down && !Theme.reducedMotion ? 0.9 : 1
            text: "\uE711"
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
            onClicked: control.clear()
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                }
            }
            background: Rectangle {
                radius: Theme.cornerControl
                color: clearBtn.down ? Theme.fillSubtleTertiary
                     : (clearBtn.hovered ? Theme.fillSubtle : "transparent")
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
                    }
                }
            }
        }
    }

    background: Item {}
}
