import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// FileDropZone — Drag-and-drop target with Fluent empty chrome.
//
//   FileDropZone {
//       title: qsTr("Drop files here")
//       onFilesDropped: (urls) => { … }
//   }
//
//   // --- API ---
//   // signals: onFilesDropped(var urls), onEntered, onExited
//   // properties: title, subtitle, symbol, acceptExtensions, isActive
//
// @notes
//   DropArea wrapper with dashed ElevatedChrome. acceptExtensions filters by
//   lowercase suffix (e.g. [".png", ".jpg"]); empty accepts all URLs.

T.Control {
    id: root

    Layout.fillWidth: true

    property string title: qsTr("Drop files here")
    property string subtitle: qsTr("Or click to browse when a FilePicker is wired by the host.")
    property var symbol: FluentIcons.OpenFile
    property var acceptExtensions: []
    property bool isActive: drop.containsDrag
    property real cornerRadius: Theme.cornerCard

    signal filesDropped(var urls)
    signal entered()
    signal exited()

    implicitWidth: 360
    implicitHeight: 160
    Accessible.role: Accessible.Pane
    Accessible.name: title
    Accessible.description: subtitle

    function _accepts(url) {
        if (!acceptExtensions || acceptExtensions.length === 0)
            return true
        var s = String(url).toLowerCase()
        for (var i = 0; i < acceptExtensions.length; ++i) {
            var ext = String(acceptExtensions[i]).toLowerCase()
            if (s.endsWith(ext))
                return true
        }
        return false
    }

    function _filter(urls) {
        var out = []
        for (var i = 0; i < urls.length; ++i) {
            if (_accepts(urls[i]))
                out.push(urls[i])
        }
        return out
    }

    background: Rectangle {
        radius: root.cornerRadius
        color: root.isActive ? Theme.fillSubtleSecondary : Theme.fillSubtle
        border.width: 1
        border.color: root.isActive ? Theme.accent : Theme.strokeCard

        // Dashed feel via overlay ticks (simple Fluent affordance)
        Rectangle {
            anchors.fill: parent
            anchors.margins: 6
            radius: Math.max(0, root.cornerRadius - 4)
            color: "transparent"
            border.width: 1
            border.color: root.isActive ? Theme.accent : Theme.strokeControl
            opacity: 0.55
        }

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }

    contentItem: Item {
        DropArea {
            id: drop
            anchors.fill: parent
            keys: ["text/uri-list"]
            onEntered: root.entered()
            onExited: root.exited()
            onDropped: function (event) {
                if (!event.hasUrls)
                    return
                var urls = root._filter(event.urls)
                if (urls.length) {
                    event.acceptProposedAction()
                    root.filesDropped(urls)
                }
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Theme.spacing
            width: parent.width - 32

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: IconSource.resolve(root.symbol, "")
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 28
                color: root.isActive ? Theme.accent : Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                wrapMode: Text.Wrap
            }
            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: root.subtitle
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.Wrap
            }
        }
    }
}
