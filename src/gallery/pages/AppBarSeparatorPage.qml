import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AppBarSeparator.
//
// Thin divider with thickness and separatorColor. API: docs/components/AppBarSeparator.md

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
                title: qsTr("AppBarSeparator")
                subtitle: qsTr("Thin divider with thickness and separatorColor.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("In a CommandBar")
                qmlSource: "AppBarSeparator { thickness: 1 }"
                CommandBar {
                    AppBarButton {
                        iconGlyph: "\uE8C8"
                        text: qsTr("Copy")
                    }
                    AppBarButton {
                        iconGlyph: "\uE77F"
                        text: qsTr("Cut")
                    }
                    AppBarSeparator {}
                    AppBarButton {
                        iconGlyph: "\uE74D"
                        text: qsTr("Delete")
                    }
                    AppBarSeparator {
                        thickness: 2
                        separatorColor: Theme.accent
                    }
                    AppBarToggleButton {
                        iconGlyph: "\uE71B"
                        text: qsTr("Bold")
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
