import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SemanticZoom contacts recipe (2.62 / FL-006).

CatalogPage {
    id: page

    title: qsTr("SemanticZoom")
    subtitle: qsTr("Contacts grid ↔ letter index — experimental, docs/semantic-zoom-262.md (2.62).")

    property string statusText: qsTr("Pick a contact or zoom out to the letter index.")

    readonly property var contacts: [
        { name: qsTr("Alice Adams"), letter: "A", email: "alice@example.com" },
        { name: qsTr("Aaron Avery"), letter: "A", email: "aaron@example.com" },
        { name: qsTr("Bob Baker"), letter: "B", email: "bob@example.com" },
        { name: qsTr("Carol Chen"), letter: "C", email: "carol@example.com" },
        { name: qsTr("David Diaz"), letter: "D", email: "david@example.com" },
        { name: qsTr("Emma Evans"), letter: "E", email: "emma@example.com" },
        { name: qsTr("Frank Foster"), letter: "F", email: "frank@example.com" },
        { name: qsTr("Grace Gomez"), letter: "G", email: "grace@example.com" },
        { name: qsTr("Henry Hill"), letter: "H", email: "henry@example.com" },
        { name: qsTr("Ivy Irving"), letter: "I", email: "ivy@example.com" },
        { name: qsTr("Jack Jones"), letter: "J", email: "jack@example.com" },
        { name: qsTr("Kelly Kim"), letter: "K", email: "kelly@example.com" },
        { name: qsTr("Leo Lopez"), letter: "L", email: "leo@example.com" },
        { name: qsTr("Mia Moore"), letter: "M", email: "mia@example.com" },
        { name: qsTr("Noah Nguyen"), letter: "N", email: "noah@example.com" },
        { name: qsTr("Olivia Ortiz"), letter: "O", email: "olivia@example.com" },
        { name: qsTr("Paul Patel"), letter: "P", email: "paul@example.com" },
        { name: qsTr("Quinn Reed"), letter: "Q", email: "quinn@example.com" },
        { name: qsTr("Rita Ross"), letter: "R", email: "rita@example.com" },
        { name: qsTr("Sam Singh"), letter: "S", email: "sam@example.com" },
        { name: qsTr("Tara Thomas"), letter: "T", email: "tara@example.com" },
        { name: qsTr("Uma Upton"), letter: "U", email: "uma@example.com" },
        { name: qsTr("Victor Vega"), letter: "V", email: "victor@example.com" },
        { name: qsTr("Wendy Walsh"), letter: "W", email: "wendy@example.com" },
        { name: qsTr("Xavier Xu"), letter: "X", email: "xavier@example.com" },
        { name: qsTr("Yara Young"), letter: "Y", email: "yara@example.com" },
        { name: qsTr("Zoe Zhang"), letter: "Z", email: "zoe@example.com" }
    ]

    ControlExample {
        headerText: qsTr("Why SemanticZoom (2.62 / FL-006)")
        qmlSource: "SemanticZoom { model: contacts; groupRole: \"letter\" }"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Contacts and albums need a thumbnail grid and a letter index without duplicating selection state across two ItemsViews. SemanticZoom hosts zoomed-in / zoomed-out content with one model, selectedIndex, and selectGroup() — not generic map zoom.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Contacts recipe")
        qmlSource: "SemanticZoom {\n    model: contacts\n    groupRole: \"letter\"\n    GridView { /* zoomed in */ }\n    zoomedOut: GridView { /* A–Z */ }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            SemanticZoom {
                id: contactsZoom
                Layout.fillWidth: true
                Layout.preferredHeight: 320
                model: page.contacts
                groupRole: "letter"
                selectedIndex: 0
                accessibleName: qsTr("Contacts")
                onSelectionChanged: function (idx, item) {
                    if (item)
                        page.statusText = qsTr("Selected %1 (%2)").arg(item.name).arg(item.email)
                }
                onZoomChanged: function (out) {
                    page.statusText = out
                        ? qsTr("Index view — pick a letter")
                        : qsTr("Detail view — pick a contact")
                }

                GridView {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingSmall
                    model: contactsZoom.model
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    cellWidth: 112
                    cellHeight: 108
                    delegate: Item {
                        required property int index
                        required property var modelData
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight
                        GridTile {
                            anchors.centerIn: parent
                            tileWidth: 100
                            tileHeight: 96
                            title: modelData.name
                            subtitle: modelData.letter
                            symbol: FluentIcons.Contact
                            checked: contactsZoom.selectedIndex === index
                            onClicked: contactsZoom.selectIndex(index)
                        }
                    }
                }

                zoomedOut: GridView {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingSmall
                    model: contactsZoom.groupKeys
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    cellWidth: 52
                    cellHeight: 52
                    delegate: Item {
                        required property int index
                        required property string modelData
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight
                        RoundButton {
                            anchors.centerIn: parent
                            text: modelData
                            highlighted: contactsZoom.selectedGroup === modelData
                            onClicked: contactsZoom.selectGroup(modelData)
                        }
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: page.statusText
            }
        }
    }

}
