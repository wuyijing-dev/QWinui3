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
        qmlSource: "Frame {\n    Label { text: \"Inside a Frame\" }\n}"
        Frame {
            Layout.maximumWidth: 420
            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacing
                Label {
                    text: qsTr("Inside a Frame")
                    font.weight: Theme.fontWeightSemiBold
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
