import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — DropDownButton.

CatalogPage {
    title: qsTr("DropDownButton")
    subtitle: qsTr("Fluent ChevronDown, symbol icons, isOpen, and Accessible menu state.")

    ControlExample {
        headerText: qsTr("With MenuItem children")
        qmlSource: "DropDownButton {\n    symbol: FluentIcons.Settings\n    text: \"Options\"\n}"

        RowLayout {
            spacing: Theme.spacingLoose
            DropDownButton {
                text: qsTr("Options")
                symbol: FluentIcons.Settings
                MenuItem { text: qsTr("Copy") }
                MenuItem { text: qsTr("Paste") }
                MenuItem { text: qsTr("Delete") }
            }
            DropDownButton {
                text: qsTr("Accent")
                highlighted: true
                symbol: FluentIcons.OtherUser
                MenuItem { text: qsTr("New") }
                MenuItem { text: qsTr("Open") }
            }
        }
    }
}
