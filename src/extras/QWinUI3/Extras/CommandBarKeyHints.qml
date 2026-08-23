import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme

// CommandBarKeyHints — show keyboardAcceleratorText hints from AppBarButton children.
//
// @notes
//   CommandBar buttons already render their own hints visually when
//   `keyboardAcceleratorText` is set. This component is mainly for debugging
//   “which buttons have chords” during product integration.

Item {
    id: root

    property var commandBar: null
    property bool enabled: true
    visible: root.enabled && root.commandBar !== null

    implicitWidth: 360
    implicitHeight: 120

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        Text {
            Layout.fillWidth: true
            font.pixelSize: Theme.fontBodyLarge
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            text: qsTr("CommandBar key hints")
        }

        Repeater {
            model: root.commandBar && root.commandBar.primaryCommands
                     ? root.commandBar.primaryCommands.children.length
                     : 0

            delegate: Item {
                Layout.fillWidth: true
                height: 18

                readonly property var b: root.commandBar.primaryCommands.children[index]
                visible: b && b.keyboardAcceleratorText && String(b.keyboardAcceleratorText).length > 0

                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                    text: String(b.text || b.Accessible && b.Accessible.name || "•") + ": " + String(b.keyboardAcceleratorText)
                    elide: Text.ElideRight
                }
            }
        }
    }
}

