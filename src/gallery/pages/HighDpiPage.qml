import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — High-DPI & multi-monitor (1.58 · 2.15 wave 3).
// Recipe: docs/high-dpi.md · docs/window-chrome.md · docs/graphics-backend.md

CatalogPage {
    id: page
    title: qsTr("High-DPI & monitors")
    subtitle: qsTr("DPR readout · fractional scale · per-monitor soak — docs/high-dpi.md (2.15).")

    signal openControl(var item)

    property int screenTick: 0

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    function refreshScreens() {
        page.screenTick++
    }

    function screenRows() {
        var _ = page.screenTick
        var list = WindowHelper.screensInfo()
        var parts = []
        for (var i = 0; i < list.length; ++i) {
            var s = list[i]
            var g = s.geometry
            var a = s.availableGeometry
            parts.push((s.primary ? qsTr("[primary] ") : "") + s.name
                       + qsTr("  dpr=%1").arg(Number(s.dpr).toFixed(2))
                       + (s.fractionalScale ? qsTr("  [fractional]") : "")
                       + qsTr("  geom=%1×%2@%3,%4")
                           .arg(g.width).arg(g.height).arg(g.x).arg(g.y)
                       + qsTr("  avail=%1×%2@%3,%4")
                           .arg(a.width).arg(a.height).arg(a.x).arg(a.y))
        }
        return parts.length ? parts.join("\n") : qsTr("(no screens)")
    }

    Connections {
        target: WindowHelper
        function onScreensChanged() { page.refreshScreens() }
    }

    ControlExample {
        headerText: qsTr("Live DPR (2.15)")
        qmlSource: "Theme.devicePixelRatio\nWindowHelper.devicePixelRatioForWindow(window)\nWindowHelper.highDpiScaleFactorRoundingPolicy()"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Theme.devicePixelRatio tracks this Gallery window’s screen. WindowHelper.devicePixelRatio is the primary screen (diagnostics). After drag/restore across monitors, Theme should match the window screen — docs/high-dpi.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: {
                    var _ = page.screenTick
                    var win = page.Window ? page.Window.window : null
                    var winDpr = win ? WindowHelper.devicePixelRatioForWindow(win) : Theme.devicePixelRatio
                    var screenDpr = (win && win.screen) ? win.screen.devicePixelRatio : winDpr
                    return qsTr("Window screen DPR: %1 · Theme DPR: %2 · Primary DPR: %3 · rounding: %4 · screens: %5 · hairline: %6")
                        .arg(Number(screenDpr).toFixed(2))
                        .arg(Theme.devicePixelRatio.toFixed(2))
                        .arg(WindowHelper.devicePixelRatio.toFixed(2))
                        .arg(WindowHelper.highDpiScaleFactorRoundingPolicy())
                        .arg(WindowHelper.screenCount)
                        .arg(Theme.strokeHairline.toFixed(3))
                }
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Refresh")
                    onClicked: page.refreshScreens()
                }
                Button {
                    text: qsTr("Window shells")
                    onClicked: page.openComp("WindowParadigmPage")
                }
                Button {
                    text: qsTr("Graphics backend")
                    onClicked: page.openComp("GraphicsBackendPage")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("screensInfo()")
        qmlSource: "WindowHelper.screensInfo()\n// name · dpr · fractionalScale · geometry · availableGeometry"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WrapAnywhere
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                text: page.screenRows()
            }
        }
    }

    ControlExample {
        headerText: qsTr("Geometry restore")
        qmlSource: "geometryPersistenceKey: \"GalleryMain\"\nWindowHelper.clearWindowGeometry(…)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Gallery Main uses key \"GalleryMain\". Restore clamps to availableGeometry and (1.58) binds setScreen so mixed-DPI DPR updates. Clear below, resize/move, restart Gallery to verify.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontBody
            }
            Button {
                text: qsTr("Clear GalleryMain geometry")
                onClicked: {
                    WindowHelper.clearWindowGeometry("GalleryMain")
                    page.refreshScreens()
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Per-monitor geometry soak (2.15)")
        qmlSource: "WindowHelper.screensInfo() // drag window across monitors"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Move this Gallery window to each monitor listed below. After each move, confirm Theme DPR matches the window screen DPR and screensInfo() shows the correct geometry / availableGeometry. On Wayland with fractional scale, dpr may be non-integer and fractionalScale is true — docs/high-dpi.md.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontBody
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WrapAnywhere
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
                text: page.screenRows()
            }
        }
    }

}

