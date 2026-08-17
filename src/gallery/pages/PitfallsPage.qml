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
    subtitle: qsTr("Anti-patterns + 1.xx freeze / maturity — docs/compatibility-1xx.md · docs/maturity-1xx.md (1.51).")

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
        headerText: qsTr("1.xx maturity checkpoint (1.51)")
        qmlSource: "// Prefer harden · gallery-shell · stable-api\\n// docs/maturity-1xx.md · docs/compatibility-1xx.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("1.51 is a deliberate “where we are” release—not 2.00. Prefer stable-api types, examples/gallery-shell for app chrome, and field harden over new control families for a while. Freeze gate from 1.40 remains active. Full notes: docs/maturity-1xx.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Starting apps from examples/gallery-shell (not full Gallery)") }
            CheckBox { text: qsTr("Sticking to docs/stable-api.md for product surfaces") }
            CheckBox { text: qsTr("Treating Media / ConnectedAnimation / niche charts as experimental") }
            CheckBox { text: qsTr("Planning field P0s into 1.52+ instead of inventing new APIs") }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Link audit: python scripts/checkpoint_1_51_audit.py · Roadmap continues 1.52…1.70.")
            }
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
