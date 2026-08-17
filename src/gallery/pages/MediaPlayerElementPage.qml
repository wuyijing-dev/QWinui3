import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — MediaPlayerElement (1.21 / 1.67 defer). Recipe: docs/media.md
// Soft-loads the Extras type so missing Multimedia never crashes the page.

CatalogPage {
    id: page

    title: qsTr("MediaPlayerElement")
    subtitle: qsTr("Optional Qt Multimedia — deferred 1.67. Recipe: docs/media.md")

    property url mediaSource: ""
    property bool mediaReady: playerLoader.status === Loader.Ready
                              && playerLoader.item
                              && playerLoader.item.available !== false
    property bool mediaStub: playerLoader.status === Loader.Ready
                             && playerLoader.item
                             && playerLoader.item.available === false
    property string mediaError: {
        if (mediaComponent && mediaComponent.status === Component.Error)
            return mediaComponent.errorString()
        if (playerLoader.status === Loader.Error)
            return qsTr("Failed to create MediaPlayerElement.")
        if (mediaStub && playerLoader.item && playerLoader.item.errorString)
            return playerLoader.item.errorString
        return ""
    }

    // Resolve from Extras so missing QtMultimedia fails softly (no hard page crash).
    property var mediaComponent: Qt.createComponent("QWinUI3.Extras", "MediaPlayerElement")

    Component.onCompleted: {
        if (mediaComponent.status === Component.Ready)
            playerLoader.sourceComponent = mediaComponent
        else if (mediaComponent.status === Component.Error)
            console.warn("MediaPlayerElement:", mediaComponent.errorString())
        else
            mediaComponent.statusChanged.connect(function () {
                if (mediaComponent.status === Component.Ready)
                    playerLoader.sourceComponent = mediaComponent
                else if (mediaComponent.status === Component.Error)
                    console.warn("MediaPlayerElement:", mediaComponent.errorString())
            })
    }

    ControlExample {
        headerText: qsTr("Deferred for remaining 1.xx (1.67)")
        qmlSource: "// Not freeze-covered — docs/media.md\n// Stub when Qt Multimedia is missing"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Honest defer: codecs, GPU backends, and Multimedia deploy differ by OS/kit. The type still ships (real player or available === false stub). Product shells that must stay on stable-api should not depend on it. No new codecs or streaming in 1.67.")
            }
            CheckBox { text: qsTr("Treat MediaPlayerElement as experimental (not freeze-covered)") }
            CheckBox { text: qsTr("Gate UI on available === false / EmptyState") }
            CheckBox { text: qsTr("Deploy Multimedia QML plugins yourself (not in the kit zip)") }
            CheckBox { text: qsTr("Pause when the host is not visible") }
        }
    }

    ControlExample {
        headerText: qsTr("Player")
        qmlSource: "MediaPlayerElement {\n    source: \"file:///…\"\n    // Space toggles play\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            EmptyState {
                Layout.fillWidth: true
                visible: !page.mediaReady
                title: page.mediaStub
                       ? qsTr("Qt Multimedia not in this build")
                       : qsTr("Qt Multimedia not loaded")
                message: page.mediaError.length
                         ? page.mediaError
                         : qsTr("Install Qt Multimedia, configure -DQWINUI3_BUILD_MEDIA=ON, and ensure the Multimedia QML plugin is deployable (windeployqt / qt.conf). See docs/media.md.")
                actionText: qsTr("Open media docs")
                compact: true
                bordered: true
                onActionClicked: Qt.openUrlExternally("https://github.com/wuyijing-dev/QWinui3/blob/master/docs/media.md")
            }

            RowLayout {
                visible: page.mediaReady
                Button {
                    text: qsTr("Open media…")
                    highlighted: true
                    onClicked: FilePicker.openFile(
                        qsTr("Open media"),
                        ["Media (*.mp4 *.mkv *.webm *.mp3 *.wav)", "All (*.*)"],
                        function (p) {
                            if (p && p.length)
                                page.mediaSource = p.indexOf("file:") === 0 ? p : ("file:///" + p.replace(/\\/g, "/"))
                        })
                }
                Label {
                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                    text: page.mediaSource.toString() || qsTr("No file selected — Space toggles play when focused")
                    color: Theme.textSecondary
                }
            }

            Loader {
                id: playerLoader
                Layout.fillWidth: true
                Layout.preferredHeight: page.mediaReady ? 360 : (page.mediaStub ? 220 : 0)
                visible: page.mediaReady || page.mediaStub
                onLoaded: {
                    if (item && item.available !== false) {
                        item.Layout.fillWidth = true
                        if (page.mediaSource.toString().length)
                            item.source = page.mediaSource
                        item.autoPlay = true
                    }
                }
            }

            Binding {
                target: playerLoader.item
                property: "source"
                value: page.mediaSource
                when: playerLoader.item !== null && playerLoader.item.available !== false
            }

            Connections {
                target: page
                function onVisibleChanged() {
                    if (!page.visible && playerLoader.item && playerLoader.item.available !== false)
                        playerLoader.item.pause()
                }
            }
        }
    }
}
