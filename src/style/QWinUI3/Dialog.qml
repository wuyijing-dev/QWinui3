import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Dialog {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitHeaderWidth, implicitFooterWidth)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))

    padding: 24
    topPadding: 8
    bottomPadding: 8
    spacing: 8
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: Theme.duration(Theme.motionFast)
        }
        NumberAnimation {
            property: "scale"
            from: control.modal ? 1.05 : 1; to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1; to: 0
            duration: Theme.duration(Theme.motionFast)
        }
        NumberAnimation {
            property: "scale"
            from: 1; to: control.modal ? 1.05 : 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingExit
        }
    }

    background: Rectangle {
        radius: Theme.cornerOverlay
        color: Theme.bgCard
        border.width: 1
        border.color: Theme.strokeCard

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: 0.22
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 8
            shadowBlur: 1.0
            blurMax: 32
        }
    }

    header: T.Label {
        text: control.title
        visible: control.title.length > 0
        elide: Text.ElideRight
        font.pixelSize: Theme.fontSubtitle
        font.weight: Theme.fontWeightSemiBold
        font.family: Theme.fontFamily
        color: Theme.textPrimary
        padding: control.padding
        topPadding: control.padding
        bottomPadding: 0
    }

    footer: DialogButtonBox {
        visible: count > 0
        alignment: Qt.AlignRight
    }

    T.Overlay.modal: Rectangle {
        color: Theme.bgSmoke
        Behavior on opacity {
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
