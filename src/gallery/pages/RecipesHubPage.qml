import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Recipes hub (docs/recipes.md). Navigate to related demos via openControl.

CatalogPage {
    id: page
    title: qsTr("Recipes hub")
    subtitle: qsTr("All LoB how-tos — MkDocs hub v2 (2.46) maps here.")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    function row(label, doc, pageId) {
        return { label: label, doc: doc, page: pageId }
    }

    ControlExample {
        headerText: qsTr("Planning & product expansion")
        qmlSource: "docs/planning/index.md · docs/planning/expansion/"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("Planning hub"), doc: "docs/planning/index.md", page: "RecipesHubPage" },
                    { label: qsTr("Component capabilities (2.51→3.00)"), doc: "docs/planning/expansion/component-capabilities-expansion.md", page: "PitfallsPage" },
                    { label: qsTr("Charts & dashboard arc"), doc: "docs/planning/expansion/charts-dashboard-arc.md", page: "DashboardPage" },
                    { label: qsTr("Roadmap strategy"), doc: "docs/planning/roadmap-strategy.md", page: "PitfallsPage" },
                    { label: qsTr("Friction log"), doc: "docs/planning/friction-log.md", page: "PitfallsPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: Theme.textPrimary
                            font.pixelSize: Theme.fontSizeBody
                        }
                        Label {
                            Layout.fillWidth: true
                            text: modelData.doc
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontSizeCaption
                            elide: Text.ElideRight
                        }
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("2.xx developer & stability")
        qmlSource: "docs/docs-ia-v2.md · docs/developer-diagnostics.md · docs/experimental-sweep.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("App sluggishness (2.59)"), doc: "docs/app-sluggishness-259.md", page: "PerformancePage" },
                    { label: qsTr("OSK in apps (2.58)"), doc: "docs/osk-in-apps-258.md", page: "OnScreenKeyboardPage" },
                    { label: qsTr("Files on Linux (2.57)"), doc: "docs/files-linux-257.md", page: "SystemIntegrationPage" },
                    { label: qsTr("Navigation mental model (2.56)"), doc: "docs/navigation-mental-model-256.md", page: "NavigationViewPage" },
                    { label: qsTr("Forms unlike WinUI (2.55)"), doc: "docs/forms-unlike-winui-255.md", page: "FormValidationPage" },
                    { label: qsTr("Window chrome footguns (2.54)"), doc: "docs/window-chrome-footguns-254.md", page: "WindowParadigmPage" },
                    { label: qsTr("Linux top-3 parity (2.53)"), doc: "docs/linux-top3-253.md", page: "SystemIntegrationPage" },
                    { label: qsTr("First app in an hour (2.52)"), doc: "docs/first-app-252.md", page: "ExamplesTemplatesPage" },
                    { label: qsTr("Stable vs experimental clarity (2.51)"), doc: "docs/stable-clarity-251.md", page: "PitfallsPage" },
                    { label: qsTr("Field harden buffer (2.47)"), doc: "docs/field-harden-247.md", page: "PitfallsPage" },
                    { label: qsTr("Docs IA v2 (2.46)"), doc: "docs/docs-ia-v2.md", page: "RecipesHubPage" },
                    { label: qsTr("Perf sign-off (2.49)"), doc: "docs/perf-signoff-2xx.md", page: "PerformancePage" },
                    { label: qsTr("Developer diagnostics (2.44)"), doc: "docs/developer-diagnostics.md", page: "PerformancePage" },
                    { label: qsTr("Stable vs experimental (2.45)"), doc: "docs/experimental-sweep.md", page: "PitfallsPage" },
                    { label: qsTr("Tranche-1 checkpoint (2.50)"), doc: "docs/checkpoint-250.md", page: "PitfallsPage" },
                    { label: qsTr("Dashboard compose (2.48)"), doc: "docs/dashboard-compose-decision.md", page: "DashboardPage" },
                    { label: qsTr("Icons & dashboard (2.43)"), doc: "docs/planning/expansion/icons-dashboard-expansion.md", page: "DashboardPage" },
                    { label: qsTr("Calendar view (2.31)"), doc: "docs/calendar-view.md", page: "CalendarViewPage" },
                    { label: qsTr("Items wrap grid (2.24)"), doc: "docs/items-wrap-grid.md", page: "ItemsWrapGridPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: Theme.textPrimary
                            font.weight: Theme.fontWeightSemiBold
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            Layout.fillWidth: true
                            text: modelData.doc
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Getting started")
        qmlSource: "docs/recipes.md · docs/qt-creator.md · docs/packaging-consumer.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("Qt Creator"), doc: "docs/qt-creator.md", page: "QtCreatorPage" },
                    { label: qsTr("Consumer packaging"), doc: "docs/packaging-consumer.md", page: "PackagingConsumerPage" },
                    { label: qsTr("1.xx maturity / freeze"), doc: "docs/maturity-1xx.md", page: "PitfallsPage" },
                    { label: qsTr("Mid-horizon checkpoint (1.60)"), doc: "docs/checkpoint-160.md", page: "PitfallsPage" },
                    { label: qsTr("Long-horizon checkpoint (1.78)"), doc: "docs/checkpoint-178.md", page: "PitfallsPage" },
                    { label: qsTr("Linux / Wayland (1.79)"), doc: "docs/platform-linux-wayland.md", page: "SystemIntegrationPage" },
                    { label: qsTr("1.xx compatibility / upgrade"), doc: "docs/compatibility-1xx.md", page: "PitfallsPage" },
                    { label: qsTr("CI smoke / Qt compat"), doc: "docs/ci-smoke.md", page: "CiSmokePage" },
                    { label: qsTr("Example templates"), doc: "examples/README.md", page: "ExamplesTemplatesPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: Theme.textPrimary
                            font.weight: Theme.fontWeightSemiBold
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            Layout.fillWidth: true
                            text: modelData.doc
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Shells & platform")
        qmlSource: "docs/window-shells.md · docs/shell-extras.md · docs/graphics-backend.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("Title-bar slots & hit-test (2.05)"), doc: "docs/title-bar-cookbook.md", page: "TitleBarPage" },
                    { label: qsTr("Window shells / chrome"), doc: "docs/window-shells.md", page: "WindowParadigmPage" },
                    { label: qsTr("High-DPI & monitors"), doc: "docs/high-dpi.md", page: "HighDpiPage" },
                    { label: qsTr("Multi-window"), doc: "docs/window-shells.md", page: "MultiWindowPage" },
                    { label: qsTr("Linux / Wayland + system integration (1.79)"), doc: "docs/platform-linux-wayland.md", page: "SystemIntegrationPage" },
                    { label: qsTr("Graphics backend (RHI)"), doc: "docs/graphics-backend.md", page: "GraphicsBackendPage" },
                    { label: qsTr("Shell extras / Snap / taskbar"), doc: "docs/shell-extras.md", page: "SystemIntegrationPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: Theme.textPrimary
                            font.weight: Theme.fontWeightSemiBold
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            Layout.fillWidth: true
                            text: modelData.doc
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Data & layout")
        qmlSource: "docs/forms.md · docs/density.md · docs/adaptive-layout.md · docs/i18n-rtl.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("Forms & settings"), doc: "docs/forms.md", page: "FormsHubPage" },
                    { label: qsTr("Data collections"), doc: "docs/data-collections.md", page: "DataTablePage" },
                    { label: qsTr("Tree data"), doc: "docs/tree-data.md", page: "TreeViewRecipePage" },
                    { label: qsTr("Density"), doc: "docs/density.md", page: "DensityPage" },
                    { label: qsTr("Touch & pointer"), doc: "docs/touch-pointer.md", page: "TouchPointerPage" },
                    { label: qsTr("Adaptive layout"), doc: "docs/adaptive-layout.md", page: "TwoPaneViewPage" },
                    { label: qsTr("Theme / contrast"), doc: "docs/color-contrast.md", page: "ThemeOverridesPage" },
                    { label: qsTr("Icons"), doc: "docs/icons.md", page: "FontIconPage" },
                    { label: qsTr("AnimatedIcon"), doc: "docs/icons.md", page: "AnimatedIconPage" },
                    { label: qsTr("i18n / RTL"), doc: "docs/i18n-rtl.md", page: "I18nRtlPage" },
                    { label: qsTr("Navigation / TabView"), doc: "docs/navigation.md", page: "NavigationViewPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: Theme.textPrimary
                            font.weight: Theme.fontWeightSemiBold
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            Layout.fillWidth: true
                            text: modelData.doc
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Feedback, commands, a11y")
        qmlSource: "docs/feedback.md · docs/dialogs-flyouts.md · docs/keyboard.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("Feedback surfaces"), doc: "docs/feedback.md", page: "FeedbackHubPage" },
                    { label: qsTr("Dialogs & flyouts / queue"), doc: "docs/dialogs-flyouts.md", page: "DialogsFlyoutsPage" },
                    { label: qsTr("Commands & menus"), doc: "docs/commands.md", page: "CommandsHubPage" },
                    { label: qsTr("Keyboard-first"), doc: "docs/keyboard.md", page: "KeyboardFirstPage" },
                    { label: qsTr("On-screen keyboard (1.84)"), doc: "docs/on-screen-keyboard.md", page: "OnScreenKeyboardPage" },
                    { label: qsTr("Search recipes"), doc: "docs/search.md", page: "SearchRecipesPage" },
                    { label: qsTr("Print / share / export"), doc: "docs/print-share.md", page: "PrintSharePage" },
                    { label: qsTr("Security & trust"), doc: "docs/security-trust.md", page: "SecurityTrustPage" },
                    { label: qsTr("Settings persistence"), doc: "docs/settings-persistence.md", page: "SettingsPersistencePage" },
                    { label: qsTr("Theme prefs (copy recipe)"), doc: "docs/theme-overrides.md", page: "ThemePrefsPage" },
                    { label: qsTr("Accessibility"), doc: "docs/accessibility.md", page: "AccessibilityPage" },
                    { label: qsTr("Drag-drop & clipboard"), doc: "docs/drag-drop.md", page: "FileDropZonePage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: Theme.textPrimary
                            font.weight: Theme.fontWeightSemiBold
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            Layout.fillWidth: true
                            text: modelData.doc
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Media, charts, performance")
        qmlSource: "docs/webview2.md · docs/charts.md · docs/performance.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("WebView2"), doc: "docs/webview2.md", page: "WebView2Page" },
                    { label: qsTr("Media (permanent defer 2.09)"), doc: "docs/media.md", page: "MediaPlayerElementPage" },
                    { label: qsTr("Charts (stable six + compose 2.26)"), doc: "docs/charts.md", page: "ChartsPage" },
                    { label: qsTr("Dashboard + icons (2.65 track)"), doc: "docs/planning/expansion/icons-dashboard-expansion.md", page: "DashboardPage" },
                    { label: qsTr("Iconography catalog"), doc: "docs/icons.md", page: "FontIconPage" },
                    { label: qsTr("Animations"), doc: "docs/animations.md", page: "AnimationsPage" },
                    { label: qsTr("Performance / cold start"), doc: "docs/performance.md", page: "PerformancePage" },
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: Theme.textPrimary
                            font.weight: Theme.fontWeightSemiBold
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            Layout.fillWidth: true
                            text: modelData.doc
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }
}
