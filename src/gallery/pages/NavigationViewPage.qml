import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — NavigationView.
//
// Pane modes, footer, Back via TitleBar / top mode. Recipe: docs/navigation.md (1.27).

CatalogPage {
    title: qsTr("NavigationView")
    subtitle: qsTr("Pane modes, footer Settings, Back stack. Recipe: docs/navigation.md (1.27).")

    ControlExample {
        headerText: qsTr("When to use (1.27)")
        qmlSource: "// NavigationView — app destinations\n// TabView — documents\n// docs/navigation.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use NavigationView for app destinations (Home / Settings / groups) with pageModule + component. Prefer TabView for multiple open documents. Wire TitleBar Back to navigateBack() — the left rail does not host Back. Starter: examples/nav-settings.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Accessible.name defaults to paneTitle / headerText — keep it a clear app name. Footer uses footerText.")
                font.family: Theme.fontFamily
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
                isBackButtonVisible: backVis.checked && paneMode.currentText === "top"
                isBackEnabled: backEn.checked
                isSettingsVisible: settingsVis.checked
                isPaneToggleButtonVisible: toggleVis.checked
                isPaneVisible: paneVis.checked
                alwaysShowHeader: alwaysHeader.checked
                onBackRequested: navStatus.text = qsTr("Back requested · canGoBack=%1").arg(demoNav.canGoBack)
                onFooterClicked: navStatus.text = qsTr("Footer (Settings) clicked")
                onPageOpened: function (name) {
                    navStatus.text = qsTr("Opened %1 · %2 · history %3")
                        .arg(name).arg(demoNav.pendingMode).arg(demoNav.pageHistory.length)
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
}
