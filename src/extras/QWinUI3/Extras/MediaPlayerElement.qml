import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QtMultimedia
import QWinUI3.Theme

// MediaPlayerElement — Fluent shell around Qt Multimedia MediaPlayer / VideoOutput.
//
//   MediaPlayerElement {
//       source: "file:///C:/video.mp4"
//       Layout.fillWidth: true
//       Layout.preferredHeight: 320
//   }
//   // --- API ---
//   // methods: play(), pause(), stop(), togglePlayPause()
//   // media.play() / media.pause() / media.stop()
//
// @notes
//   Optional Qt Multimedia — build with -DQWINUI3_BUILD_MEDIA=ON (default when Multimedia
//   is found). When Multimedia is absent, Extras ships a stub with available === false.
//   Recipe: docs/media.md (1.21). Permanent defer 2.09 — experimental (codecs / backends / deploy app-owned).
//   Keyboard: Space / Enter toggles play; focusable transport chrome.

T.Control {
    id: root

    // Always true in the Multimedia build (stub sets false).
    readonly property bool available: true
    // Media URL
    property alias source: player.source
    // Playback volume 0..1
    property alias volume: audio.volume
    // Mute flag
    property alias muted: audio.muted
    // Auto-play when source is set
    property bool autoPlay: false
    // Show transport chrome
    property bool showControls: true
    // Screen-reader name override
    property string accessibleName: qsTr("Media player")

    readonly property bool playing: player.playbackState === MediaPlayer.PlayingState
    readonly property real duration: player.duration
    readonly property real position: player.position
    readonly property int mediaStatus: player.mediaStatus
    readonly property string errorString: player.errorString

    implicitWidth: 480
    implicitHeight: 300
    padding: 0
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.Grouping
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Media player")
    Accessible.description: playing ? qsTr("Playing") : qsTr("Paused")

    Keys.onSpacePressed: function (event) {
        togglePlayPause()
        event.accepted = true
    }
    Keys.onReturnPressed: function (event) {
        togglePlayPause()
        event.accepted = true
    }
    Keys.onEnterPressed: function (event) {
        togglePlayPause()
        event.accepted = true
    }

    function play() { player.play() }
    function pause() { player.pause() }
    function stop() { player.stop() }
    function togglePlayPause() {
        if (playing)
            pause()
        else
            play()
    }

    MediaPlayer {
        id: player
        audioOutput: AudioOutput { id: audio; volume: 0.85 }
        videoOutput: video
        onSourceChanged: {
            if (root.autoPlay && source.toString().length)
                play()
        }
    }

    background: Rectangle {
        radius: Theme.cornerCard
        color: "#FF121212"
        border.width: Theme.highContrast ? 2 : 1
        border.color: Theme.strokeCard
    }

    contentItem: ColumnLayout {
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            VideoOutput {
                id: video
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectFit
            }
            Text {
                anchors.centerIn: parent
                visible: !root.source || root.source.toString().length === 0
                text: qsTr("No media")
                color: "#CCFFFFFF"
                font.pixelSize: Theme.fontBody
            }
            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: Theme.spacing
                visible: root.errorString.length > 0
                wrapMode: Text.WordWrap
                text: root.errorString
                color: Theme.systemCritical
                font.pixelSize: Theme.fontCaption
            }
        }

        Rectangle {
            visible: root.showControls
            Layout.fillWidth: true
            height: Theme.controlHeight + 16
            color: Theme.bgCard
            opacity: 0.96
            bottomLeftRadius: Theme.cornerCard
            bottomRightRadius: Theme.cornerCard

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: Theme.spacing

                ToolButton {
                    text: root.playing ? FluentIcons.Pause : FluentIcons.Play
                    font: Theme.iconFontFor(14)
                    onClicked: root.togglePlayPause()
                    Accessible.name: root.playing ? qsTr("Pause") : qsTr("Play")
                    ToolTip.visible: hovered
                    ToolTip.text: Accessible.name
                }
                ToolButton {
                    text: FluentIcons.Stop
                    font: Theme.iconFontFor(14)
                    onClicked: root.stop()
                    Accessible.name: qsTr("Stop")
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Stop")
                }
                ToolButton {
                    text: audio.muted ? FluentIcons.Mute : FluentIcons.Volume
                    font: Theme.iconFontFor(14)
                    onClicked: audio.muted = !audio.muted
                    Accessible.name: audio.muted ? qsTr("Unmute") : qsTr("Mute")
                    ToolTip.visible: hovered
                    ToolTip.text: Accessible.name
                }
                Slider {
                    id: seek
                    Layout.fillWidth: true
                    from: 0
                    to: Math.max(1, player.duration)
                    value: player.position
                    onMoved: player.position = value
                    Accessible.name: qsTr("Seek")
                }
                Text {
                    text: {
                        function fmt(ms) {
                            var s = Math.floor(ms / 1000)
                            var m = Math.floor(s / 60)
                            s = s % 60
                            return m + ":" + (s < 10 ? "0" : "") + s
                        }
                        return fmt(player.position) + " / " + fmt(player.duration)
                    }
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    Accessible.ignored: true
                }
                Slider {
                    Layout.preferredWidth: 80
                    from: 0
                    to: 1
                    value: audio.volume
                    onMoved: audio.volume = value
                    Accessible.name: qsTr("Volume")
                }
            }
        }
    }
}
