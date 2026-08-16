import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Frame.

CatalogPage {
    title: qsTr("Frame")
    subtitle: qsTr("A simple styled container with padding and a surface fill.")

    ControlExample {
        headerText: qsTr("Content frame")
        qmlSource: "Frame {\n    ColumnLayout {\n        Label { text: \"Inside a Frame\" }\n    }\n}"

        Frame {
            id: demoFrame
            Layout.fillWidth: true
            Layout.maximumWidth: 420

            // Do not anchors.fill the Frame — that collapses height when the Frame
            // is sized from its content (implicitHeight). Size to availableWidth instead.
            ColumnLayout {
                width: demoFrame.availableWidth
                spacing: Theme.spacing

                Label {
                    text: qsTr("Inside a Frame")
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    Layout.fillWidth: true
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: qsTr("Use Frame to group related content with a subtle surface background.")
                    color: Theme.textSecondary
                }
                Button {
                    text: qsTr("Action")
                }
            }
        }
    }
}
