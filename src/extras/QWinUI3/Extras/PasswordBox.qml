import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: root

    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property alias maximumLength: field.maximumLength
    property string header: ""
    property string description: ""
    property string errorMessage: ""
    property bool clearButtonVisible: false
    // WinUI PasswordRevealMode: peek | hidden | visible
    property string passwordRevealMode: "peek"
    property bool revealPassword: false
    property bool revealButtonVisible: passwordRevealMode !== "hidden" && passwordRevealMode !== "visible"
    property alias echoMode: field.echoMode
    readonly property bool hasError: errorMessage.length > 0
    signal accepted()
    signal cleared()

    implicitWidth: Math.max(200, field.implicitWidth + leftPadding + rightPadding)
    implicitHeight: column.implicitHeight
    leftPadding: 0
    rightPadding: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    function clear() {
        field.clear()
        cleared()
    }

    onPasswordRevealModeChanged: {
        if (passwordRevealMode === "visible")
            revealPassword = true
        else if (passwordRevealMode === "hidden" || passwordRevealMode === "peek")
            revealPassword = false
    }

    contentItem: ColumnLayout {
        id: column
        spacing: 4

        Text {
            visible: root.header.length > 0
            Layout.fillWidth: true
            text: root.header
            font.family: root.font.family
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: root.enabled ? Theme.textPrimary : Theme.textDisabled
        }
        Text {
            visible: root.description.length > 0 && !root.hasError
            Layout.fillWidth: true
            text: root.description
            font.family: root.font.family
            font.pixelSize: Theme.fontCaption
            color: root.enabled ? Theme.textSecondary : Theme.textDisabled
            wrapMode: Text.Wrap
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.controlHeight

            TextField {
                id: field
                anchors.fill: parent
                echoMode: root.revealPassword ? TextInput.Normal : TextInput.Password
                passwordCharacter: "\u25CF"
                rightPadding: (root.revealButtonVisible ? 36 : 0)
                            + (clearBtn.visible ? 32 : 0)
                            + (root.revealButtonVisible || clearBtn.visible ? 0 : Theme.paddingControlH)
                onAccepted: root.accepted()
            }

            ToolButton {
                id: clearBtn
                visible: root.clearButtonVisible && field.text.length > 0
                anchors.right: revealBtn.visible ? revealBtn.left : parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 32
                text: "\uE711"
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 10
                opacity: visible ? 1 : 0
                onClicked: root.clear()
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                background: Rectangle {
                    radius: Theme.cornerControl
                    color: clearBtn.down ? Theme.fillSubtleTertiary
                         : (clearBtn.hovered ? Theme.fillSubtle : "transparent")
                }
            }

            ToolButton {
                id: revealBtn
                visible: root.revealButtonVisible
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 32
                text: root.revealPassword ? "\uED1A" : "\uE890"
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 14
                scale: down && !Theme.reducedMotion ? 0.92 : 1
                ToolTip.visible: hovered
                ToolTip.text: root.passwordRevealMode === "peek"
                              ? qsTr("Hold to show password")
                              : (root.revealPassword ? qsTr("Hide password") : qsTr("Show password"))
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }

                onPressed: {
                    if (root.passwordRevealMode === "peek")
                        root.revealPassword = true
                }
                onReleased: {
                    if (root.passwordRevealMode === "peek")
                        root.revealPassword = false
                }
                onCanceled: {
                    if (root.passwordRevealMode === "peek")
                        root.revealPassword = false
                }
                onClicked: {
                    if (root.passwordRevealMode !== "peek")
                        root.revealPassword = !root.revealPassword
                }

                background: Rectangle {
                    radius: Theme.cornerControl
                    color: revealBtn.down ? Theme.fillSubtleTertiary
                         : (revealBtn.hovered ? Theme.fillSubtle : "transparent")
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingStandard
                        }
                    }
                }
            }
        }

        Text {
            visible: root.hasError
            Layout.fillWidth: true
            text: root.errorMessage
            font.family: root.font.family
            font.pixelSize: Theme.fontCaption
            color: Theme.systemCritical
            wrapMode: Text.Wrap
        }
    }

    background: Item {}
}
