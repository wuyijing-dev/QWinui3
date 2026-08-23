import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — CI smoke + Qt version compat (1.06 / 1.14 / 1.20).
// python scripts/smoke_gallery.py · docs/qt-version-compat.md

CatalogPage {
    id: page
    title: qsTr("CI / smoke")
    subtitle: qsTr("Gallery --smoke · docs links · Qt matrix — python scripts/smoke_gallery.py.")

    ControlExample {
        headerText: qsTr("Local smoke")
        qmlSource: "python scripts/smoke_gallery.py --build-dir build"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Release-build Gallery, then smoke_gallery.py: catalog check and example QML import lint, then qwinui3_gallery --smoke (loads critical pages). Windows coerces foreign QT_QPA_PLATFORM to windows.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/smoke_gallery.py --build-dir build"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/smoke_gallery.py --build-dir build"
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/smoke_catalog.py --list-critical"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/smoke_catalog.py --list-critical"
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Host: %1 · prefer QT_QPA_PLATFORM=windows on Win kits.")
                    .arg(WindowHelper.windows ? qsTr("Windows") : qsTr("non-Windows"))
            }
        }
    }

    ControlExample {
        headerText: qsTr("Qt version matrix (1.14)")
        qmlSource: "qt-compat.yml · 6.5 / 6.8 / 6.10\ndocs/qt-version-compat.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Support floor Qt 6.5+; recommended 6.8 LTS; forward 6.10+. smoke.yml stays on 6.8. Compat workflow builds Gallery Release on Linux for 6.5.3 / 6.8.3 / 6.10.0. Not a screenshot farm.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Home Recent/Favorites are Gallery UX — not a substitute for smoke.")
            }
        }
    }
}
