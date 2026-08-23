import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Common pitfalls / anti-patterns.
//
// Side-by-side wrong vs right patterns for radius, clip, and progress fills.
// Recipe pointers live in docs/ — not version completion checklists here.

CatalogPage {
    id: page

    title: qsTr("Pitfalls")
    subtitle: qsTr("Wrong vs right QML patterns — radius, clip, and progress fills.")

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
        headerText: qsTr("Before you ship")
        qmlSource: "// docs/stable-api.md · docs/compatibility-1xx.md · docs/upgrade-notes.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Product apps should stick to types on docs/stable-api.md. Prefer examples/gallery-shell over copying Gallery sources. Experimental and deferred APIs may move — see docs/experimental-sweep.md.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
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

    ControlExample {
        headerText: qsTr("ErrorBoundary recovery pattern")
        qmlSource: "ErrorBoundary {\n    onRetryRequested: /* reload Loader */\n    sessionRestore: session\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("When a Loader or page fails, show recovery UI instead of a blank shell. Wire onRetryRequested to recreate the view; optional sessionRestore uses SessionRestore (2.70). Not a crash dumper — see Pitfalls, not a version checklist.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            ErrorBoundary {
                Layout.fillWidth: true
                title: qsTr("Demo failure")
                message: qsTr("Simulated load error — Retry emits retryRequested.")
                onRetryRequested: toastsHint.text = qsTr("Retry requested")
            }
            Label {
                id: toastsHint
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                text: qsTr("Idle")
            }
        }
    }
}
