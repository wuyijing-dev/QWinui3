import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — MediaPlayerElement (1.21 / permanent defer 2.09). Recipe: docs/media.md
// Soft-loads the Extras type so missing Multimedia never crashes the page.

CatalogPage {
    id: page

    title: qsTr("MediaPlayerElement")
    subtitle: qsTr("Optional Qt Multimedia — permanently deferred (2.09). Field matrix (2.32): docs/media.md")

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
        headerText: qsTr("Field matrix (2.32)")
        qmlSource: "// docs/media.md — Field matrix (2.32)\n// windeployqt Multimedia plugins · available === false"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("2.x floor: stub when Multimedia missing at configure; real player when BUILD_MEDIA=ON + plugins deployed. Smoke compiles this page — no decode gate. Pause when hidden; gate on available === false.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Verdict — permanent defer (2.09)")
        qmlSource: "// Not stable-api — docs/media.md\n// Stub when Qt Multimedia is missing"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("2.09 closes the 1.67 promote loop: keep shipping as experimental, do not promote. Codecs, GPU backends, and Multimedia plugin deploy differ by OS and are app-owned — not a kit contract. Product shells on stable-api should not require this type.")
            }
            CheckBox { text: qsTr("Treat MediaPlayerElement as experimental (permanent defer 2.09)") }
            CheckBox { text: qsTr("Gate UI on available === false → EmptyState") }
            CheckBox { text: qsTr("windeployqt / installer ships Multimedia plugins (not in kit zip)") }
            CheckBox { text: qsTr("Pause when the host is not visible") }
        }
    }

    ControlExample {
        headerText: qsTr("Player demo")
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
                         : qsTr("Install Qt Multimedia, configure -DQWINUI3_BUILD_MEDIA=ON, and deploy the Multimedia QML plugin (windeployqt / qt.conf). See docs/media.md.")
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
