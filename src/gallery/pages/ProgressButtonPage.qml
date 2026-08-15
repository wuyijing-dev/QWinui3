import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
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
                title: qsTr("ProgressButton")
                subtitle: qsTr("Inline progress with start()/complete()/fail() and state labels.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Determinate")
                qmlSource: "ProgressButton {\n    progressingText: \"Uploading…\"\n    completedText: \"Done\"\n}"
                ColumnLayout {
                    spacing: Theme.spacingLoose
                    ProgressButton {
                        id: uploadBtn
                        text: qsTr("Upload")
                        progressingText: qsTr("Uploading… %1%").arg(Math.round(uploadBtn.progress * 100))
                        completedText: qsTr("Uploaded")
                        errorText: qsTr("Failed")
                        progress: slider.value
                    }
                    Slider {
                        id: slider
                        Layout.fillWidth: true
                        from: 0
                        to: 1
                        value: 0.45
                        onMoved: {
                            if (uploadBtn.progressState === "completed" || uploadBtn.progressState === "error")
                                uploadBtn.reset()
                        }
                    }
                    RowLayout {
                        Button {
                            text: qsTr("Start")
                            onClicked: { slider.value = 0.1; uploadBtn.start() }
                        }
                        Button {
                            text: qsTr("Complete")
                            onClicked: { slider.value = 1; uploadBtn.complete() }
                        }
                        Button {
                            text: qsTr("Reset")
                            onClicked: { slider.value = 0; uploadBtn.reset() }
                        }
                        Button {
                            text: qsTr("Fail")
                            onClicked: uploadBtn.fail()
                        }
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Indeterminate")
                qmlSource: "ProgressButton { start(true) }"
                ProgressButton {
                    text: qsTr("Sync")
                    progressingText: qsTr("Working…")
                    Component.onCompleted: start(true)
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
