import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ProgressButton.
//
// Inline progress with percentage, Fluent state icons, and start()/setProgress()/complete()/fail(). API: docs/components/ProgressButton.md

CatalogPage {
    title: qsTr("ProgressButton")
    subtitle: qsTr("Inline progress with percentage, Fluent state icons, and start()/setProgress()/complete()/fail().")

    ControlExample {
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
                    text: qsTr("+10%")
                    onClicked: {
                        if (uploadBtn.progressState === "completed" || uploadBtn.progressState === "error")
                            uploadBtn.reset()
                        uploadBtn.setProgress(Math.min(1, uploadBtn.progress + 0.1))
                        slider.value = uploadBtn.progress
                    }
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
        headerText: qsTr("Indeterminate")
        qmlSource: "ProgressButton { start(true) }"
        ProgressButton {
            text: qsTr("Sync")
            progressingText: qsTr("Working…")
            Component.onCompleted: start(true)
        }
    }
}
