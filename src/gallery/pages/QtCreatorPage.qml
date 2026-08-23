import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Qt Creator kit polish (1.35). Recipe: docs/qt-creator.md

CatalogPage {
    id: page
    title: qsTr("Qt Creator")
    subtitle: qsTr("Open Gallery / examples with CMake kits — docs/qt-creator.md (1.35).")

    property string statusText: qsTr("Copy a path or preset, then open in Qt Creator.")

    function note(msg) { page.statusText = msg }

    ControlExample {
        headerText: qsTr("Status")
        qmlSource: "docs/qt-creator.md"
        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            color: Theme.textPrimary
            text: page.statusText
        }
    }

    ControlExample {
        headerText: qsTr("Open this monorepo")
        qmlSource: "File → Open File or Project → CMakeLists.txt\n(no .pro)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use the root CMakeLists.txt only. Pick a Qt 6.5+ kit (6.8 recommended): MSVC 2022 x64 on Windows, gcc_64 on Linux. Configure Release. Build target qwinui3_gallery.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "CMakeLists.txt"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "CMakeLists.txt"
                    onCopyCompleted: page.note(qsTr("Copied root CMakeLists.txt hint"))
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "cmake --preset release"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "cmake --preset release"
                    onCopyCompleted: page.note(qsTr("Copied cmake --preset release"))
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "cmake --build --preset release --target qwinui3_gallery"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "cmake --build --preset release --target qwinui3_gallery"
                    onCopyCompleted: page.note(qsTr("Copied gallery build"))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Example presets")
        qmlSource: "CMakePresets.json → examples / example-*"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Presets examples / example-nav-settings / example-master-detail / example-form-settings / example-dashboard / example-settings-cards build the copy-ready apps under examples/. See Examples templates page and docs/qt-creator.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Kit checklist: Qt Quick + QuickControls2 + LabsQmlModels; CMAKE_PREFIX_PATH → kit; Release config; no qmake .pro.")
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Host: %1 — match Creator kit OS to this machine.")
                    .arg(WindowHelper.windows ? qsTr("Windows") : qsTr("non-Windows"))
            }
        }
    }

    ControlExample {
        headerText: qsTr("Consumer apps")
        qmlSource: "docs/packaging-consumer.md · Path A/B/C"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Third-party apps: open your app CMakeLists (Path C add_subdirectory) or point QWINUI3_ROOT at a shared zip (Path A). Full recipe on Consumer packaging page / docs/packaging-consumer.md.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }
}
