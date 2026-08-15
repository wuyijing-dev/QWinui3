import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AppBarToggleButton.
//
// A checkable app-bar button that stays on until toggled off. API: docs/components/AppBarToggleButton.md

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
                title: qsTr("AppBarToggleButton")
                subtitle: qsTr("A checkable app-bar button that stays on until toggled off.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Toggle commands")
                qmlSource: "AppBarToggleButton {\n    iconGlyph: \"\\uE71B\"\n    text: \"Bold\"\n    checked: true\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    RowLayout {
                        Label { text: qsTr("Labels"); color: Theme.textSecondary }
                        ComboBox {
                            id: labelPos
                            model: ["bottom", "right", "collapsed"]
                            currentIndex: 0
                            Layout.preferredWidth: 140
                        }
                    }
                    CommandBar {
                        defaultLabelPosition: labelPos.currentText
                        AppBarToggleButton {
                            iconGlyph: "\uE71B"
                            text: qsTr("Bold")
                            checked: true
                        }
                        AppBarToggleButton {
                            iconGlyph: "\uE714"
                            text: qsTr("Italic")
                        }
                        AppBarSeparator {}
                        AppBarToggleButton {
                            iconGlyph: "\uE8E9"
                            text: qsTr("List")
                        }
                        AppBarToggleButton {
                            iconGlyph: "\uE8EA"
                            text: qsTr("Grid")
                        }
                    }
                    Label {
                        text: qsTr("Follows CommandBar.defaultLabelPosition like AppBarButton.")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
