import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — NavigationView.
//
// Pane modes, footer, Back via TitleBar / top mode. Recipe: docs/navigation.md.

CatalogPage {
    title: qsTr("NavigationView")
    subtitle: qsTr("Back vs pane vs stack — docs/navigation-mental-model-256.md.")

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "// NavigationView — app destinations\n// TabView — documents\n// docs/navigation.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use NavigationView for app destinations (Home / Settings / groups) with pageModule + component. Prefer TabView for multiple open documents. Wire TitleBar Back to navigateBack(); pane toggle → togglePane() for overlay drawer on small windows (auto → leftMinimal below 640px). Product starter: examples/gallery-shell (NavigationWindow). Hand-wired rail: examples/nav-settings. Touch: pane rows follow navItemHeight — docs/touch-pointer.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Accessible.name defaults to paneTitle / headerText — keep it a clear app name. Footer uses footerText.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Embedded sample")
        qmlSource: "NavigationView {\n    paneDisplayMode: \"auto\"\n    pageTransition: \"drill\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Label { text: qsTr("Pane mode"); color: Theme.textSecondary }
                ComboBox {
                    id: paneMode
                    model: ["left", "leftCompact", "leftMinimal", "top", "auto"]
                    currentIndex: 0
                    Layout.preferredWidth: 160
                    Accessible.name: qsTr("Pane display mode")
                }
                Label { text: qsTr("Appearance"); color: Theme.textSecondary }
                ComboBox {
                    id: paneAppearanceBox
                    model: ["standard", "minimal", "branded"]
                    currentIndex: 0
                    Layout.preferredWidth: 140
                    Accessible.name: qsTr("Pane appearance")
                }
                CheckBox {
                    id: backVis
                    text: qsTr("Back (top mode)")
                    checked: true
                    enabled: paneMode.currentText === "top"
                }
                CheckBox {
                    id: backEn
                    text: qsTr("Back enabled")
                    checked: true
                    enabled: backVis.checked && paneMode.currentText === "top"
                }
                CheckBox {
                    id: settingsVis
                    text: qsTr("Settings item")
                    checked: true
                }
                CheckBox {
                    id: toggleVis
                    text: qsTr("Pane toggle")
                    checked: true
                }
                CheckBox {
                    id: paneVis
                    text: qsTr("IsPaneVisible")
                    checked: true
                }
                CheckBox {
                    id: alwaysHeader
                    text: qsTr("AlwaysShowHeader")
                    checked: false
                }
                CheckBox {
                    id: paneSearchEn
                    text: qsTr("Pane search")
                    checked: true
                }
                CheckBox {
                    id: footerBadgeEn
                    text: qsTr("Footer badge")
                    checked: true
                }
                CheckBox {
                    id: jumpListEn
                    text: qsTr("Jump list")
                    checked: true
                }
                CheckBox {
                    id: panePin
                    text: qsTr("Pane pinned")
                    checked: false
                }
                Label { text: qsTr("Open length"); color: Theme.textSecondary }
                SpinBox {
                    id: openLen
                    from: 200
                    to: 360
                    value: 280
                    editable: true
                    Layout.preferredWidth: 120
                    Accessible.name: qsTr("Open pane length")
                }
                Label { text: qsTr("Auto minimal"); color: Theme.textSecondary }
                SpinBox {
                    id: autoMin
                    from: 320
                    to: 960
                    value: 640
                    editable: true
                    enabled: paneMode.currentText === "auto"
                    Layout.preferredWidth: 120
                    Accessible.name: qsTr("Auto minimal threshold")
                }
            }
            Label {
                id: navStatus
                text: qsTr("Ready · Accessible.name uses paneTitle")
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("Page transition (default for pane clicks)")
                color: Theme.textSecondary
            }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Repeater {
                    model: demoNav.pageTransitionModes
                    delegate: Button {
                        required property string modelData
                        text: modelData
                        highlighted: demoNav.pageTransition === modelData
                        Accessible.name: qsTr("Page transition %1").arg(modelData)
                        onClicked: {
                            demoNav.pageTransition = modelData
                            demoNav.reloadPage()
                            navStatus.text = qsTr("pageTransition → %1 (pending %2)")
                                .arg(demoNav.pageTransition)
                                .arg(demoNav.pendingMode)
                        }
                    }
                }
            }
            NavigationView {
                id: demoNav
                Layout.fillWidth: true
                Layout.preferredHeight: 360
                paneTitle: qsTr("Demo navigation")
                openPaneLength: openLen.value
                compactPaneLength: 48
                footerText: qsTr("Settings")
                footerSymbol: FluentIcons.Settings
                footerComponent: ""
                pageModule: "QWinUI3.Gallery"
                currentKey: "home"
                pageTransition: "slide"
                paneDisplayMode: paneMode.currentText
                paneAppearance: paneAppearanceBox.currentText
                brandedTitle: paneAppearanceBox.currentText === "branded" ? qsTr("Contoso") : ""
                autoMinimalThreshold: autoMin.value
                isBackButtonVisible: backVis.checked && paneMode.currentText === "top"
                isBackEnabled: backEn.checked
                isSettingsVisible: settingsVis.checked
                isPaneToggleButtonVisible: toggleVis.checked
                isPaneVisible: paneVis.checked
                alwaysShowHeader: alwaysHeader.checked
                isPanePinned: panePin.checked
                isPaneSearchEnabled: paneSearchEn.checked
                jumpListEnabled: jumpListEn.checked
                pinnedNavSettingsCategory: "QWinUI3Gallery/NavDemoPins"
                paneSearchSettingsCategory: "QWinUI3Gallery/NavDemoPaneSearch"
                onPinnedNavKeysChanged: navStatus.text = qsTr("Pins → %1").arg((demoNav.pinnedNavKeys || []).join(", ") || qsTr("(none)"))
                footerBadgeValue: footerBadgeEn.checked ? 3 : -1
                onBackRequested: navStatus.text = qsTr("Back requested · canGoBack=%1").arg(demoNav.canGoBack)
                onFooterClicked: navStatus.text = qsTr("Footer (Settings) clicked")
                onPageOpened: function (name) {
                    navStatus.text = qsTr("Opened %1 · cache %2/%3 · hits %4 · keySkip %5 · pageSkip %6 · history %7")
                        .arg(name)
                        .arg(demoNav.pageCacheCount)
                        .arg(demoNav.pageCacheLimit)
                        .arg(demoNav.pageCacheHits)
                        .arg(demoNav.sameKeySkipCount)
                        .arg(demoNav.samePageSkipCount)
                        .arg(demoNav.pageHistory.length)
                }
                model: [
                    {
                        type: "item",
                        key: "home",
                        title: qsTr("Home"),
                        symbol: FluentIcons.Home,
                        component: "HomePage"
                    },
                    {
                        type: "group",
                        key: "demo",
                        title: qsTr("Samples"),
                        symbol: FluentIcons.Library,
                        children: [
                            {
                                title: qsTr("Button"),
                                symbol: FluentIcons.OpenInNewWindow,
                                component: "ButtonPage"
                            },
                            {
                                title: qsTr("Slider"),
                                symbol: FluentIcons.Slider,
                                component: "SliderPage"
                            }
                        ]
                    }
                ]
            }
        }
    }

    ControlExample {
        headerText: qsTr("Pinned pages, jump list, drilldown")
        qmlSource: "nav.pinNavKey(\"home\")\nnav.clearPinnedNavKeys()\nnav.clearPaneSearch()\nnav.announce(\"…\")"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Pin destinations into the pane chips (persisted when pinnedNavSettingsCategory is set). paneSearchSettingsCategory restores highlight text across sessions. clearPinnedNavKeys / clearPaneSearch / announce are additive (3.56). Jump list opens an A–Z / group index. pushDrilldown stacks pages on the current key; TitleBar Back pops the stack first, then history. Bind BreadcrumbBar to breadcrumbTrail.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            BreadcrumbBar {
                Layout.fillWidth: true
                model: demoNav.breadcrumbTrail
                currentIndex: Math.max(0, model.length - 1)
                onItemInvoked: function (index) { demoNav.selectBreadcrumbIndex(index) }
            }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Pin Home")
                    onClicked: {
                        demoNav.pinNavKey("home")
                        navStatus.text = qsTr("Pinned Home")
                    }
                }
                Button {
                    text: qsTr("Unpin Home")
                    onClicked: {
                        demoNav.unpinNavKey("home")
                        navStatus.text = qsTr("Unpinned Home")
                    }
                }
                Button {
                    text: qsTr("Clear pins")
                    onClicked: {
                        demoNav.clearPinnedNavKeys()
                        navStatus.text = qsTr("Pins cleared")
                    }
                }
                Button {
                    text: qsTr("Clear pane search")
                    onClicked: {
                        demoNav.clearPaneSearch()
                        navStatus.text = qsTr("Pane search cleared")
                    }
                }
                Button {
                    text: qsTr("Announce sample")
                    onClicked: {
                        demoNav.announce(qsTr("NavigationView live region sample"))
                        navStatus.text = qsTr("announce() called")
                    }
                }
                Button {
                    text: qsTr("Open jump list")
                    enabled: demoNav.jumpListEnabled
                    onClicked: demoNav.openJumpList()
                }
                Button {
                    text: qsTr("Drill → Button")
                    highlighted: true
                    onClicked: {
                        demoNav.pushDrilldown(qsTr("Button"), "ButtonPage")
                        navStatus.text = qsTr("Drilldown depth %1").arg(demoNav.drilldownDepth)
                    }
                }
                Button {
                    text: qsTr("Drill → Slider")
                    onClicked: {
                        demoNav.pushDrilldown(qsTr("Slider"), "SliderPage")
                        navStatus.text = qsTr("Drilldown depth %1").arg(demoNav.drilldownDepth)
                    }
                }
                Button {
                    text: qsTr("Pop drilldown")
                    enabled: demoNav.drilldownDepth > 0
                    onClicked: {
                        demoNav.popDrilldown()
                        navStatus.text = qsTr("Drilldown depth %1").arg(demoNav.drilldownDepth)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Incremental navModel patch")
        qmlSource: "demoNav.patchNavItem(\"home\", { badge: \"3\", title: \"Home (live)\" })"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("patchNavItem updates title, badge, badgeValue, symbol, or icon on one entry when nav structure is unchanged — avoids full ListModel rebuild on locale or live-data ticks.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Button {
                    text: qsTr("Badge Home → 3")
                    onClicked: {
                        demoNav.patchNavItem("home", { badge: "3", badgeValue: 3 })
                        navStatus.text = qsTr("patchNavItem home badge=3")
                    }
                }
                Button {
                    text: qsTr("Clear Home badge")
                    onClicked: {
                        demoNav.patchNavItem("home", { badge: "", badgeValue: -1 })
                        navStatus.text = qsTr("patchNavItem home badge cleared")
                    }
                }
                Button {
                    text: qsTr("Rename Home title")
                    onClicked: {
                        demoNav.patchNavItem("home", { title: qsTr("Home (patched)") })
                        navStatus.text = qsTr("patchNavItem home title")
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Navigation mental model")
        qmlSource: "nav.navigateToPage(\"DetailPage\", \"drill\")\nTitleBar: isBackButtonVisible: nav.canGoBack"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use navigateToPage/openDrillWithHistory for in-page drill — openPage alone skips soft history. Breadcrumb clicks no longer push history. Bind TitleBar Back to canGoBack (not static true). isPanePinned keeps overlay/auto pane open. docs/navigation-mental-model-256.md")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Button {
                    text: qsTr("Drill → Button (with history)")
                    highlighted: true
                    onClicked: demoNav.navigateToPage("ButtonPage", "drill")
                }
                Button {
                    text: qsTr("Drill → Button (no history)")
                    onClicked: demoNav.openDrill("ButtonPage")
                }
                Button {
                    text: qsTr("Navigate back")
                    enabled: demoNav.canGoBack
                    onClicked: demoNav.navigateBack()
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Collection + shell perf")
        qmlSource: "//: pageCacheHits · sameKeySkipCount\n//: debounce paneSearchTextEdited before rebuilding paneSearchModel"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Shell trim: tune pageCacheLimit, watch sameKeySkipCount / samePageSkipCount on repeat nav. Collection trim: NavigationView does not debounce pane search — use a Timer (~80–120 ms) in paneSearchTextEdited before filtering paneSearchModel. Pair both on real app checklists — docs/performance.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }
}
