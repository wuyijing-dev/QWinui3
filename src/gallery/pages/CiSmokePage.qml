import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — CI smoke + Qt version compat (1.06 / 1.14 / 1.20).
// docs/ci-smoke.md · docs/qt-version-compat.md

CatalogPage {
    id: page
    title: qsTr("CI / smoke")
    subtitle: qsTr("Gallery --smoke · visual subset · docs links · Qt matrix — docs/ci-smoke.md (1.62).")

    ControlExample {
        headerText: qsTr("Local smoke")
        qmlSource: "python scripts/smoke_gallery.py --build-dir build"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Release-build Gallery, then smoke_gallery.py: catalog check, translation seeds, shared-package contracts, docs links (1.52), then qwinui3_gallery --smoke (loads critical pages). Windows coerces foreign QT_QPA_PLATFORM to windows.")
                font.family: Theme.fontFamily
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
        headerText: qsTr("Visual smoke subset (1.62)")
        qmlSource: "python scripts/smoke_visual.py --build-dir build"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Opt-in frame grab of Home + Button + ContentDialog + Pitfalls + ExamplesTemplates (960×640 PNG + sha256). Not on every PR — keeps default --smoke fast. Hash compare is best-effort; primary gate is non-empty frames. Docs: ci-smoke.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/smoke_visual.py --build-dir build"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/smoke_visual.py --build-dir build"
                }
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
                text: qsTr("Support floor Qt 6.5+; recommended 6.8 LTS; forward 6.10+. smoke.yml stays on 6.8. Compat workflow builds Gallery Release on Linux for 6.5.3 / 6.8.3 / 6.10.0. Not a full screenshot farm — visual subset is opt-in (1.62).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Home recentlyShipped + favorites are Gallery UX (1.20) — not a substitute for smoke.")
            }
        }
    }
}
