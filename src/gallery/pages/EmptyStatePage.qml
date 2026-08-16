import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — EmptyState.

CatalogPage {
    title: qsTr("EmptyState")
    subtitle: qsTr("Vs WinUI: neutral Document default (not Warning), borderless by default.")

    ControlExample {
        headerText: qsTr("Default (neutral)")
        qmlSource: "EmptyState {\n    // Document glyph, bordered: false\n    actionText: \"Clear filters\"\n}"
        EmptyState {
            title: qsTr("No results")
            message: qsTr("Try adjusting your search or filters to find what you need.")
            actionText: qsTr("Clear filters")
            secondaryActionText: qsTr("Learn more")
        }
    }
    ControlExample {
        headerText: qsTr("Custom symbol")
        qmlSource: "EmptyState {\n    symbol: FluentIcons.Search\n}"
        EmptyState {
            symbol: FluentIcons.Search
            glyphColor: Theme.accent
            title: qsTr("No matches")
            message: qsTr("We could not find anything for that query.")
            actionText: qsTr("Clear filters")
        }
    }
    ControlExample {
        headerText: qsTr("Compact + illustration slot")
        qmlSource: "EmptyState {\n    compact: true\n    illustration: Rectangle { … }\n}"
        EmptyState {
            compact: true
            title: qsTr("Inbox zero")
            message: qsTr("You're all caught up.")
            actionText: qsTr("Compose")
            illustration: Rectangle {
                width: 48
                height: 48
                radius: 24
                color: Theme.systemSuccessBg
                Text {
                    anchors.centerIn: parent
                    text: FluentIcons.Mail
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 22
                    color: Theme.systemSuccess
                }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Bordered (optional)")
        qmlSource: "EmptyState {\n    bordered: true\n}"
        EmptyState {
            bordered: true
            symbol: FluentIcons.FolderOpen
            title: qsTr("Folder empty")
            message: qsTr("Drop files here or create a new document.")
            actionText: qsTr("New document")
        }
    }
}
