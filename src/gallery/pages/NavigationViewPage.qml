import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — NavigationView.
//
// Top-level navigation with PaneDisplayMode (Left / LeftCompact / Top) and an optional Back button. API: docs/components/NavigationView.md

CatalogPage {
    title: qsTr("NavigationView")
    subtitle: qsTr("Pane modes, Back button, and pageTransition animations (slide / fade / drill / …).")

    ControlExample {
        headerText: qsTr("Embedded sample")
        qmlSource: "NavigationView {\n    pageTransition: \"drill\"\n    openPage(\"HomePage\", \"fade\")\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Label { text: qsTr("Pane mode"); color: Theme.textSecondary }
                ComboBox {
                    id: paneMode
                    model: ["left", "leftCompact", "top"]
                    currentIndex: 0
                    Layout.preferredWidth: 160
                }
                CheckBox {
                    id: backVis
                    text: qsTr("Back button")
                    checked: true
                }
                CheckBox {
                    id: backEn
                    text: qsTr("Back enabled")
                    checked: true
                    enabled: backVis.checked
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
                }
            }
            Label {
                id: navStatus
                text: qsTr("Ready")
                color: Theme.textSecondary
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
                paneTitle: qsTr("Demo")
                openPaneLength: openLen.value
                compactPaneLength: 48
                footerText: qsTr("Settings")
                footerComponent: ""
                pageModule: "QWinUI3.Gallery"
                currentKey: "home"
                pageTransition: "slide"
                paneDisplayMode: paneMode.currentText
                isBackButtonVisible: backVis.checked
                isBackEnabled: backEn.checked
                isSettingsVisible: settingsVis.checked
                isPaneToggleButtonVisible: toggleVis.checked
                isPaneVisible: paneVis.checked
                alwaysShowHeader: alwaysHeader.checked
                onBackRequested: navStatus.text = qsTr("Back requested")
                onPageOpened: function (name) {
                    navStatus.text = qsTr("Opened %1 · %2").arg(name).arg(demoNav.pendingMode)
                }
                model: [
                    {
                        type: "item",
                        key: "home",
                        title: qsTr("Home"),
                        icon: FluentIcons.Home,
                        component: "HomePage"
                    },
                    {
                        type: "group",
                        key: "demo",
                        title: qsTr("Samples"),
                        icon: FluentIcons.Library,
                        children: [
                            {
                                title: qsTr("Button"),
                                icon: FluentIcons.OpenInNewWindow,
                                component: "ButtonPage"
                            },
                            {
                                title: qsTr("Slider"),
                                icon: FluentIcons.Slider,
                                component: "SliderPage"
                            }
                        ]
                    }
                ]
            }
        }
    }
}
