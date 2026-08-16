import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Common pitfalls / anti-patterns.
//
// Side-by-side wrong vs right patterns for radius, clip, and progress fills.

Page {
    id: page
    padding: 0

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

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("Pitfalls")
                subtitle: qsTr("Anti-patterns that square rounded borders — see docs/conventions.md.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
                headerText: qsTr("clip: true does not round")
                qmlSource: "// clip: true is axis-aligned only\n// Keep animated bars inside bounds instead of rectangular clip"

                GridLayout {
                    Layout.fillWidth: true
                    columns: width > 640 ? 2 : 1
                    rowSpacing: Theme.spacingLoose
                    columnSpacing: Theme.spacingLoose

                    ColumnLayout {
                        Label {
                            text: qsTr("Wrong — clip squares the ends")
                            color: Theme.systemCritical
                            font.weight: Theme.fontWeightSemiBold
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
                            text: qsTr("Right — stay inside, keep radius")
                            color: Theme.systemSuccess
                            font.weight: Theme.fontWeightSemiBold
                        }
                        Rectangle {
                            id: goodTrack
                            Layout.fillWidth: true
                            height: 28
                            radius: height / 2
                            color: Theme.dark ? "#15FFFFFF" : "#0F000000"
                            Rectangle {
                                id: goodBar
                                width: Math.max(40, parent.width * 0.35)
                                height: parent.height
                                radius: height / 2
                                color: Theme.accent
                                SequentialAnimation on x {
                                    loops: Animation.Infinite
                                    running: page.visible
                                    NumberAnimation {
                                        from: 0
                                        to: Math.max(0, goodTrack.width - goodBar.width)
                                        duration: 1200
                                        easing.type: Easing.InOutCubic
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
