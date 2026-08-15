import QtQuick
import QWinUI3.Theme

// One case inside SwitchPresenter. Content is shown when value matches.
Item {
    id: root

    property var value
    property bool active: false
    default property alias contentData: host.data

    width: parent ? parent.width : implicitWidth
    height: (visible && opacity > 0.01) ? Math.max(host.childrenRect.height, implicitHeight) : 0
    implicitWidth: host.childrenRect.width
    implicitHeight: host.childrenRect.height
    visible: false
    opacity: 0
    clip: true
    Accessible.ignored: !active

    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }
    Behavior on height {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }

    onOpacityChanged: {
        if (opacity < 0.01 && !active)
            visible = false
    }

    Item {
        id: host
        anchors.fill: parent
        onChildrenChanged: {
            for (var i = 0; i < children.length; ++i) {
                var ch = children[i]
                if (!ch)
                    continue
                ch.anchors.left = host.left
                ch.anchors.right = host.right
                ch.anchors.top = host.top
            }
        }
    }
}
