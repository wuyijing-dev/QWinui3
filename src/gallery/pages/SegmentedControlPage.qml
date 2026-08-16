import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SegmentedControl.
//
// Sliding indicator, Fluent symbols, keyboard arrows, Accessible tabs. API: docs/components/SegmentedControl.md

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
                title: qsTr("SegmentedControl")
                subtitle: qsTr("Sliding indicator, Fluent symbols, keyboard arrows, Accessible tabs.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Basic")
                qmlSource: "SegmentedControl {\n    stretch: true\n    selectedIndex: 0\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    SegmentedControl {
                        id: daySeg
                        Layout.fillWidth: true
                        stretch: true
                        model: [qsTr("Day"), qsTr("Week"), qsTr("Month")]
                    }
                    Label {
                        text: {
                            var it = daySeg.selectedItem
                            return qsTr("SelectedItem: %1 (index %2)").arg(it || "—").arg(daySeg.selectedIndex)
                        }
                        color: Theme.textSecondary
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("With icons")
                qmlSource: "SegmentedControl {\n    model: [{ text, symbol: FluentIcons.List }]\n}"
                SegmentedControl {
                    model: [
                        { text: qsTr("List"), symbol: FluentIcons.List },
                        { text: qsTr("Grid"), symbol: FluentIcons.GridView },
                        { text: qsTr("Map"), symbol: FluentIcons.Map, enabled: false }
                    ]
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
