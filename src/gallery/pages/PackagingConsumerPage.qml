import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Consumer packaging & shared redistribute.
//
// Surfaces docs/packaging-consumer.md: shared vs static, windeploy/linuxdeploy,
// strip-restricted modules.

CatalogPage {
    id: page
    title: qsTr("Consumer packaging")
    subtitle: qsTr("Shared zip · CMake · windeploy / strip — docs/packaging-consumer.md.")

    property string statusText: qsTr("Copy a command, then run it from a Release Qt shell.")

    function noteCopied(label) {
        page.statusText = qsTr("Copied: %1").arg(label)
    }

    ControlExample {
        headerText: qsTr("Status")
        qmlSource: "docs/packaging-consumer.md"
        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            color: Theme.textPrimary
            text: page.statusText
        }
    }

    ControlExample {
        headerText: qsTr("Shared vs static")
        qmlSource: "QWINUI3_BUILD_SHARED=ON\npython scripts/package_release_libs.py --shared"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Release CI ships shared kits (DLL/.so + qml/). Gallery itself links QWinUI3 statically and deploys Qt with windeployqt / linuxdeploy. Prefer shared zips for third-party redistribute; static for single-app / in-tree.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Shared: link qwinui3_* only; copy bin/*.dll (Win) or LD_LIBRARY_PATH/rpath lib/ (Linux).\nStatic: also link qwinui3_*plugin; still ship the Qt runtime.\nPresets: all · core (+platform via style) · shell · extras · theme.")
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("MSVC shared builds enable CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS so helpers like ThemeFonts::ensureLoaded cross DLL boundaries.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Package commands (copy)")
        qmlSource: "python scripts/package_release_libs.py --shared --archive"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/package_release_libs.py --shared --archive"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/package_release_libs.py --shared --archive"
                    onCopyCompleted: page.noteCopied(qsTr("full shared package"))
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/package_release_libs.py --shared --preset core --archive"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/package_release_libs.py --shared --preset core --archive"
                    onCopyCompleted: page.noteCopied(qsTr("core preset"))
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/package_release_libs.py --list-modules"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/package_release_libs.py --list-modules"
                    onCopyCompleted: page.noteCopied(qsTr("list modules"))
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/package_release_gallery.py"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/package_release_gallery.py"
                    onCopyCompleted: page.noteCopied(qsTr("gallery package"))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Validate package tree")
        qmlSource: "python scripts/verify_find_package.py --package-dir dist/…"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("After packaging a shared kit, run verify_find_package against the dist folder (consumer-matrix CI does this). Restricted Qt add-ons must not leak into the kit zip.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/verify_find_package.py --package-dir dist/qwinui3-<ver>-windows-x64-shared"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/verify_find_package.py --package-dir dist/qwinui3-<ver>-windows-x64-shared"
                    onCopyCompleted: page.noteCopied(qsTr("find_package check"))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Deploy your app (windeploy / linuxdeploy)")
        qmlSource: "windeployqt --qmldir … --release myapp.exe\nlinuxdeploy + linuxdeploy-plugin-qt"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: WindowHelper.windows
                      ? qsTr("Windows: copy QWinUI3 bin/*.dll beside the exe, then windeployqt for Qt Quick/Controls. Keep engine.addImportPath on the package qml/ folder (or copy that tree).")
                      : qsTr("Linux: rpath or LD_LIBRARY_PATH to package lib/; gather Qt with linuxdeploy + linuxdeploy-plugin-qt (Gallery packaging uses the same tools).")
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("QWinUI3 shared zips do not include the Qt runtime. Match Qt major/minor to the kit you link (CI packages use 6.8.x; apps may target 6.5+).")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "windeployqt --qmldir path\\to\\qml --release myapp.exe"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "windeployqt --qmldir path\\to\\qml --release myapp.exe"
                    onCopyCompleted: page.noteCopied(qsTr("windeployqt"))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Strip-restricted Qt modules")
        qmlSource: "qwinui3_strip_restricted_qt_modules(myapp)\n# VirtualKeyboard / Charts / WebEngine / Quick3D …"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("QWinUI3 is Apache-2.0 (docs/licensing.md). windeployqt may copy GPL Qt add-ons (Virtual Keyboard) — use StripRestrictedQtModules or package_release_gallery cleanup.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Helper: include(cmake/StripRestrictedQtModules.cmake)\nqwinui3_strip_restricted_qt_modules(myapp)")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Consume paths A / B / C")
        qmlSource: "QWINUI3_ROOT=…/qwinui3-*-shared\nadd_subdirectory(third_party/QWinui3)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("A — Download GitHub Release shared zip; link libs; addImportPath(qml/); copy bin/ on Windows.\nB — package_release_libs.py from this repo → dist/ → same as A.\nC — add_subdirectory with QWINUI3_BUILD_SHARED ON/OFF; static also needs *plugin targets.")
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Bootstrap: QWinUI3::configureEnvironment before QGuiApplication; set QT_QUICK_CONTROLS_STYLE=QWinUI3. Full CMake snippet: docs/packaging-consumer.md. No find_package(QWinUI3) Config yet.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Host now: %1 · use WindowHelper.windows to gate Win-only deploy steps.")
                    .arg(WindowHelper.windows ? qsTr("Windows") : qsTr("non-Windows"))
            }
        }
    }
}
