import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// HeaderedComboBox — ComboBox with header, description, and FormLayout binding.
//
//   HeaderedComboBox {
//       header: qsTr("Plan")
//       model: [qsTr("Free"), qsTr("Pro")]
//       currentIndex: 0
//   }
//
//   // --- API ---
//   // signals: onActivated, onAccepted
//   // inherits Control; formBound fields accept FormLayout labelWidth push
//
// @notes
//   Label + ComboBox pair matching HeaderedTextBox (error icon + critical underline).
//   headerPlacement top|left; FormLayout may push labelWidth / fieldHeaderPlacement
//   when formBound is true. See docs/forms.md.

T.Control {
    id: root

    Layout.fillWidth: true

    property string header: ""
    property string description: ""
    property string errorMessage: ""
    property string headerPlacement: "top"
    property real labelWidth: 120
    property bool formBound: true

    property alias model: box.model
    property alias currentIndex: box.currentIndex
    property alias currentText: box.currentText
    property alias currentValue: box.currentValue
    property alias textRole: box.textRole
    property alias valueRole: box.valueRole
    property alias editable: box.editable
    property alias editText: box.editText
    property alias count: box.count
    property alias comboBox: box

    signal activated(int index)
    signal accepted()

    readonly property bool hasError: errorMessage.length > 0
    readonly property bool _headerLeft: headerPlacement === "left"

    implicitWidth: 280
    implicitHeight: contentRoot.implicitHeight
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Combo box")
    Accessible.description: {
        if (hasError)
            return errorMessage
        var parts = []
        if (description.length)
            parts.push(description)
        if (currentText.length)
            parts.push(currentText)
        return parts.join(". ")
    }

    function focusField() { box.forceActiveFocus() }

    contentItem: GridLayout {
        id: contentRoot
        columns: root._headerLeft ? 2 : 1
        columnSpacing: Theme.spacingLoose
        rowSpacing: 4

        ColumnLayout {
            Layout.row: 0
            Layout.column: 0
            Layout.fillWidth: !root._headerLeft
            Layout.preferredWidth: root._headerLeft ? root.labelWidth : -1
            Layout.maximumWidth: root._headerLeft ? root.labelWidth : -1
            Layout.alignment: root._headerLeft ? Qt.AlignVCenter : Qt.AlignLeading
            spacing: 4
            visible: root.header.length > 0 || (root.description.length > 0 && !root.hasError)

            Text {
                visible: root.header.length > 0
                Layout.fillWidth: true
                text: root.header
                font.family: root.font.family
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                elide: Text.ElideRight
            }
            Text {
                visible: root.description.length > 0 && !root.hasError
                Layout.fillWidth: true
                text: root.description
                font.family: root.font.family
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.Wrap
            }
        }

        ColumnLayout {
            Layout.row: root._headerLeft ? 0 : 1
            Layout.column: root._headerLeft ? 1 : 0
            Layout.fillWidth: true
            spacing: 4

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: box.implicitHeight

                ComboBox {
                    id: box
                    anchors.fill: parent
                    enabled: root.enabled
                    onActivated: function (index) { root.activated(index) }
                    onAccepted: root.accepted()
                }

                Rectangle {
                    anchors.left: box.left
                    anchors.right: box.right
                    anchors.bottom: box.bottom
                    height: 2
                    radius: 1
                    visible: root.hasError
                    color: Theme.systemCritical
                    opacity: 0.9
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
    }
}
