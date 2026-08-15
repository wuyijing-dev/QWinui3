import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// RefreshContainer — Pull-to-refresh host for flickable content.
//
//   RefreshContainer {
//       id: refresh
//       onRefreshRequested: {
//           load()
//           refresh.endRefresh()
//       }
//       ListView { model: items; /* … */ }
//   }
//   // --- API ---
//   // refresh.beginRefresh() / endRefresh()
//   // signals: onRefreshRequested

T.Control {
    id: root

    // Default children / content slot
    default property alias contentData: flick.data
    // Flickable content width
    property alias contentWidth: flick.contentWidth
    // Flickable content height
    property alias contentHeight: flick.contentHeight
    // Flickable content X
    property alias contentX: flick.contentX
    // Flickable content Y
    property alias contentY: flick.contentY
    // Inner Flickable
    property alias flickable: flick
    // True while a refresh is in progress
    property bool refreshing: false
    // True while refreshing
    property alias isRefreshing: root.refreshing
    // Enable pull-to-refresh gesture
    property bool pullToRefreshEnabled: true
    // Enabled state alias
    property alias isEnabled: root.pullToRefreshEnabled
    // Pull distance before refresh fires
    property real pullThreshold: 72
    // Text shown while pulling
    property string refreshText: qsTr("Release to refresh")
    // Text shown while refreshing
    property string refreshingText: qsTr("Refreshing…")
    // Pull-to-refresh prompt text
    property string pullText: qsTr("Pull to refresh")
    // Pull-to-refresh requested
    signal refreshRequested()

    implicitWidth: 320
    implicitHeight: 240
    clip: true
    Accessible.role: Accessible.ScrollBar
    Accessible.name: refreshing ? refreshingText : pullText
    Accessible.description: refreshing ? qsTr("Busy") : qsTr("Idle")

    readonly property real _pullDistance: Math.max(0, -flick.contentY - flick.originY)
    readonly property bool _armed: pullToRefreshEnabled && !refreshing && _pullDistance >= pullThreshold
    readonly property real _headerHeight: refreshing ? pullThreshold
            : (pullToRefreshEnabled ? Math.min(pullThreshold + 16, _pullDistance) : 0)
    readonly property real _pullProgress: Math.min(1, _pullDistance / Math.max(1, pullThreshold))

    // End a pull-to-refresh cycle
    function endRefresh() {
        refreshing = false
    }

    // Start a pull-to-refresh cycle
    function beginRefresh() {
        if (refreshing)
            return
        refreshing = true
        refreshRequested()
    }

    contentItem: Item {
        Flickable {
            id: flick
            anchors.fill: parent
            clip: true
            topMargin: root.refreshing ? root.pullThreshold : 0
            boundsBehavior: (!root.pullToRefreshEnabled || root.refreshing)
                            ? Flickable.StopAtBounds
                            : Flickable.DragOverBounds
            rebound: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            onDraggingChanged: {
                if (!root.pullToRefreshEnabled)
                    return
                if (!dragging && root._armed)
                    root.beginRefresh()
            }
        }

        Item {
            id: indicator
            z: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: root._headerHeight
            opacity: root.refreshing ? 1
                     : Math.min(1, root._pullDistance / Math.max(1, root.pullThreshold))
            visible: height > 8 || root.refreshing
            clip: true

            RowLayout {
                anchors.centerIn: parent
                spacing: Theme.spacing

                Item {
                    Layout.preferredWidth: 22
                    Layout.preferredHeight: 22

                    // Indeterminate spin angle
                    property real spinAngle: 0
                    NumberAnimation on spinAngle {
                        from: 0
                        to: 360
                        duration: 900
                        loops: Animation.Infinite
                        running: root.refreshing && !Theme.reducedMotion
                        easing.type: Easing.Linear
                    }

                    Text {
                        anchors.centerIn: parent
                        text: FluentIcons.Refresh
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 16
                        color: root._armed || root.refreshing ? Theme.accent : Theme.textSecondary
                        rotation: root.refreshing ? parent.spinAngle : (root._pullProgress * 180)
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                    }
                }

                ProgressRing {
                    visible: root.refreshing && Theme.reducedMotion
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    indeterminate: true
                }

                Text {
                    text: root.refreshing ? root.refreshingText
                         : (root._armed ? root.refreshText : root.pullText)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: root._armed || root.refreshing ? Theme.textPrimary : Theme.textSecondary
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                }
            }

            Behavior on height {
                enabled: root.refreshing && !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                }
            }
        }
    }

    onRefreshingChanged: {
        if (refreshing) {
            Qt.callLater(function () {
                flick.contentY = -flick.topMargin
            })
        } else if (!flick.dragging) {
            Qt.callLater(function () {
                flick.returnToBounds()
            })
        }
    }
}
