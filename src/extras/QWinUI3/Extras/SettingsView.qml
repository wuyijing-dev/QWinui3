import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// SettingsView — Scrollable settings host (title + padded column).
//
//   SettingsView {
//       title: qsTr("Settings")
//       SettingsGroup {
//           title: qsTr("Appearance")
//           SettingsCard {
//               title: qsTr("Dark mode")
//               toggle: true
//               checked: Theme.dark
//               onToggled: Theme.dark = checked
//           }
//       }
//   }
//
// @notes
//   Owns ScrollView, page title, and horizontal padding. Put SettingsGroup /
//   SettingsCard / DetailRow as children — no Layout margins / fillWidth needed.

T.Control {
    id: root

    // Page title (hidden when empty)
    property string title: ""
    // Optional subtitle under the title
    property string subtitle: ""
    // Horizontal / vertical padding for the content column
    property real pagePadding: Theme.spacingSection
    // Vertical spacing between groups
    property real sectionSpacing: Theme.spacingSection
    // Default children (settings groups / cards)
    default property alias contentData: stack.data

    implicitWidth: 480
    implicitHeight: 640
    padding: 0
    Accessible.role: Accessible.Pane
    Accessible.name: title.length ? title : qsTr("Settings")

    contentItem: ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        background: null

        ColumnLayout {
            width: scroll.availableWidth
            spacing: root.sectionSpacing

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: root.pagePadding
                Layout.rightMargin: root.pagePadding
                Layout.topMargin: root.pagePadding
                spacing: 4
                visible: root.title.length > 0 || root.subtitle.length > 0

                Text {
                    visible: root.title.length > 0
                    Layout.fillWidth: true
                    text: root.title
                    font.pixelSize: Theme.fontTitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }
                Text {
                    visible: root.subtitle.length > 0
                    Layout.fillWidth: true
                    text: root.subtitle
                    font.pixelSize: Theme.fontBody
                    color: Theme.textSecondary
                    wrapMode: Text.WordWrap
                }
            }

            ColumnLayout {
                id: stack
                Layout.fillWidth: true
                Layout.leftMargin: root.pagePadding
                Layout.rightMargin: root.pagePadding
                Layout.bottomMargin: root.pagePadding
                spacing: root.sectionSpacing
            }
        }
    }
}
