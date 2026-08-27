import QtQuick

// FlyoutKeyboardFocusTrap — restore keyboard focus after MenuFlyout closes.
//
// @notes
//   MenuFlyout is a Popup-like component; keyboard users may expect focus to
//   return to the control that triggered the flyout.

QtObject {
    id: root

    // MenuFlyout or MenuFlyoutPresenter instance.
    property var flyout: null

    // Focus target to restore after flyout closes.
    property Item focusTarget: null

    property bool enabled: true

    function arm(flyoutItem, target) {
        flyout = flyoutItem
        focusTarget = target
    }

    function _restore() {
        if (!root.enabled)
            return
        if (!root.focusTarget)
            return
        if (typeof root.focusTarget.forceActiveFocus === "function")
            root.focusTarget.forceActiveFocus()
        else
            root.focusTarget.focus = true
    }

    Connections {
        target: root.flyout
        ignoreUnknownSignals: true
        function onIsOpenChanged() {
            if (!root.flyout || root.flyout.isOpen)
                return
            Qt.callLater(function () {
                if (root)
                    root._restore()
            })
        }
        function onClosed() {
            Qt.callLater(function () {
                if (root)
                    root._restore()
            })
        }
    }
}

