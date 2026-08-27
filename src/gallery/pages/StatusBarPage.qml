import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — StatusBar.

CatalogPage {
    title: qsTr("StatusBar")
    subtitle: qsTr("Bottom status strip with text, progress, and content slots.")

    ControlExample {
        headerText: qsTr("Interactive demo")
        qmlSource: "StatusBar {\n    text: qsTr(\"Ready\")\n    progress: 0.4\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Ready")
                    onClicked: {
                        demoBar.text = qsTr("Ready")
                        demoBar.progress = -1
                        demoBar.progressIndeterminate = false
                    }
                }
                Button {
                    text: qsTr("Determinate")
                    onClicked: {
                        demoBar.text = qsTr("Downloading…")
                        demoBar.progressIndeterminate = false
                        demoBar.progress = 0.35
                    }
                }
                Button {
                    text: qsTr("Indeterminate")
                    onClicked: {
                        demoBar.text = qsTr("Working…")
                        demoBar.progressIndeterminate = true
                        demoBar.progress = 0
                    }
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: Math.max(0, demoBar.progress)
                    onMoved: {
                        demoBar.progressIndeterminate = false
                        demoBar.progress = value
                        demoBar.text = qsTr("Progress %1%").arg(Math.round(value * 100))
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                radius: Theme.cornerCard
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard
                Text {
                    anchors.centerIn: parent
                    text: qsTr("App content area")
                    color: Theme.textSecondary
                }
            }
        }
    }

    footer: StatusBar {
        id: demoBar
        text: qsTr("Ready")
        leftContent: Text {
            text: FluentIcons.Sync
            font: Theme.iconFontFor(12)
            color: Theme.textSecondary
            verticalAlignment: Text.AlignVCenter
        }
        rightContent: Text {
            text: Qt.formatTime(new Date(), "hh:mm")
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            verticalAlignment: Text.AlignVCenter
        }
    }
}
