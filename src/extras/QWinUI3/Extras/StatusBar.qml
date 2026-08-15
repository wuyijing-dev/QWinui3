import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// StatusBar — Window status strip with progress and slots.
//
//   StatusBar {
//       text: qsTr("Ready")
//       progress: 0.4
//   }

T.Control {
    id: root

    // Display / input text
    property string text: ""
    property alias leftContent: leftSlot.data
    property alias centerContent: centerSlot.data
    // Content slot / children host
    property alias content: trailing.data
    property alias rightContent: trailing.data
    // 0..1 shows determinate bar; <0 hides; NaN-safe. Set indeterminate for busy.
    property real progress: -1
    property bool progressIndeterminate: false

    readonly property bool _showProgress: progressIndeterminate || progress >= 0

    implicitHeight: Math.max(28, contentItem.implicitHeight + topPadding + bottomPadding
                             + (_showProgress ? 3 : 0))
    implicitWidth: Math.max(120, contentItem.implicitWidth + leftPadding + rightPadding)
    leftPadding: 10
    rightPadding: 10
    topPadding: 4
    bottomPadding: 4
    Accessible.role: Accessible.StatusBar
    Accessible.name: text.length ? text : qsTr("Status")

    background: Item {
        Rectangle {
            anchors.fill: parent
            color: Theme.bgAcrylic
        }
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: Theme.strokeDivider
        }
        ProgressBar {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 3
            visible: root._showProgress
            from: 0
            to: 1
            value: root.progressIndeterminate ? 0 : Math.max(0, Math.min(1, root.progress))
            indeterminate: root.progressIndeterminate
        }
    }

    contentItem: RowLayout {
        spacing: Theme.spacing

        Row {
            id: leftSlot
            spacing: Theme.spacing
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: children.length === 0 && root.text.length === 0
        }

        Text {
            visible: root.text.length > 0
            text: root.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            Layout.minimumWidth: 40
        }

        Item {
            visible: root.text.length === 0 && leftSlot.children.length === 0
            Layout.fillWidth: true
        }

        Row {
            id: centerSlot
            spacing: Theme.spacing
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        }

        Item {
            Layout.fillWidth: centerSlot.children.length > 0
            Layout.preferredWidth: 0
        }

        Row {
            id: trailing
            spacing: Theme.spacing
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
    }
}
