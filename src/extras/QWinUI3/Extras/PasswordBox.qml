import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// PasswordBox — Password field with reveal toggle.
//
//   PasswordBox { placeholderText: qsTr("Password") }

T.Control {
    id: root

    // Display / input text
    property alias text: field.text
    // Placeholder when empty
    property alias placeholderText: field.placeholderText
    property alias maximumLength: field.maximumLength
    // Header label above the control
    property string header: ""
    // Supporting description text
    property string description: ""
    property string errorMessage: ""
    // Show clear affordance
    property bool clearButtonVisible: false
    // WinUI PasswordRevealMode: peek | hidden | visible
    property string passwordRevealMode: "peek"
    property bool revealPassword: false
    property bool revealButtonVisible: passwordRevealMode !== "hidden" && passwordRevealMode !== "visible"
    property alias echoMode: field.echoMode
    property alias field: field
    readonly property bool hasError: errorMessage.length > 0
    signal accepted()
    signal cleared()

    implicitWidth: Math.max(200, field.implicitWidth + leftPadding + rightPadding)
    implicitHeight: column.implicitHeight
    leftPadding: 0
    rightPadding: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.EditableText
    Accessible.name: header.length ? header : qsTr("Password")
    Accessible.description: hasError ? errorMessage : description
    Accessible.passwordEdit: !revealPassword

    function clear() {
        field.clear()
        cleared()
    }

    function focusField() {
        field.forceActiveFocus()
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

            Rectangle {
                anchors.left: field.left
                anchors.right: field.right
                anchors.bottom: field.bottom
                height: 2
                radius: 1
                visible: root.hasError
                color: Theme.systemCritical
                opacity: 0.9
            }

            AbstractButton {
                id: clearBtn
                visible: root.clearButtonVisible && field.text.length > 0
                anchors.right: revealBtn.visible ? revealBtn.left : parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 32
                hoverEnabled: true
                Accessible.name: qsTr("Clear")
                opacity: visible ? 1 : 0
                onClicked: root.clear()
                scale: down && !Theme.reducedMotion ? 0.92 : 1
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                contentItem: Text {
                    text: FluentIcons.ChromeClose
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: clearBtn.hovered ? Theme.textPrimary : Theme.textSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: Theme.cornerControl
                    color: clearBtn.down ? Theme.fillSubtleTertiary
                         : (clearBtn.hovered ? Theme.fillSubtle : "transparent")
                }
            }

            AbstractButton {
                id: revealBtn
                visible: root.revealButtonVisible
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 32
                hoverEnabled: true
                Accessible.name: root.revealPassword ? qsTr("Hide password") : qsTr("Show password")
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

                contentItem: Text {
                    text: root.revealPassword ? FluentIcons.Hide : FluentIcons.View
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 14
                    color: revealBtn.hovered || root.revealPassword ? Theme.accent : Theme.textSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
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

        RowLayout {
            Layout.fillWidth: true
            spacing: 4
            visible: root.hasError
            Text {
                text: FluentIcons.Error
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 12
                color: Theme.systemCritical
            }
            Text {
                Layout.fillWidth: true
                text: root.errorMessage
                font.family: root.font.family
                font.pixelSize: Theme.fontCaption
                color: Theme.systemCritical
                wrapMode: Text.Wrap
            }
        }
    }

    background: Item {}
}
