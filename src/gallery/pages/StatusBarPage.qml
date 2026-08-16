import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — StatusBar.
//
// Window status strip with progress and leading/trailing slots.

Page {
    padding: 0

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ScrollView {
            id: scroll
            Layout.fillWidth: true
            Layout.fillHeight: true
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
                    title: qsTr("StatusBar")
                    subtitle: qsTr("Bottom status strip with text, progress, and content slots.")
                }

                ControlExample {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.spacingSection
                    Layout.rightMargin: Theme.spacingSection
                    Layout.bottomMargin: Theme.spacingSection
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
                                font.family: Theme.fontFamily
                            }
                        }
                    }
                }
            }
        }

        StatusBar {
            id: demoBar
            Layout.fillWidth: true
            text: qsTr("Ready")
            leftContent: Text {
                text: FluentIcons.Sync
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 12
                color: Theme.textSecondary
                verticalAlignment: Text.AlignVCenter
            }
            rightContent: Text {
                text: Qt.formatTime(new Date(), "hh:mm")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
