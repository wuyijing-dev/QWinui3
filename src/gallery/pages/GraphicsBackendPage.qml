import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Graphics / RHI backend (1.31). docs/graphics-backend.md

CatalogPage {
    id: page
    title: qsTr("Graphics backend")
    subtitle: qsTr("RHI ship table · OpenGL for frost — docs/graphics-backend.md (1.31).")

    signal openSettings()

    ControlExample {
        headerText: qsTr("Current backend")
        qmlSource: "GraphicsBackend · --rhi · QSG_RHI_BACKEND"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Windows default stays OpenGL for reliable frost/backdrop. Change via Settings → Graphics backend, Gallery --rhi, or QSG_RHI_BACKEND (restart required). Consumer apps can call Compat::Rhi::apply before QGuiApplication.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Available: %1\nCurrent / preferred: see Settings (footer). Host OS: %2")
                    .arg(GraphicsBackend.available.join(", "))
                    .arg(WindowHelper.windows ? qsTr("Windows") : qsTr("non-Windows"))
            }
            Button {
                text: qsTr("Open Settings (change RHI)")
                highlighted: true
                onClicked: page.openSettings()
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "qwinui3_gallery.exe --rhi opengl"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "qwinui3_gallery.exe --rhi opengl"
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Caveats")
        qmlSource: "// Alpha / Mica / MultiEffect follow the active RHI\n// docs/graphics-backend.md · docs/window-transparency-dwm.md"
        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            color: Theme.textSecondary
            text: qsTr("Backdrop / acrylic / MultiEffect quality differs by RHI and OS. Prefer Solid on Linux when Mica looks hollow. Full matrix: docs/graphics-backend.md and Window shells page.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
        }
    }
}
