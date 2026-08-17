import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Example app templates (1.26). examples/README.md

CatalogPage {
    id: page
    title: qsTr("Example templates")
    subtitle: qsTr("Copy-ready apps under examples/ — start from gallery-shell (1.50). examples/README.md.")

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
                text: qsTr("Prefer examples/gallery-shell for product chrome (NavigationWindow + Settings + persistence). Multi-window tool/dialog shells: examples/multi-window (1.56). Shared-kit find_package sketch: examples/find-package-consumer (1.61) — not in the monorepo example build. Do not copy the full Gallery tree. CI smoke turns examples off for speed. Qt Creator: open the repo root.")
                font.family: Theme.fontFamily
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
                    { name: "gallery-shell", recipe: qsTr("NavigationWindow app shell (1.50) — keep vs delete in README"), page: "WindowParadigmPage" },
                    { name: "multi-window", recipe: qsTr("Main + tool + owned dialog (1.56)"), page: "MultiWindowPage" },
                    { name: "nav-settings", recipe: qsTr("StandardWindow + NavigationView hand-wire"), page: "NavigationViewPage" },
                    { name: "master-detail", recipe: qsTr("ListDetailsView LoB tickets"), page: "ListDetailsViewPage" },
                    { name: "form-settings", recipe: qsTr("FormLayout + SettingsCard prefs"), page: "FormsHubPage" },
                    { name: "settings-cards", recipe: qsTr("SettingsCard patterns"), page: "SettingsCardPage" },
                    { name: "dashboard", recipe: qsTr("Stable charts / KPI tiles"), page: "ChartsPage" },
                    { name: "find-package-consumer", recipe: qsTr("find_package(QWinUI3) sketch (1.61) — standalone"), page: "ExamplesTemplatesPage" }
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
