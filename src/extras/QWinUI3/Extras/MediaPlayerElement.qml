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
//   Requires Qt Multimedia (build with -DQWINUI3_BUILD_MEDIA=ON).
//   Exposes source, muted, volume, position helpers and transport buttons.

T.Control {
    id: root

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

    readonly property bool playing: player.playbackState === MediaPlayer.PlayingState
    readonly property real duration: player.duration
    readonly property real position: player.position

    implicitWidth: 480
    implicitHeight: 300
    padding: 0
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Media player")

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
        color: Theme.dark ? "#FF000000" : "#FF1A1A1A"
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
                color: "#AAFFFFFF"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
            }
        }

        Rectangle {
            visible: root.showControls
            Layout.fillWidth: true
            height: Theme.controlHeight + 16
            color: Theme.dark ? "#CC202020" : "#E6F3F3F3"
            bottomLeftRadius: Theme.cornerCard
            bottomRightRadius: Theme.cornerCard

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: Theme.spacing

                Button {
                    flat: true
                    text: root.playing ? "\uE769" : "\uE768"
                    font.family: Theme.fontFamilyIcon
                    onClicked: root.togglePlayPause()
                    Accessible.name: root.playing ? qsTr("Pause") : qsTr("Play")
                }
                Button {
                    flat: true
                    text: "\uE71A"
                    font.family: Theme.fontFamilyIcon
                    onClicked: root.stop()
                    Accessible.name: qsTr("Stop")
                }
                Slider {
                    id: seek
                    Layout.fillWidth: true
                    from: 0
                    to: Math.max(1, player.duration)
                    value: player.position
                    onMoved: player.position = value
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
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
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
