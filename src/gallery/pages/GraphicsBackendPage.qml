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
    subtitle: qsTr("RHI defaults · Win D3D11 / Linux Vulkan + fallback — docs/graphics-backend.md. DPI: docs/high-dpi.md.")

    signal openSettings()
    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Current backend")
        qmlSource: "GraphicsBackend · --rhi · QSG_RHI_BACKEND"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Defaults: Windows D3D11, Linux Vulkan, macOS Metal — with runtime probe fallback (Vulkan ICD / D3D11 DLL / headless QPA). Prefer OpenGL on Windows when shipping Mica/Acrylic frost. Change via Settings → Graphics backend, --rhi, or QSG_RHI_BACKEND. Kit bootstrap applies the default when the env is unset. DPI restore: docs/high-dpi.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Live RHI readout: enable Settings → Show FPS + Show RHI (2.04) or run with --show-diagnostics. Title-bar badge shows FPS · ms · backend without opening Settings. Retail apps: docs/developer-diagnostics.md (2.44).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Button {
                onClicked: page.openComp("HighDpiPage")
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
