import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — StackPanel.
//
// Horizontal/vertical stack with spacing, alignment, RTL, and childCount. API: docs/components/StackPanel.md

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("StackPanel")
                subtitle: qsTr("Horizontal/vertical stack with spacing, alignment, RTL, and childCount.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Vertical")
                qmlSource: "StackPanel {\n    orientation: Qt.Vertical\n    Button { text: \"One\" }\n}"
                StackPanel {
                    Layout.fillWidth: true
                    orientation: Qt.Vertical
                    spacing: Theme.spacing
                    Button { text: qsTr("Primary action"); highlighted: true }
                    Button { text: qsTr("Secondary") }
                    Label { text: qsTr("Footer note"); color: Theme.textSecondary }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Horizontal + RTL")
                qmlSource: "StackPanel {\n    orientation: Qt.Horizontal\n    layoutDirection: Qt.RightToLeft\n}"
                StackPanel {
                    orientation: Qt.Horizontal
                    spacing: Theme.spacing
                    layoutDirection: Qt.RightToLeft
                    alignment: Qt.AlignVCenter
                    stretchChildren: false
                    Button { text: qsTr("Save"); highlighted: true }
                    Button { text: qsTr("Cancel"); flat: true }
                    Button { text: qsTr("More") }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
