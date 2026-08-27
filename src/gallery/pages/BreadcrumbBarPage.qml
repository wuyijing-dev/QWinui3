import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — BreadcrumbBar.
//
// Fluent separators, symbol crumbs, overflow ellipsis, NavigationView sync.
// API: docs/components/BreadcrumbBar.md · docs/navigation.md

CatalogPage {
    title: qsTr("BreadcrumbBar")
    subtitle: qsTr("Fluent separators, symbol crumbs, overflow ellipsis, NavigationView sync, a11y.")

    ControlExample {
        headerText: qsTr("Path")
        qmlSource: "BreadcrumbBar {\n    model: [{ title, symbol: FluentIcons.Home }]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox {
                id: lastClickable
                text: qsTr("Last item clickable")
            }
            BreadcrumbBar {
                id: crumbs
                Layout.fillWidth: true
                maxItems: 4
                lastItemClickable: lastClickable.checked
                model: [
                    { title: qsTr("Home"), symbol: FluentIcons.Home },
                    { title: qsTr("Library"), symbol: FluentIcons.Folder },
                    qsTr("Documents"),
                    qsTr("Projects"),
                    qsTr("2026"),
                    qsTr("Reports")
                ]
                onItemInvoked: function (index) {
                    crumbs.model = crumbs.model.slice(0, index + 1)
                }
            }
            Label {
                text: {
                    var it = crumbs.selectedItem
                    var title = (it && it.title) ? it.title : String(it || "—")
                    return qsTr("Index %1 · selectedItem: %2 — long paths collapse with …")
                        .arg(crumbs.currentIndex).arg(title)
                }
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }

    ControlExample {
        headerText: qsTr("NavigationView sync")
        qmlSource: "NavigationView {\n    breadcrumbModelForKey(currentKey)\n    onItemInvoked: selectBreadcrumbIndex(index)\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Wire BreadcrumbBar to NavigationView.breadcrumbModelForKey(currentKey). Clicks call selectBreadcrumbIndex — group crumbs jump to the first child. Set NavigationWindow.syncSubtitleFromNavigation for ShellWindow subtitle sync.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            NavigationView {
                id: navDemo
                Layout.fillWidth: true
                Layout.preferredHeight: 320
                headerText: qsTr("Contoso")
                hostContent: true
                paneDisplayMode: "leftCompact"
                currentKey: "home"
                footerText: qsTr("Settings")
                footerSymbol: FluentIcons.Settings
                footerComponent: ""
                model: [
                    {
                        type: "item",
                        key: "home",
                        title: qsTr("Home"),
                        symbol: FluentIcons.Home,
                        component: ""
                    },
                    {
                        type: "group",
                        key: "lib",
                        title: qsTr("Library"),
                        symbol: FluentIcons.Folder,
                        children: [
                            { title: qsTr("Documents"), symbol: FluentIcons.Document },
                            { title: qsTr("Pictures"), symbol: FluentIcons.Picture }
                        ]
                    }
                ]
                content: Item {
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing
                        spacing: Theme.spacing
                        BreadcrumbBar {
                            id: navCrumbs
                            Layout.fillWidth: true
                            maxItems: 5
                            model: navDemo.breadcrumbModelForKey(navDemo.currentKey)
                            currentIndex: Math.max(0, model.length - 1)
                            onItemInvoked: function (index) {
                                navDemo.selectBreadcrumbIndex(index)
                            }
                        }
                        Label {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            text: {
                                if (navDemo.footerSelected)
                                    return qsTr("Footer page · key __footer__")
                                return qsTr("Page: %1 · nav key %2")
                                    .arg(navDemo.titleForKey(navDemo.currentKey))
                                    .arg(navDemo.currentKey)
                            }
                            color: Theme.textPrimary
                        }
                        Label {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            text: qsTr("Keyboard: focus the bar — ←/→, Home/End, Enter/Space. Overflow … opens a flyout.")
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                        }
                    }
                }
            }
        }
    }
}
