import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// FileDropZone — Drag-and-drop target with Fluent empty chrome.
//
//   FileDropZone {
//       title: qsTr("Drop files here")
//       acceptExtensions: [".png", ".jpg"]
//       acceptMimeTypes: ["image/png", "image/jpeg"]
//       onFilesDropped: (urls) => { … }
//   }
//
//   // --- API ---
//   // signals: onFilesDropped(var urls), onEntered, onExited
//   // properties: title, subtitle, symbol, acceptExtensions, acceptMimeTypes, isActive
//
// @notes
//   DropArea wrapper with dashed ElevatedChrome. acceptExtensions filters by
//   lowercase suffix; acceptMimeTypes (2.13) filters drag MIME when reported.
//   Empty acceptExtensions = accept all URLs; pair both filters in production.

T.Control {
    id: root

    Layout.fillWidth: true

    property string title: qsTr("Drop files here")
    property string subtitle: qsTr("Or click to browse when a FilePicker is wired by the host.")
    property var symbol: FluentIcons.OpenFile
    property var acceptExtensions: []
    property var acceptMimeTypes: []
    property bool isActive: drop.containsDrag
    property bool isDragRejected: false
    property real cornerRadius: Theme.cornerCard

    signal filesDropped(var urls)
    signal entered()
    signal exited()
    signal dragRejected()

    implicitWidth: 360
    implicitHeight: 160
    Accessible.role: Accessible.Pane
    Accessible.name: title
    Accessible.description: subtitle

    readonly property var _dropKeys: {
        var k = ["text/uri-list"]
        if (acceptMimeTypes && acceptMimeTypes.length) {
            for (var i = 0; i < acceptMimeTypes.length; ++i)
                k.push(String(acceptMimeTypes[i]))
        }
        return k
    }

    function _mimeMatches(formats) {
        if (!acceptMimeTypes || acceptMimeTypes.length === 0)
            return true
        if (!formats || formats.length === 0)
            return false
        var onlyUriList = formats.length === 1
            && String(formats[0]).toLowerCase() === "text/uri-list"
        if (onlyUriList)
            return true
        for (var i = 0; i < formats.length; ++i) {
            var f = String(formats[i]).toLowerCase()
            for (var j = 0; j < acceptMimeTypes.length; ++j) {
                var m = String(acceptMimeTypes[j]).toLowerCase()
                if (f === m)
                    return true
                if (m.endsWith("/*")) {
                    var prefix = m.slice(0, -1)
                    if (f.startsWith(prefix))
                        return true
                }
            }
        }
        return false
    }

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
        border.width: root.isDragRejected ? 2 : 1
        border.color: root.isDragRejected ? Theme.systemCritical
                      : (root.isActive ? Theme.accent : Theme.strokeCard)

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
            keys: root._dropKeys
            onEntered: function (drag) {
                if (!root._mimeMatches(drag.formats)) {
                    drag.accepted = false
                    root.isDragRejected = true
                    root.dragRejected()
                    return
                }
                root.isDragRejected = false
                root.entered()
            }
            onExited: {
                root.isDragRejected = false
                root.exited()
            }
            onDropped: function (event) {
                if (!event.hasUrls)
                    return
                if (!root._mimeMatches(event.formats))
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
