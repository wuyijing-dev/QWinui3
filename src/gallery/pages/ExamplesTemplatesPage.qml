import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Example app templates (1.26). examples/README.md

CatalogPage {
    id: page
    title: qsTr("Example templates")
    subtitle: qsTr("Copy-ready apps under examples/ — examples/README.md (1.26).")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Build examples")
        qmlSource: "QWINUI3_BUILD_EXAMPLES=ON\ncmake --build … --target qwinui3_example_*"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Local builds enable examples by default. CI smoke turns them off for speed. Open examples/*/CMakeLists.txt from Qt Creator or use CMakePresets example-* targets. Full Creator notes: Qt Creator page.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "cmake --build build --config Release --target qwinui3_example_nav"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "cmake --build build --config Release --target qwinui3_example_nav"
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Templates")
        qmlSource: "examples/nav-settings · master-detail · form-settings · …"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { name: "nav-settings", recipe: qsTr("Navigation + settings shell"), page: "NavigationViewPage" },
                    { name: "master-detail", recipe: qsTr("ListDetailsView LoB tickets"), page: "ListDetailsViewPage" },
                    { name: "form-settings", recipe: qsTr("FormLayout + SettingsCard prefs"), page: "FormsHubPage" },
                    { name: "settings-cards", recipe: qsTr("SettingsCard patterns"), page: "SettingsCardPage" },
                    { name: "dashboard", recipe: qsTr("Stable charts / KPI tiles"), page: "ChartsPage" }
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
