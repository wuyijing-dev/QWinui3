import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI TextBox pattern: header, optional description, and a single-line field.
T.Control {
    id: root

    property string header: ""
    property string description: ""
    property string errorMessage: ""
    property bool clearButtonVisible: false
    property int characterLimit: 0 // 0 = unlimited; shows counter when > 0
    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property alias echoMode: field.echoMode
    property alias readOnly: field.readOnly
    property alias isReadOnly: field.readOnly
    property alias maximumLength: field.maximumLength
    property alias validator: field.validator
    property alias inputMethodHints: field.inputMethodHints
    property alias acceptableInput: field.acceptableInput
    property alias field: field
    signal accepted()
    signal editingFinished()
    signal textEdited()
    signal cleared()

    readonly property bool hasError: errorMessage.length > 0
    readonly property int characterCount: field.text.length
    readonly property bool overLimit: characterLimit > 0 && characterCount > characterLimit

    implicitWidth: 280
    implicitHeight: column.implicitHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.name: header
    Accessible.description: hasError ? errorMessage : description

    function clear() {
        field.clear()
        cleared()
    }

    function focusField() {
        field.forceActiveFocus()
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
            elide: Text.ElideRight
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
            Layout.preferredHeight: field.implicitHeight

            TextField {
                id: field
                anchors.fill: parent
                rightPadding: clearBtn.visible ? 36 : Theme.paddingControlH
                enabled: root.enabled
                font.family: root.font.family
                font.pixelSize: root.font.pixelSize
                onAccepted: root.accepted()
                onEditingFinished: root.editingFinished()
                onTextEdited: root.textEdited()
            }

            // Soft critical underline when invalid
            Rectangle {
                anchors.left: field.left
                anchors.right: field.right
                anchors.bottom: field.bottom
                height: 2
                radius: 1
                visible: root.hasError || root.overLimit
                color: Theme.systemCritical
                opacity: 0.9
            }

            AbstractButton {
                id: clearBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 2
                visible: root.clearButtonVisible && field.text.length > 0 && !field.readOnly
                width: 28
                height: 28
                hoverEnabled: true
                Accessible.name: qsTr("Clear")
                onClicked: root.clear()
                scale: down && !Theme.reducedMotion ? 0.92 : 1
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
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            visible: root.hasError || root.characterLimit > 0

            RowLayout {
                spacing: 4
                Layout.fillWidth: true
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

            Item { Layout.fillWidth: true; visible: !root.hasError }

            Text {
                visible: root.characterLimit > 0
                text: qsTr("%1 / %2").arg(root.characterCount).arg(root.characterLimit)
                font.family: root.font.family
                font.pixelSize: Theme.fontCaption
                color: root.overLimit ? Theme.systemCritical : Theme.textSecondary
            }
        }
    }
}
