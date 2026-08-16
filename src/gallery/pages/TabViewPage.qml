import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TabView.
//
// Documents frame vs NavigationView destinations. Recipe: docs/navigation.md (1.27).
// Tear-out stays experimental.

CatalogPage {
    title: qsTr("TabView")
    subtitle: qsTr("Add / close / reorder documents. Prefer NavigationView for app destinations — docs/navigation.md (1.27).")

    ControlExample {
        headerText: qsTr("When to use (1.27)")
        qmlSource: "// TabView — documents\n// NavigationView — destinations\n// docs/navigation.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use TabView for multiple open documents (add / close / reorder). Use NavigationView for app destinations and Settings footer. Tear-out (canTearOutTabs) remains experimental — keep off in production shells unless you own the tear-out window.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Give each tab a title for accessibility. Strip header buttons need Accessible.name (Menu demo below).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Add tab + equal width + tear-out")
        qmlSource: "TabView {\n    canTearOutTabs: true\n    model: [{ title, symbol }]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                text: qsTr("Click + to add. Drag horizontally to reorder. Drag vertically (~48px) to open a new window. × closes.")
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
                CheckBox {
                    id: tearOutTabs
                    text: qsTr("CanTearOutTabs")
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
                canTearOutTabs: tearOutTabs.checked
                createTearOutWindow: true
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
                Button {
                    text: qsTr("Tear out current")
                    enabled: tabs.tabCount > 0
                    onClicked: {
                        var w = tabs.Window.window
                        var gx = w ? w.x + w.width * 0.5 : 200
                        var gy = w ? w.y + 120 : 200
                        tabs.tearOutTab(tabs.currentIndex, gx, gy)
                    }
                }
            }
        }
    }
}
