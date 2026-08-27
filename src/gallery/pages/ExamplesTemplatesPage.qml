import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Example app templates. examples/README.md

CatalogPage {
    id: page
    title: qsTr("Example templates")
    subtitle: qsTr("Copy-ready apps under examples/ — start from first-app or gallery-shell. examples/README.md.")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Build examples")
        qmlSource: "QWINUI3_BUILD_EXAMPLES=ON\ncmake --build … --target qwinui3_example_gallery_shell"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Prefer examples/first-app for the first hour, then gallery-shell for Settings. Floating OSK: examples/floating-osk. Multi-window: examples/multi-window. find_package: examples/find-package-consumer. CI smoke turns examples off for speed. Qt Creator: open the repo root.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "cmake --build build --config Release --target qwinui3_example_gallery_shell"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "cmake --build build --config Release --target qwinui3_example_gallery_shell"
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Templates")
        qmlSource: "examples/gallery-shell · nav-settings · master-detail · …"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { name: "first-app", recipe: qsTr("Smallest NavigationWindow + DashboardShell — start here"), page: "ExamplesTemplatesPage" },
                    { name: "gallery-shell", recipe: qsTr("NavigationWindow app shell — Settings prefs + geometry"), page: "SettingsPersistencePage" },
                    { name: "multi-window", recipe: qsTr("Main + tool + owned dialog"), page: "MultiWindowPage" },
                    { name: "nav-settings", recipe: qsTr("StandardWindow + NavigationView hand-wire"), page: "NavigationViewPage" },
                    { name: "master-detail", recipe: qsTr("ListDetailsView LoB tickets"), page: "ListDetailsViewPage" },
                    { name: "form-settings", recipe: qsTr("FormLayout + Settings persistence"), page: "SettingsPersistencePage" },
                    { name: "floating-osk", recipe: qsTr("OnScreenKeyboardWindow host"), page: "OnScreenKeyboardPage" },
                    { name: "settings-cards", recipe: qsTr("SettingsCard patterns"), page: "SettingsCardPage" },
                    { name: "dashboard", recipe: qsTr("Stable six KPI/charts"), page: "DashboardPage" },
                    { name: "find-package-consumer", recipe: qsTr("find_package(QWinUI3) sketch — standalone"), page: "ExamplesTemplatesPage" },
                    { name: "python-gallery", recipe: qsTr("Full Gallery from PySide6 / PyQt6 — packaging-python.md"), page: "ExamplesTemplatesPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            text: "examples/" + modelData.name
                            color: Theme.textPrimary
                            font.weight: Theme.fontWeightSemiBold
                        }
                        Label {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            text: modelData.recipe
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                        }
                    }
                    Button {
                        text: qsTr("Related demo")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }
}
