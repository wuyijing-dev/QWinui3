import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI RefreshContainer: pull the scroll content to request a refresh.
// While refreshing, topMargin keeps the list shifted down so the indicator sits above it.
T.Control {
    id: root

    default property alias contentData: flick.data
    property alias contentWidth: flick.contentWidth
    property alias contentHeight: flick.contentHeight
    property alias contentX: flick.contentX
    property alias contentY: flick.contentY
    property alias flickable: flick
    property bool refreshing: false
    property bool pullToRefreshEnabled: true
    property alias isEnabled: root.pullToRefreshEnabled
    property real pullThreshold: 72
    property string refreshText: qsTr("Release to refresh")
    property string refreshingText: qsTr("Refreshing…")
    property string pullText: qsTr("Pull to refresh")
    signal refreshRequested()

    implicitWidth: 320
    implicitHeight: 240
    clip: true

    readonly property real _pullDistance: Math.max(0, -flick.contentY - flick.originY)
    readonly property bool _armed: pullToRefreshEnabled && !refreshing && _pullDistance >= pullThreshold
    readonly property real _headerHeight: refreshing ? pullThreshold
            : (pullToRefreshEnabled ? Math.min(pullThreshold + 16, _pullDistance) : 0)

    function endRefresh() {
        refreshing = false
    }

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
            // Reserve header space while refreshing so content stays shifted down.
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

        // Viewport-fixed header: sits in the margin / overscroll gap above the content.
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

                BusyIndicator {
                    Layout.preferredWidth: 22
                    Layout.preferredHeight: 22
                    running: root.refreshing || root._pullDistance > 12
                }

                Text {
                    text: root.refreshing ? root.refreshingText
                         : (root._armed ? root.refreshText : root.pullText)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
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
            // Pin content under the header (valid once topMargin is applied).
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
