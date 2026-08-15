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

    implicitWidth: 280
    implicitHeight: column.implicitHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    function clear() {
        field.clear()
        cleared()
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

            ToolButton {
                id: clearBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 2
                visible: root.clearButtonVisible && field.text.length > 0 && !field.readOnly
                width: 28
                height: 28
                text: "\uE711"
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 10
                flat: true
                onClicked: root.clear()
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
}
