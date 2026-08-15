import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// HeaderedTextBox — TextBox with header and description.
//
//   HeaderedTextBox { header: qsTr("Name"); placeholderText: qsTr("Required") }

T.Control {
    id: root

    // Header label above the control
    property string header: ""
    // Supporting description text
    property string description: ""
    // Validation error text
    property string errorMessage: ""
    // Show clear affordance
    property bool clearButtonVisible: false
    // Soft character counter limit
    property int characterLimit: 0 // 0 = unlimited; shows counter when > 0
    // Display / input text
    property alias text: field.text
    // Placeholder when empty
    property alias placeholderText: field.placeholderText
    // TextField echo mode
    property alias echoMode: field.echoMode
    // Read-only when true
    property alias readOnly: field.readOnly
    // Alias of readOnly
    property alias isReadOnly: field.readOnly
    // Hard maximum text length
    property alias maximumLength: field.maximumLength
    // Optional input validator
    property alias validator: field.validator
    // Qt input method hints
    property alias inputMethodHints: field.inputMethodHints
    // True when typed input is valid
    property alias acceptableInput: field.acceptableInput
    // Inner text field
    property alias field: field
    // Emitted on accept / submit
    signal accepted()
    // Emitted when editing finishes
    signal editingFinished()
    // Emitted while text is being edited
    signal textEdited()
    // Emitted when content is cleared
    signal cleared()

    // True when validation failed
    readonly property bool hasError: errorMessage.length > 0
    // Character count of the text
    readonly property int characterCount: field.text.length
    // True when over the max limit
    readonly property bool overLimit: characterLimit > 0 && characterCount > characterLimit

    implicitWidth: 280
    implicitHeight: column.implicitHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.name: header
    Accessible.description: hasError ? errorMessage : description

    // Clear text or selection
    function clear() {
        field.clear()
        cleared()
    }

    // Move keyboard focus to the text field
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
