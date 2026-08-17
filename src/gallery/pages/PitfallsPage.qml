import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Common pitfalls / anti-patterns.
//
// Side-by-side wrong vs right patterns for radius, clip, and progress fills.
// Compatibility freeze: docs/compatibility-1xx.md (1.40).

CatalogPage {
    id: page

    title: qsTr("Pitfalls")
    subtitle: qsTr("Anti-patterns + tranche-1 checkpoint (2.50) — docs/checkpoint-250.md")

    property real demoProgress: 0.65

    Timer {
        interval: 40
        running: page.visible
        repeat: true
        onTriggered: {
            page.demoProgress += 0.004
            if (page.demoProgress > 1.05)
                page.demoProgress = 0
        }
    }

    ControlExample {
        headerText: qsTr("Long-horizon checkpoint (1.78) · field 1.79")
        qmlSource: "// Still 1.xx · field harden / pause · not 2.00\\n// docs/checkpoint-178.md · docs/platform-linux-wayland.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("1.78 closed the long-horizon arc (still not 2.00). 1.79 is the first field harden: Linux/Wayland portal parent_window + session detect + OSK CapsLock. OnScreenKeyboard / IME stays experimental. Full notes: docs/checkpoint-178.md · docs/platform-linux-wayland.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Starting apps from examples/gallery-shell (not full Gallery)") }
            CheckBox { text: qsTr("Sticking to docs/stable-api.md for product surfaces") }
            CheckBox { text: qsTr("Treating OnScreenKeyboard / Media / niche charts as experimental") }
            CheckBox { text: qsTr("Preferring field P0s / pause over inventing new APIs") }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Also: docs/checkpoint-160.md (1.60 mid-horizon) · docs/maturity-1xx.md (1.51)")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Mid-horizon checkpoint (1.60)")
        qmlSource: "// Still 1.xx · harden-first · not 2.00\\n// docs/checkpoint-160.md · docs/maturity-1xx.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("1.60 re-audits the 1.line halfway through 1.49…1.70. Still not 2.00. Prefer stable-api types, examples/gallery-shell, and field harden. Experimental defer list unchanged. Historical next was 1.61 CMake sketch — see ROADMAP. Full notes: docs/checkpoint-160.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Starting apps from examples/gallery-shell (not full Gallery)") }
            CheckBox { text: qsTr("Sticking to docs/stable-api.md for product surfaces") }
            CheckBox { text: qsTr("Treating Media / ConnectedAnimation / niche charts as experimental") }
            CheckBox { text: qsTr("Planning field P0s into later 1.xx instead of inventing new APIs") }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Link audit: python scripts/check_docs_links.py · Roadmap continues 1.61…1.70.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Linux portal / FilePicker (1.68)")
        qmlSource: "// Always pass Window.window\\n// docs/platform-linux-wayland.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Pass Window.window to FilePicker. X11 gets x11:0x…; pure Wayland parent is stronger in 1.79 (xdg-foreign when available) but may still be empty. After a portal dialog starts, cancel/timeout must not open zenity as a second dialog. Reveal: FileManager1 then OpenURI. Cookbook: docs/platform-linux-wayland.md · Gallery System integration.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("FilePicker always gets Window.window") }
            CheckBox { text: qsTr("Cancel / timeout → empty path (no second dialog)") }
            CheckBox { text: qsTr("nameFilters forwarded on Linux (portal / zenity)") }
        }
    }

    ControlExample {
        headerText: qsTr("Media — permanent defer (2.09)")
        qmlSource: "// MediaPlayerElement stays experimental\\n// docs/media.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("2.09 verdict: do not promote MediaPlayerElement. Optional Qt Multimedia, codec/backends, and plugin deploy are app-owned — not stable-api. Gallery demos the shell + stub only. Cookbook: docs/media.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Product shells do not require MediaPlayerElement") }
            CheckBox { text: qsTr("available === false → EmptyState, never crash") }
            CheckBox { text: qsTr("windeployqt / installer ships Multimedia plugins") }
        }
    }

    ControlExample {
        headerText: qsTr("Charts polish (1.66)")
        qmlSource: "// Stable six only in product dashboards\\n// docs/charts.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Keep LineChart / BarChart / DonutChart / RingGauge / KpiTile / ChartCard. Area/Pie/Sparkline and extra gauges are permanently deferred (2.08) — use compose recipes in docs/charts.md. Copy examples/dashboard.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Product dashboards use only the stable six") }
            CheckBox { text: qsTr("AreaChart → LineChart showArea; PieChart → DonutChart") }
            CheckBox { text: qsTr("Extra gauges → RingGauge (Tank/Thermo stay Gallery-only)") }
        }
    }

    ControlExample {
        headerText: qsTr("Settings persistence (1.65)")
        qmlSource: "// Settings category ≠ geometryPersistenceKey\\n// docs/settings-persistence.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Keep WindowGeometry on geometryPersistenceKey. Put theme / toggles in QtCore Settings (or QSettings). Portable = Ini beside the exe. “Roaming” = copy Ini — not a cloud product. Cookbook: docs/settings-persistence.md · Gallery Settings persistence · examples/form-settings.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("geometryPersistenceKey only for window frames") }
            CheckBox { text: qsTr("Prefs in a separate Settings / QSettings category") }
            CheckBox { text: qsTr("schemaVersion migration when changing defaults") }
        }
    }

    ControlExample {
        headerText: qsTr("Security & trust (1.64)")
        qmlSource: "// WebView2 allowlist · drop filters · picker parent\\n// docs/security-trust.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Not a sandbox product. Gate WebView2 URLs, keep FileDropZone acceptExtensions non-empty for production ingest, never auto-execute drops, and always pass Window.window to FilePicker. Cookbook: docs/security-trust.md · Gallery Security & trust.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("WebView2 source gated (no free-form production URL bar)") }
            CheckBox { text: qsTr("Drop zone acceptExtensions non-empty; no auto-execute") }
            CheckBox { text: qsTr("FilePicker gets Window.window; cancel = empty") }
        }
    }

    ControlExample {
        headerText: qsTr("Tranche-1 checkpoint (2.50)")
        qmlSource: "// 2.00…2.50 audited — friction-only 2.51+\\n// docs/checkpoint-250.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("2.50 closes tranche 1: close-out 2.44…2.49 shipped; conditional controls justified by friction-log; post-2.50 tags need open P0/P1. 2.00 breaking baseline still Next. Full audit: docs/checkpoint-250.md · docs/planning/friction-log.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("After 2.50: friction-only minors — skip tag if queue empty") }
            CheckBox { text: qsTr("Copy Gallery demos only with experimental/stable badges") }
            CheckBox { text: qsTr("2.00 lift not bundled — read compatibility-1xx.md") }
            CheckBox { text: qsTr("Re-read docs/checkpoint-250.md after friction-log edits") }
        }
    }

    ControlExample {
        headerText: qsTr("Stable vs experimental clarity (2.51 / FL-004)")
        qmlSource: "python scripts/lint_qml_imports.py\\n// docs/stable-clarity-251.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("2.51 closes FL-004 queue: import guard recap in stable-api, example lint over examples/, and Pitfalls checklist. Run lint before copying starters. Full notes: docs/stable-clarity-251.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Product QML: stable-api imports only — check Gallery badge first") }
            CheckBox { text: qsTr("Run python scripts/lint_qml_imports.py after editing example starters") }
            CheckBox { text: qsTr("Dashboard: stable six only — not deferred chart siblings") }
            CheckBox { text: qsTr("OSK only via examples/floating-osk until 2.01 promote") }
        }
    }

    ControlExample {
        headerText: qsTr("Dashboard compose (2.48 / FL-009)")
        qmlSource: "// Stable six only in product\\n// docs/dashboard-compose-decision.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("2.48 friction slot closes FL-009 partial: use the compose decision tree before importing deferred chart types. KpiTile + ChartCard stable six — not Sparkline/AreaChart/PieChart in product. docs/dashboard-compose-decision.md · Gallery Dashboard.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Product dashboard: stable six only (FL-009)") }
            CheckBox { text: qsTr("Deferred charts: Gallery demos + compose recipes only") }
            CheckBox { text: qsTr("ChartCard.symbol set on every card (icons track)") }
            CheckBox { text: qsTr("Copy examples/dashboard — not deferred gauge pages") }
        }
    }

    ControlExample {
        headerText: qsTr("Field harden buffer (2.47 / FL-003 + FL-004)")
        qmlSource: "// Checkpoint P0/P1 triage — no new controls\\n// docs/field-harden-247.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("2.47 closes actionable audit rows from checkpoint 2.30 and post-2.45 sweep: packaging path picker (FL-003), QML import guard (FL-004), and smoke loads for Recipes hub + Performance diagnostics. Full notes: docs/field-harden-247.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Pick packaging Path A–E — do not copy Gallery monorepo blindly (FL-003)") }
            CheckBox { text: qsTr("Product QML: stable-api imports only unless badge says experimental (FL-004)") }
            CheckBox { text: qsTr("FrameStats: applyRetailProfile() in retail builds (2.44)") }
            CheckBox { text: qsTr("Charts: stable six in shipping UI — not deferred siblings") }
            CheckBox { text: qsTr("2.51: run lint_qml_imports.py on examples/ — docs/stable-clarity-251.md") }
        }
    }

    ControlExample {
        headerText: qsTr("Experimental vs stable sweep (2.45 / FL-004)")
        qmlSource: "ControlCatalog.apiStabilityForComponent(\"AreaChartPage\")  // permanent-defer\\n// docs/experimental-sweep.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Gallery badges: Experimental (may change) vs Permanent defer (do not ship — use stable six / compose). Page headers and Home Recently shipped show badges. Full matrix: docs/experimental-sweep.md · docs/stable-api.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Product apps: stable-api types only unless documented experimental") }
            CheckBox { text: qsTr("Charts: stable six — not deferred siblings in shipping UI") }
            CheckBox { text: qsTr("Media: permanent defer 2.09 — app-owned Multimedia") }
            CheckBox { text: qsTr("OSK/IME: experimental until 2.01 promote") }
            RowLayout {
                spacing: Theme.spacing
                ApiStabilityBadge { stability: "experimental" }
                ApiStabilityBadge { stability: "permanent-defer" }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Developer diagnostics (2.44)")
        qmlSource: "FrameStatsMonitor.applyRetailProfile()  // Release main\\n// docs/developer-diagnostics.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Never ship FPS/RHI in the title bar for end users. Gallery is a dev profile — Settings may persist Show FPS. Retail apps call applyRetailProfile() before loading QML. FrameStatsMonitor / Badge / Overlay are stable dev tooling only.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("applyRetailProfile() (or retailMode) in Release main") }
            CheckBox { text: qsTr("No FrameStatsBadge in retail TitleBar rightHeader") }
            CheckBox { text: qsTr("--show-diagnostics only on internal / QA builds") }
        }
    }

    ControlExample {
        headerText: qsTr("2.xx tranche pitfalls (2.39)")
        qmlSource: "// Experimental: TreeDataGrid · ItemsWrapGrid · CalendarView · NotificationCenter\\n// docs/gallery-catalog-expansion.md · stable-api.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Every 2.21…2.38 slice has a Gallery catalog entry. Use Home Recently shipped, title-bar search (component id), and docs/gallery-catalog-expansion.md for the smoke matrix. Experimental types may move — check stable-api.md before shipping.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("TreeDataGrid / FileTree: path trust — no raw user paths in production") }
            CheckBox { text: qsTr("CalendarView / ItemsWrapGrid: experimental — not on stable-api") }
            CheckBox { text: qsTr("NotificationCenter: in-app history only — not OS toast replacement") }
            CheckBox { text: qsTr("Theme overrides: restore accent packs after Gallery demos") }
        }
    }

    ControlExample {
        headerText: qsTr("1.xx compatibility (1.40 / 1.51)")
        qmlSource: "// Prefer stable-api + frozen Theme / shell names\\n// docs/compatibility-1xx.md · docs/upgrade-notes.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Product apps should stick to types on docs/stable-api.md and Theme / shell names listed in docs/compatibility-1xx.md. Later 1.xx slices treat that freeze as a merge gate. Consumer upgrade checklist: docs/upgrade-notes.md. Experimental and deferred APIs may still move.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Reinstall / pin QWINUI3_VERSION for this upgrade") }
            CheckBox { text: qsTr("Confirm Qt major/minor matches the linked kit") }
            CheckBox { text: qsTr("Skim stable-api changelog for promotes / defer notes") }
            CheckBox { text: qsTr("Rebuild Release; run Gallery --smoke if you vendor it") }
            CheckBox { text: qsTr("Theme forks use customAccent / packs — not readonly bgCard") }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Stable map: Theme · shells · ContentDialog · FilePicker/Tray · WebView2Host · promoted charts subset · CommandPalette — see docs/stable-api.md. Recipes hub lists every how-to.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Progress fill without matching radius")
        qmlSource: "// Wrong: opaque child, no radius, covers host corners\n// Right: fill.radius = host.radius - border"

        GridLayout {
            Layout.fillWidth: true
            columns: width > 640 ? 2 : 1
            rowSpacing: Theme.spacingLoose
            columnSpacing: Theme.spacingLoose

            ColumnLayout {
                Label {
                    text: qsTr("Wrong — square fill")
                    color: Theme.systemCritical
                    font.weight: Theme.fontWeightSemiBold
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: Theme.controlHeight
                    radius: Theme.cornerControl
                    color: Theme.fillControl
                    border.width: 1
                    border.color: Theme.strokeControl
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * Math.min(1, page.demoProgress)
                        color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.38)
                    }
                }
            }

            ColumnLayout {
                Label {
                    text: qsTr("Right — matching radius + inset")
                    color: Theme.systemSuccess
                    font.weight: Theme.fontWeightSemiBold
                }
                Rectangle {
                    id: goodHost
                    Layout.fillWidth: true
                    height: Theme.controlHeight
                    radius: Theme.cornerControl
                    color: Theme.fillControl
                    border.width: 1
                    border.color: Theme.strokeControl
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 1
                        width: Math.max(0, (parent.width - 2) * Math.min(1, page.demoProgress))
                        radius: Math.max(0, goodHost.radius - 1)
                        color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.38)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("clip: true does not round")
        qmlSource: "// clip: true is axis-aligned only — reveals a square edge at the track head\n"
                   + "// Grow width with matching radius so the pill emerges from the tip"

        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            color: Theme.textSecondary
            text: qsTr("Qt/QML clip is a rectangle. A bar sliding in from outside is always cut by a flat line at the track’s left tip — it never “grows out” of the round. Keep the fill inside and animate its width (or x) with the same radius.")
        }

        GridLayout {
            Layout.fillWidth: true
            columns: width > 640 ? 2 : 1
            rowSpacing: Theme.spacingLoose
            columnSpacing: Theme.spacingLoose

            ColumnLayout {
                Label {
                    text: qsTr("Wrong — clip squares the head")
                    color: Theme.systemCritical
                    font.weight: Theme.fontWeightSemiBold
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                    text: qsTr("Slides in under clip:true → left edge is always a vertical cut.")
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 28
                    radius: height / 2
                    color: Theme.dark ? "#15FFFFFF" : "#0F000000"
                    Item {
                        anchors.fill: parent
                        clip: true
                        Rectangle {
                            id: badBar
                            width: parent.width * 0.35
                            height: parent.height
                            color: Theme.accent
                            SequentialAnimation on x {
                                loops: Animation.Infinite
                                running: page.visible
                                NumberAnimation {
                                    from: -badBar.width
                                    to: badBar.parent ? badBar.parent.width : 200
                                    duration: 1200
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Label {
                    text: qsTr("Right — grow from the tip")
                    color: Theme.systemSuccess
                    font.weight: Theme.fontWeightSemiBold
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                    text: qsTr("Same radius as the track; animate width from 0 so the pill emerges little by little.")
                }
                Rectangle {
                    id: goodTrack
                    Layout.fillWidth: true
                    height: 28
                    radius: height / 2
                    color: Theme.dark ? "#15FFFFFF" : "#0F000000"
                    Rectangle {
                        id: goodBar
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        // Keep ends round even when short (circle → capsule → full).
                        width: 0
                        radius: height / 2
                        color: Theme.accent
                        SequentialAnimation on width {
                            loops: Animation.Infinite
                            running: page.visible
                            NumberAnimation {
                                from: 0
                                to: goodTrack.width
                                duration: 1400
                                easing.type: Easing.InOutCubic
                            }
                            PauseAnimation { duration: 350 }
                            NumberAnimation {
                                from: goodTrack.width
                                to: 0
                                duration: 700
                                easing.type: Easing.InOutCubic
                            }
                            PauseAnimation { duration: 250 }
                        }
                    }
                }
            }
        }
    }
}
