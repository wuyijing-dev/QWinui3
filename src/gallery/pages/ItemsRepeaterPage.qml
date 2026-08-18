import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ItemsRepeater + ConnectedAnimation.

CatalogPage {
    id: page
    title: qsTr("ItemsRepeater")
    subtitle: qsTr("Virtualizing ListView wrapper for large models; optional filterText (1.88); ConnectedAnimation morph demo.")

    property int selected: 0
    readonly property var sampleModel: {
        var out = []
        for (var i = 0; i < 200; ++i)
            out.push({ title: qsTr("Item %1").arg(i + 1), subtitle: qsTr("Row %1").arg(i + 1) })
        return out
    }

    ControlExample {
        headerText: qsTr("Virtual list")
        qmlSource: "ItemsRepeater {\n    model: bigModel\n    delegate: ListTile { … }\n}"

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 320
            spacing: Theme.spacingLoose

            Rectangle {
                Layout.preferredWidth: 280
                Layout.fillHeight: true
                radius: Theme.cornerCard
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard
                clip: true

                ItemsRepeater {
                    id: repeater
                    anchors.fill: parent
                    anchors.margins: 4
                    model: page.sampleModel
                    delegate: ListTile {
                        required property int index
                        required property var modelData
                        width: ListView.view.width
                        title: modelData.title
                        subtitle: modelData.subtitle
                        isSelected: page.selected === index
                        onClicked: {
                            page.selected = index
                            connectAnim.from = this
                            connectAnim.to = hero
                            connectAnim.play()
                        }
                    }
                }
            }

            Rectangle {
                id: hero
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: Theme.cornerCard
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text {
                        text: FluentIcons.Document
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 40
                        color: Theme.accent
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        text: page.sampleModel[page.selected]
                              ? page.sampleModel[page.selected].title
                              : qsTr("Select an item")
                        font.pixelSize: Theme.fontTitle
                        color: Theme.textPrimary
                    }
                    Label {
                        text: qsTr("ConnectedAnimation plays when you pick a row.")
                        color: Theme.textSecondary
                    }
                }
            }
        }
    }

    overlay: ConnectedAnimation {
        id: connectAnim
    }
}
