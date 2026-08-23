import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Skeleton — Form / table loading placeholder composed of Shimmer lines (2.70 B6).
//
//   Skeleton {
//       rows: 4
//       lineHeight: 14
//       active: button.loading
//   }
//
//   // --- API ---
//   // rows, lineHeight, spacing, active / isActive, showAvatar
//
// @notes
//   Handoff pattern: Button.loading → ProgressRing for determinate → Skeleton/Shimmer for lists.

T.Control {
    id: root

    property int rows: 3
    property real lineHeight: 14
    property real lineSpacing: Theme.spacing
    property bool showAvatar: false
    property real avatarSize: 40
    property bool active: true
    property alias isActive: root.active

    implicitWidth: 240
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    padding: 0
    Accessible.role: Accessible.StatusBar
    Accessible.name: qsTr("Loading")
    Accessible.description: qsTr("Content placeholder")

    contentItem: ColumnLayout {
        spacing: root.lineSpacing

        RowLayout {
            visible: root.showAvatar
            spacing: Theme.spacing
            Layout.fillWidth: true

            Shimmer {
                Layout.preferredWidth: root.avatarSize
                Layout.preferredHeight: root.avatarSize
                shape: Shimmer.Circle
                active: root.active
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Shimmer {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.lineHeight
                    active: root.active
                }
                Shimmer {
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width * 0.6
                    Layout.preferredHeight: root.lineHeight
                    active: root.active
                }
            }
        }

        Repeater {
            model: root.rows
            Shimmer {
                Layout.fillWidth: true
                Layout.preferredHeight: root.lineHeight
                Layout.preferredWidth: index % 2 === 0 ? undefined : parent.width * 0.72
                active: root.active
            }
        }
    }
}
