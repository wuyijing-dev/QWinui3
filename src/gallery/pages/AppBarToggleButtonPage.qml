import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AppBarToggleButton.
//
// A checkable app-bar button that stays on until toggled off. API: docs/components/AppBarToggleButton.md

CatalogPage {
    title: qsTr("AppBarToggleButton")
    subtitle: qsTr("A checkable app-bar button that stays on until toggled off.")

    ControlExample {
        headerText: qsTr("Toggle commands")
        qmlSource: "AppBarToggleButton {\n    symbol: FluentIcons.Bold\n    text: \"Bold\"\n    checked: true\n}"
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
                    symbol: FluentIcons.Bold
                    text: qsTr("Bold")
                    checked: true
                }
                AppBarToggleButton {
                    symbol: FluentIcons.Italic
                    text: qsTr("Italic")
                }
                AppBarSeparator {}
                AppBarToggleButton {
                    symbol: FluentIcons.BulletedList2
                    text: qsTr("List")
                }
                AppBarToggleButton {
                    symbol: FluentIcons.GridViewSmall
                    text: qsTr("Grid")
                }
            }
            Label {
                text: qsTr("Follows CommandBar.defaultLabelPosition like AppBarButton.")
                color: Theme.textSecondary
            }
        }
    }
}
