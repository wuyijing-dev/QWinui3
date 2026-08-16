import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AppBarSeparator.

CatalogPage {
    title: qsTr("AppBarSeparator")
    subtitle: qsTr("Thin divider with thickness and separatorColor.")

    ControlExample {
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
}
