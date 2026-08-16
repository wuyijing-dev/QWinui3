import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — EmptyState.

CatalogPage {
    title: qsTr("EmptyState")
    subtitle: qsTr("Empty collection messaging with symbol, AccentButton CTA, and enter motion.")

    ControlExample {
        headerText: qsTr("Default")
        qmlSource: "EmptyState {\n    symbol: FluentIcons.Search\n    actionText: \"Clear filters\"\n}"
        EmptyState {
            symbol: FluentIcons.Search
            glyphColor: Theme.accent
            title: qsTr("No results")
            message: qsTr("Try adjusting your search or filters to find what you need.")
            actionText: qsTr("Clear filters")
            secondaryActionText: qsTr("Learn more")
        }
    }
    ControlExample {
        headerText: qsTr("Compact / borderless")
        qmlSource: "EmptyState {\n    compact: true\n    bordered: false\n    symbol: FluentIcons.Mail\n}"
        EmptyState {
            compact: true
            bordered: false
            symbol: FluentIcons.Mail
            glyphColor: Theme.systemSuccess
            title: qsTr("Inbox zero")
            message: qsTr("You're all caught up.")
            actionText: qsTr("Compose")
        }
    }
}
