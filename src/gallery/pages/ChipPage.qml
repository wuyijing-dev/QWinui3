import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Chip.

CatalogPage {
    title: qsTr("Chip")
    subtitle: qsTr("Selectable or closable tag with Fluent ChromeClose and Accessible.")

    ControlExample {
        headerText: qsTr("Selectable")
        qmlSource: "Chip {\n    appearance: \"outline\"\n    avatarText: \"A\"\n}"
        ColumnLayout {
            spacing: Theme.spacing
            Label { text: qsTr("Filled"); color: Theme.textSecondary }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Chip { text: qsTr("Design"); symbol: FluentIcons.Color; checked: true }
                Chip { text: qsTr("Engineering"); symbol: FluentIcons.Code }
                Chip { text: qsTr("Alex"); avatarText: "A"; checked: true }
                Chip { text: qsTr("Disabled"); enabled: false }
            }
            Label { text: qsTr("Outline"); color: Theme.textSecondary }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Chip { text: qsTr("Outline"); appearance: "outline"; checked: true }
                Chip { text: qsTr("Tag"); appearance: "outline"; symbol: FluentIcons.Tag }
                Chip {
                    text: qsTr("Icon right")
                    appearance: "outline"
                    symbol: FluentIcons.Tag
                    iconPlacement: "right"
                }
                Chip { text: qsTr("B"); appearance: "outline"; avatarText: "B"; chipSize: "small" }
            }
        }
    }
    ControlExample {
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
}
