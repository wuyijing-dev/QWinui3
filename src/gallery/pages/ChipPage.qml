import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("Chip")
                subtitle: qsTr("Compact selectable or closable tag. Supports chipSize small/medium.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Selectable")
                qmlSource: "Chip { text: \"Design\"; chipSize: \"medium\" }"
                ColumnLayout {
                    spacing: Theme.spacing
                    Label { text: qsTr("Medium"); color: Theme.textSecondary }
                    Flow {
                        Layout.fillWidth: true
                        spacing: Theme.spacing
                        Chip { text: qsTr("Design"); iconGlyph: "\uE790"; checked: true }
                        Chip { text: qsTr("Engineering"); iconGlyph: "\uE943" }
                        Chip { text: qsTr("Research"); iconGlyph: "\uE721" }
                        Chip { text: qsTr("Disabled"); enabled: false }
                    }
                    Label { text: qsTr("Small"); color: Theme.textSecondary }
                    Flow {
                        Layout.fillWidth: true
                        spacing: Theme.spacing
                        Chip { text: qsTr("A"); chipSize: "small"; checked: true }
                        Chip { text: qsTr("B"); chipSize: "small" }
                        Chip { text: qsTr("C"); chipSize: "small"; closable: true; checkable: false }
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Closable")
                qmlSource: "Chip { text: \"Tag\"; isCloseButtonVisible: true }"
                Flow {
                    id: chipFlow
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Repeater {
                        id: chipRepeater
                        model: [qsTr("Work"), qsTr("Personal"), qsTr("Urgent")]
                        Chip {
                            required property string modelData
                            required property int index
                            text: modelData
                            closable: true
                            checkable: false
                            onCloseClicked: {
                                var next = []
                                for (var i = 0; i < chipRepeater.model.length; ++i) {
                                    if (i !== index)
                                        next.push(chipRepeater.model[i])
                                }
                                chipRepeater.model = next
                            }
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
