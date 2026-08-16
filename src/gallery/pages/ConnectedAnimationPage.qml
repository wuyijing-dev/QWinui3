import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ConnectedAnimation (list → detail + key registry).

CatalogPage {
    title: qsTr("ConnectedAnimation")
    subtitle: qsTr("Shared-element morph for list→detail and NavigationView-style transitions.")

    property int selected: -1

    ControlExample {
        headerText: qsTr("List → detail")
        qmlSource: "ConnectedAnimationService.register(\"hero\", from)\nConnectedAnimationService.register(\"hero\", to)\nConnectedAnimationService.play(\"hero\")"

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 320
            spacing: Theme.spacingSection

            Rectangle {
                Layout.preferredWidth: 240
                Layout.fillHeight: true
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard
                radius: Theme.cornerCard
                clip: true

                ListView {
                    id: list
                    anchors.fill: parent
                    anchors.margins: 1
                    model: [
                        { title: qsTr("Aurora"), color: "#0078D4" },
                        { title: qsTr("Ember"), color: "#D13438" },
                        { title: qsTr("Moss"), color: "#107C10" },
                        { title: qsTr("Dusk"), color: "#8764B8" }
                    ]
                    delegate: ItemDelegate {
                        id: del
                        required property var modelData
                        required property int index
                        width: ListView.view.width
                        onClicked: {
                            selected = index
                            ConnectedAnimationService.register("gallery.hero", thumb)
                            ConnectedAnimationService.register("gallery.hero", hero)
                            ConnectedAnimationService.play("gallery.hero")
                        }
                        contentItem: RowLayout {
                            spacing: Theme.spacing
                            Rectangle {
                                id: thumb
                                width: 36
                                height: 36
                                radius: Theme.cornerControl
                                color: del.modelData.color
                            }
                            Label {
                                text: del.modelData.title
                                color: Theme.textPrimary
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.bgLayer
                border.width: 1
                border.color: Theme.strokeCard
                radius: Theme.cornerCard

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingSection
                    spacing: Theme.spacing

                    Rectangle {
                        id: hero
                        Layout.preferredWidth: 160
                        Layout.preferredHeight: 160
                        radius: Theme.cornerCard
                        color: selected >= 0 ? list.model[selected].color : Theme.fillSubtle
                    }

                    Label {
                        text: selected >= 0 ? list.model[selected].title : qsTr("Select an item")
                        font.pixelSize: Theme.fontSubtitle
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }

                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        color: Theme.textSecondary
                        text: qsTr("ListDetailsView also supports connectedAnimationEnabled for master→detail morphs.")
                    }

                    Switch {
                        id: listAnim
                        text: qsTr("ListDetailsView connected animation")
                        checked: true
                    }

                    ListDetailsView {
                        id: mailDetails
                        Layout.fillWidth: true
                        Layout.preferredHeight: 160
                        connectedAnimationEnabled: listAnim.checked
                        model: [
                            { title: qsTr("Inbox"), subtitle: qsTr("3 new"), body: qsTr("Shared-element handoff.") },
                            { title: qsTr("Archive"), subtitle: qsTr("Quiet"), body: qsTr("No unread.") }
                        ]
                        details: Label {
                            anchors.fill: parent
                            wrapMode: Text.Wrap
                            color: Theme.textPrimary
                            text: mailDetails.selectedItem
                                  ? mailDetails.selectedItem.body : ""
                        }
                    }
                }
            }
        }
    }
}
