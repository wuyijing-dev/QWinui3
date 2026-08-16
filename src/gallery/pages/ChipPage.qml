import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Chip.
//
// Selectable or closable tag with Fluent ChromeClose and Accessible. API: docs/components/Chip.md

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
                subtitle: qsTr("Selectable or closable tag with Fluent ChromeClose and Accessible.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
