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
                symbol: FluentIcons.Copy
                text: qsTr("Copy")
            }
            AppBarButton {
                symbol: FluentIcons.Cut
                text: qsTr("Cut")
            }
            AppBarSeparator {}
            AppBarButton {
                symbol: FluentIcons.Delete
                text: qsTr("Delete")
            }
            AppBarSeparator {
                thickness: 2
                separatorColor: Theme.accent
            }
            AppBarToggleButton {
                symbol: FluentIcons.Bold
                text: qsTr("Bold")
            }
        }
    }
}
