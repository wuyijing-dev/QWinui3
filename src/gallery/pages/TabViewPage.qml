import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TabView.
//
// Fluent Add/Close icons, symbol tabs, selectedIndex, and TabWidthMode. API: docs/components/TabView.md

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
                title: qsTr("TabView")
                subtitle: qsTr("Fluent Add/Close icons, symbol tabs, selectedIndex, and TabWidthMode.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Add tab + equal width")
                qmlSource: "TabView {\n    model: [{ title, symbol: FluentIcons.Home }]\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label {
                        text: qsTr("Click + to add. Drag to reorder. × closes. Width mode: Equal.")
                        color: Theme.textSecondary
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    RowLayout {
                        spacing: Theme.spacing
                        CheckBox {
                            id: dragTabs
                            text: qsTr("CanDragTabs")
                            checked: true
                        }
                        CheckBox {
                            id: reorderTabs
                            text: qsTr("CanReorderTabs")
                            checked: true
                        }
                        Label {
                            text: {
                                var item = tabs.selectedItem
                                return qsTr("SelectedItem: %1").arg(item && item.title ? item.title : "—")
                            }
                            color: Theme.textSecondary
                        }
                    }
                    TabView {
                        id: tabs
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        canDragTabs: dragTabs.checked
                        tabsReorderable: reorderTabs.checked
                        isAddTabButtonVisible: true
                        tabWidthMode: "equal"
                        closeButtonOverlayMode: "onPointerOver"
                        model: [
                            { title: qsTr("Home"), symbol: FluentIcons.Home, content: qsTr("Home document content") },
                            { title: qsTr("Reports"), symbol: FluentIcons.Library, content: qsTr("Reports document content") },
                            { title: qsTr("Settings"), symbol: FluentIcons.Settings, content: qsTr("Settings document content") }
                        ]
                        tabStripHeader: ToolButton {
                            text: FluentIcons.GlobalNavButton
                            font.family: Theme.fontFamilyIcon
                            Accessible.name: qsTr("Menu")
                        }
                        tabStripFooter: Label {
                            text: qsTr("%1 tabs").arg(tabs.tabCount)
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                            leftPadding: 8
                            rightPadding: 8
                            verticalAlignment: Text.AlignVCenter
                        }
                        onAddTabButtonClicked: { /* addTab() already appended */ }
                    }
                    RowLayout {
                        spacing: 8
                        Button {
                            text: qsTr("Size to content")
                            onClicked: tabs.tabWidthMode = "sizeToContent"
                        }
                        Button {
                            text: qsTr("Equal")
                            onClicked: tabs.tabWidthMode = "equal"
                        }
                        Button {
                            text: qsTr("Compact")
                            onClicked: tabs.tabWidthMode = "compact"
                        }
                        Button {
                            text: qsTr("Close: always")
                            onClicked: tabs.closeButtonOverlayMode = "always"
                        }
                        Button {
                            text: qsTr("Close: on hover")
                            onClicked: tabs.closeButtonOverlayMode = "onPointerOver"
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
