import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — MediaPlayerElement (requires Qt Multimedia QML module at runtime).

CatalogPage {
    id: page

    title: qsTr("MediaPlayerElement")
    subtitle: qsTr("Fluent transport shell over Qt Multimedia. Pick a local file to play.")

    property url mediaSource: ""
    property bool mediaReady: playerLoader.status === Loader.Ready
    property string mediaError: {
        if (mediaComponent && mediaComponent.status === Component.Error)
            return mediaComponent.errorString()
        if (playerLoader.status === Loader.Error)
            return qsTr("Failed to create MediaPlayerElement.")
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
        headerText: qsTr("Player")
        qmlSource: "MediaPlayerElement {\n    source: \"file:///…\"\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            EmptyState {
                Layout.fillWidth: true
                visible: !page.mediaReady
                title: qsTr("Qt Multimedia not loaded")
                message: page.mediaError.length
                         ? page.mediaError
                         : qsTr("Ensure qt.conf QmlImports includes the Qt kit qml folder, or run build.bat (windeployqt).")
                compact: true
                bordered: true
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
                    text: page.mediaSource.toString() || qsTr("No file selected")
                    color: Theme.textSecondary
                }
            }

            Loader {
                id: playerLoader
                Layout.fillWidth: true
                Layout.preferredHeight: page.mediaReady ? 360 : 0
                visible: page.mediaReady
                onLoaded: {
                    if (item) {
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
                when: playerLoader.item !== null
            }
        }
    }
}
