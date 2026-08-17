import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Recipes hub (docs/recipes.md). Navigate to related demos via openControl.

CatalogPage {
    id: page
    title: qsTr("Recipes hub")
    subtitle: qsTr("All LoB how-tos from docs/recipes.md — open the matching Gallery demo.")

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
                    { label: qsTr("Window shells / chrome"), doc: "docs/window-shells.md", page: "WindowParadigmPage" },
                    { label: qsTr("Multi-window"), doc: "docs/window-shells.md", page: "MultiWindowPage" },
                    { label: qsTr("Linux / Wayland + system integration"), doc: "docs/platform-linux-wayland.md", page: "SystemIntegrationPage" },
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
                    { label: qsTr("Media"), doc: "docs/media.md", page: "MediaPlayerElementPage" },
                    { label: qsTr("Charts"), doc: "docs/charts.md", page: "ChartsPage" },
                    { label: qsTr("Animations"), doc: "docs/animations.md", page: "AnimationsPage" },
                    { label: qsTr("Performance / cold start"), doc: "docs/performance.md", page: "PerformancePage" }
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
