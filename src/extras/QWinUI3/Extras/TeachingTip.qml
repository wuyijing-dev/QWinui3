import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TeachingTip — Anchored tip with title, subtitle, content, and actions.
//
//   TeachingTip {
//       id: tip
//       target: btn
//       title: qsTr("Tip")
//       subtitle: qsTr("Hint")
//       actionText: qsTr("Got it")
//       preferredPlacement: Qt.AlignTop
//       tailVisibility: true
//       onActionClicked: tip.close()
//   }
//
//   // --- API ---
//   // tip.open() / tip.close() / tip.reanchor()
//   // signals: onActionClicked, onClosedByUser, onCloseButtonClicked
//   // inherits Popup
//
// @notes
//   WinUI TeachingTip: target, title/subtitle, Content + HeroContent, ActionButton (actionText),
//   CloseButton, PreferredPlacement, TailVisibility, PlacementMargin, IsLightDismissEnabled.
//   Parents to Window Overlay on open so placement is relative to the window, not a layout cell.
//   Coach-mark / first-run tip — not for confirmations (use ContentDialog; docs/dialogs-flyouts.md).
//   On close, focus returns to target when focusable (docs/feedback.md, 1.34).

T.Popup {
    id: root

    // Anchor item for placement
    property Item target: null
    // Primary title text
    property string title: ""
    // Secondary subtitle text
    property string subtitle: ""
    // Optional action button label (WinUI ActionButtonContent as text)
    property string actionText: ""
    // WinUI ActionButton — custom action control (replaces AccentButton when set)
    property alias actionButton: actionButtonSlot.data
    // WinUI CloseButtonContent — empty uses ChromeClose glyph
    property string closeButtonContent: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Open / visible state
    property bool isOpen: false
    // Close on outside click / Esc
    property bool isLightDismissEnabled: true
    // Show the close affordance
    property bool isCloseButtonVisible: true
    // Preferred flyout placement (Qt.AlignTop/Bottom/Left/Right)
    property int preferredPlacement: Qt.AlignTop
    // Resolved flyout placement
    property int effectivePlacement: Qt.AlignTop
    // Gap between target and tip (WinUI PlacementMargin)
    property real placementMargin: 12
    // Show the pointer tail (WinUI TailVisibility)
    property bool tailVisibility: true
    // WinUI ShouldConstrainToRootBounds — clamp tip inside parent when true
    property bool shouldConstrainToRootBounds: true
    // Hero content slot (above title)
    property alias heroContent: heroSlot.data
    // WinUI Content — body below subtitle
    default property alias content: bodySlot.data
    // Emitted when action is clicked
    signal actionClicked()
    // True when the user dismissed the dialog
    signal closedByUser()
    // Close button clicked (before dismiss)
    signal closeButtonClicked()

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    padding: 12
    modal: false
    closePolicy: isLightDismissEnabled
                 ? (T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside)
                 : T.Popup.CloseOnEscape
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    width: 320
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    onIsOpenChanged: {
        if (isOpen) {
            _ensureOverlayParent()
            reanchor()
            open()
        } else {
            close()
        }
    }
    onOpened: {
        isOpen = true
        reanchor()
        if (isCloseButtonVisible)
            closeBtn.forceActiveFocus()
    }
    onClosed: {
        isOpen = false
        // Return focus to the anchor so coach marks do not leave focus nowhere (1.34).
        if (target && target.visible && typeof target.forceActiveFocus === "function")
            Qt.callLater(function () {
                if (target && target.visible)
                    target.forceActiveFocus()
            })
    }

    // Prefer the window overlay so map/clamp use full window bounds (not a tiny layout parent).
    function _ensureOverlayParent() {
        var anchor = target ? target : root
        var win = anchor.Window ? anchor.Window.window : null
        var overlay = (win && win.Overlay && win.Overlay.overlay) ? win.Overlay.overlay : null
        if (!overlay && typeof Overlay !== "undefined")
            overlay = Overlay.overlay
        if (overlay)
            parent = overlay
    }

    // Recompute popup anchor
    function reanchor() {
        _ensureOverlayParent()
        if (!target || !parent)
            return
        var p = target.mapToItem(parent, 0, 0)
        var gap = root.placementMargin
        var w = width > 0 ? width : 320
        var h = height > 0 ? height : implicitHeight
        var place = preferredPlacement
        if (place === Qt.AlignTop || place === 0) {
            if (p.y - h - gap < 8)
                place = Qt.AlignBottom
            else
                place = Qt.AlignTop
        } else if (place === Qt.AlignBottom) {
            if (p.y + target.height + gap + h > parent.height - 8)
                place = Qt.AlignTop
        } else if (place === Qt.AlignLeft) {
            if (p.x - w - gap < 8)
                place = Qt.AlignRight
        } else if (place === Qt.AlignRight) {
            if (p.x + target.width + gap + w > parent.width - 8)
                place = Qt.AlignLeft
        }
        effectivePlacement = place

        switch (place) {
        case Qt.AlignBottom:
            transformOrigin = Item.Top
            x = p.x + (target.width - w) / 2
            y = p.y + target.height + gap
            break
        case Qt.AlignLeft:
            transformOrigin = Item.Right
            x = p.x - w - gap
            y = p.y + (target.height - h) / 2
            break
        case Qt.AlignRight:
            transformOrigin = Item.Left
            x = p.x + target.width + gap
            y = p.y + (target.height - h) / 2
            break
        default:
            transformOrigin = Item.Bottom
            x = p.x + (target.width - w) / 2
            y = p.y - h - gap
            break
        }
        if (shouldConstrainToRootBounds) {
            x = Math.max(8, Math.min(x, parent.width - w - 8))
            y = Math.max(8, Math.min(y, parent.height - h - 8))
        }
    }

    x: 0
    y: 0

    contentItem: ColumnLayout {
        spacing: 8
        Accessible.role: Accessible.Dialog
        Accessible.name: root.title.length ? root.title : qsTr("Tip")
        Accessible.description: root.subtitle

        Item {
            id: heroSlot
            visible: children.length > 0
            Layout.fillWidth: true
            Layout.preferredHeight: children.length > 0 ? Math.max(72, childrenRect.height) : 0
            clip: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Text {
                visible: root.effectiveIconGlyph.length > 0
                text: root.effectiveIconGlyph
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 18
                color: Theme.accent
                Layout.alignment: Qt.AlignTop
            }
            Text {
                text: root.title
                font.weight: Theme.fontWeightSemiBold
                font.pixelSize: Theme.fontBody
                color: Theme.textPrimary
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 2
            }
            T.AbstractButton {
                id: closeBtn
                visible: root.isCloseButtonVisible
                implicitWidth: 28
                implicitHeight: 28
                hoverEnabled: true
                focusPolicy: Qt.StrongFocus
                activeFocusOnTab: true
                Accessible.name: qsTr("Close")
                onClicked: {
                    root.closeButtonClicked()
                    root.closedByUser()
                    root.close()
                }
                Keys.onReturnPressed: closeBtn.clicked()
                Keys.onEnterPressed: closeBtn.clicked()
                Keys.onSpacePressed: closeBtn.clicked()
                scale: down && !Theme.reducedMotion ? 0.92 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
                contentItem: Text {
                    text: root.closeButtonContent.length ? root.closeButtonContent
                                                         : FluentIcons.ChromeClose
                    font.family: root.closeButtonContent.length ? Theme.fontFamily
                                                                : Theme.fontFamilyIcon
                    font.pixelSize: root.closeButtonContent.length ? Theme.fontCaption : 10
                    color: closeBtn.down ? Theme.textPrimary : Theme.textSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                }
                background: Rectangle {
                    radius: Theme.cornerControl
                    color: {
                        if (closeBtn.down)
                            return Theme.fillSubtleTertiary
                        if (closeBtn.hovered || closeBtn.visualFocus)
                            return Theme.fillSubtle
                        return "transparent"
                    }
                    border.width: closeBtn.visualFocus ? 1 : 0
                    border.color: Theme.accent
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                }
            }
        }

        Text {
            visible: root.subtitle.length > 0
            text: root.subtitle
            color: Theme.textSecondary
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 4
            Layout.fillWidth: true
        }

        Item {
            id: bodySlot
            visible: children.length > 0
            Layout.fillWidth: true
            Layout.preferredHeight: children.length > 0 ? Math.max(childrenRect.height, 1) : 0
            implicitHeight: childrenRect.height
        }

        Item {
            id: actionButtonSlot
            visible: children.length > 0
            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: children.length ? childrenRect.width : 0
            Layout.preferredHeight: children.length ? Math.max(Theme.controlHeight, childrenRect.height) : 0
        }

        AccentButton {
            visible: root.actionText.length > 0 && actionButtonSlot.children.length === 0
            Layout.alignment: Qt.AlignRight
            text: root.actionText
            onClicked: {
                root.actionClicked()
                root.close()
            }
        }
    }

    background: Item {
        ElevatedChrome {
            id: tipPanel
            anchors.fill: parent
            radius: Theme.cornerOverlay
            color: Theme.bgCard
            borderColor: Theme.strokeCard
            borderWidth: 1
            elevation: 6
            shadowOpacity: Theme.dark ? 0.28 : 0.16

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 1
                width: 3
                radius: 1.5
                color: Theme.accent
                opacity: 0.85
                z: 1
            }
        }
        Rectangle {
            id: tipArrow
            visible: root.tailVisibility
            width: 10
            height: 10
            rotation: 45
            color: Theme.bgCard
            border.width: 1
            border.color: Theme.strokeCard
            z: -1
            anchors.horizontalCenter: {
                if (root.effectivePlacement === Qt.AlignLeft || root.effectivePlacement === Qt.AlignRight)
                    return undefined
                return parent.horizontalCenter
            }
            anchors.verticalCenter: {
                if (root.effectivePlacement === Qt.AlignTop || root.effectivePlacement === Qt.AlignBottom)
                    return undefined
                return parent.verticalCenter
            }
            anchors.bottom: root.effectivePlacement === Qt.AlignTop ? parent.bottom : undefined
            anchors.top: root.effectivePlacement === Qt.AlignBottom ? parent.top : undefined
            anchors.right: root.effectivePlacement === Qt.AlignLeft ? parent.right : undefined
            anchors.left: root.effectivePlacement === Qt.AlignRight ? parent.left : undefined
            anchors.bottomMargin: root.effectivePlacement === Qt.AlignTop ? -5 : 0
            anchors.topMargin: root.effectivePlacement === Qt.AlignBottom ? -5 : 0
            anchors.rightMargin: root.effectivePlacement === Qt.AlignLeft ? -5 : 0
            anchors.leftMargin: root.effectivePlacement === Qt.AlignRight ? -5 : 0
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            property: "scale"
            from: 0.96; to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1; to: 0
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
    }
}
