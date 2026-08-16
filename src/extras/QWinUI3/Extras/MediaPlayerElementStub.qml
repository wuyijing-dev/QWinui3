import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// MediaPlayerElement — Stub when Qt Multimedia is not linked (1.21).
//
//   MediaPlayerElement {
//       // available === false — show EmptyState in apps
//   }
//
// @notes
//   CMake registers this file as type MediaPlayerElement when Multimedia is
//   missing. Real player: MediaPlayerElement.qml. Recipe: docs/media.md.
//   @internal

T.Control {
    id: root

    readonly property bool available: false
    property url source
    property real volume: 0.85
    property bool muted: false
    property bool autoPlay: false
    property bool showControls: true
    property string accessibleName: qsTr("Media player")

    readonly property bool playing: false
    readonly property real duration: 0
    readonly property real position: 0
    readonly property int mediaStatus: 0
    readonly property string errorString: qsTr("Qt Multimedia was not enabled in this build.")

    implicitWidth: 480
    implicitHeight: 220
    padding: Theme.spacingSection
    Accessible.role: Accessible.Grouping
    Accessible.name: accessibleName
    Accessible.description: errorString

    function play() {}
    function pause() {}
    function stop() {}
    function togglePlayPause() {}

    background: Rectangle {
        radius: Theme.cornerCard
        color: Theme.bgCard
        border.width: 1
        border.color: Theme.strokeCard
    }

    contentItem: EmptyState {
        title: qsTr("Qt Multimedia not available")
        message: qsTr("Rebuild with Qt Multimedia installed and QWINUI3_BUILD_MEDIA=ON. See docs/media.md.")
        compact: true
        bordered: false
    }
}
