import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — EntranceThemeTransition.
//
// Recipe: docs/animations.md

CatalogPage {
    title: qsTr("EntranceThemeTransition")
    subtitle: qsTr("WinUI-style fade + rise + scale. Recipe: docs/animations.md — honors Theme.reducedMotion.")

    ControlExample {
        headerText: qsTr("Reduced motion")
        qmlSource: "Theme.reducedMotion // play() snaps to final pose"
        ColumnLayout {
            Layout.fillWidth: true
            Switch {
                text: qsTr("Theme.reducedMotion")
                checked: Theme.reducedMotion
                onToggled: Theme.reducedMotion = checked
            }
        }
    }

    ControlExample {
        headerText: qsTr("Play entrance")
        qmlSource: "EntranceThemeTransition {\n    anchors.fill: parent\n    Label { text: \"Hello\" }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            RowLayout {
                spacing: Theme.spacing
                AccentButton {
                    text: qsTr("Replay")
                    onClicked: entrance.play()
                }
                Button {
                    text: qsTr("Reset")
                    onClicked: entrance.reset()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                radius: Theme.cornerCard
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard
                clip: true

                EntranceThemeTransition {
                    id: entrance
                    anchors.fill: parent
                    anchors.margins: Theme.spacingLoose
                    autoPlay: true

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: FluentIcons.Completed
                            font: Theme.iconFontFor(32)
                            color: Theme.accent
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: qsTr("Content enters with Fluent motion")
                            color: Theme.textPrimary
                        }
                    }
                }
            }
        }
    }
}
