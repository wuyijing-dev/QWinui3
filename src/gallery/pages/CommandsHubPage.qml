import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Commands & menus (full inline demos). docs/commands.md

CatalogPage {
    id: page
    title: qsTr("Commands & menus")
    subtitle: qsTr("CommandPalette / CommandBar / MenuFlyout — docs/commands.md (1.15).")

    ControlExample {
        headerText: qsTr("When to use which")
        qmlSource: "CommandPalette · CommandBar · MenuFlyout · MenuBar\ndocs/commands.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("CommandPalette for Ctrl+K global actions. CommandBar / AppBarButton for page tool strips. MenuFlyout for context menus. MenuBar for classic menus with Action.shortcut. SearchBox / AutoSuggestBox for find-as-you-type. Keyboard-first patterns: docs/keyboard.md.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    GalleryHubSection {
        title: qsTr("CommandPalette")
        description: qsTr("Global command search with recents and keyboard navigation.")
        CommandPalettePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("CommandBar")
        description: qsTr("Page-level command strip with primary actions.")
        CommandBarPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("CommandBar flyout")
        description: qsTr("Overflow and secondary commands in a flyout.")
        CommandBarFlyoutPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("AppBarButton")
        description: qsTr("Icon command buttons for toolbars.")
        AppBarButtonPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("MenuFlyout")
        description: qsTr("Context and overflow menus with icons and shortcuts.")
        MenuFlyoutPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("MenuBar")
        description: qsTr("Classic menu bar with nested menus.")
        MenuBarPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("SearchBox")
        description: qsTr("Query field with clear and search icon.")
        SearchBoxPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("AutoSuggestBox")
        description: qsTr("Type-ahead suggestions while typing.")
        AutoSuggestBoxPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Keyboard-first")
        description: qsTr("Focus order, accelerators, and keyboard navigation recipes.")
        KeyboardFirstPage { hubEmbed: true; width: parent.width }
    }
}
