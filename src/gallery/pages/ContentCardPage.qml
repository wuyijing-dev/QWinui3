import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ContentCard.

CatalogPage {
    title: qsTr("ContentCard")
    subtitle: qsTr("Elevated card with symbol, footer, isClickable, focus, and keyboard activate.")

    ControlExample {
        headerText: qsTr("Card")
        qmlSource: "ContentCard {\n    footer: Button { … }\n    isClickable: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: cardMsg
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
            ContentCard {
                Layout.maximumWidth: 360
                title: qsTr("QWinUI3")
                subtitle: qsTr("Fluent-style Qt Quick Controls")
                symbol: FluentIcons.Document
                isClickable: true
                onClicked: cardMsg.text = qsTr("Card clicked")
                Label {
                    wrapMode: Text.Wrap
                    text: qsTr("Use ContentCard to group related content with a clear surface.")
                    color: Theme.textSecondary
                }
                footer: RowLayout {
                    spacing: Theme.spacing
                    Button { text: qsTr("Dismiss"); flat: true }
                    AccentButton { text: qsTr("Open") }
                }
            }
        }
    }
}
