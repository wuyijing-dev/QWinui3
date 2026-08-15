import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// SwitchPresenter — Shows the SwitchCase matching value.
//
//   SwitchPresenter {
//       value: mode
//       SwitchCase { value: "a"; Label { text: "A" } }
//   }

T.Control {
    id: root

    // Current value
    property var value
    property bool animated: true
    // Selected index
    property int currentIndex: -1
    // Selected index alias
    property alias selectedIndex: root.currentIndex
    default property alias cases: host.data

    signal caseChanged(var value, int index)

    implicitWidth: 280
    implicitHeight: Math.max(Theme.controlHeight, host.implicitHeight)
    padding: 0
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Switch presenter")
    Accessible.description: qsTr("Case %1").arg(currentIndex)

    contentItem: Item {
        id: host
        implicitHeight: {
            var h = 0
            for (var i = 0; i < children.length; ++i) {
                var ch = children[i]
                if (ch && (ch.visible || ch.opacity > 0.01))
                    h = Math.max(h, ch.implicitHeight, ch.height)
            }
            return h
        }
        onWidthChanged: syncWidths()
        onChildrenChanged: Qt.callLater(root.applyValue)
    }

    onValueChanged: applyValue()
    Component.onCompleted: Qt.callLater(applyValue)

    function valuesEqual(a, b) {
        if (a === b)
            return true
        if (a === undefined || b === undefined || a === null || b === null)
            return a == b
        return String(a) === String(b)
    }

    function select(index) {
        var cases = []
        for (var i = 0; i < host.children.length; ++i) {
            var ch = host.children[i]
            if (ch && ch.value !== undefined)
                cases.push(ch)
        }
        if (index < 0 || index >= cases.length)
            return
        value = cases[index].value
    }

    function applyValue() {
        var matched = false
        var fallback = null
        var fallbackIndex = -1
        var activeIndex = -1
        var caseIndex = -1
        for (var i = 0; i < host.children.length; ++i) {
            var ch = host.children[i]
            if (!ch || (ch.value === undefined && ch.contentData === undefined))
                continue
            caseIndex++
            if (ch.value === undefined || ch.value === null) {
                fallback = ch
                fallbackIndex = caseIndex
                continue
            }
            var on = !matched && valuesEqual(ch.value, root.value)
            setCaseActive(ch, on)
            if (on) {
                matched = true
                activeIndex = caseIndex
            }
        }
        if (!matched && fallback) {
            setCaseActive(fallback, true)
            activeIndex = fallbackIndex
        }
        if (currentIndex !== activeIndex) {
            currentIndex = activeIndex
            caseChanged(root.value, activeIndex)
        }
        syncWidths()
    }

    function setCaseActive(ch, on) {
        if (!ch)
            return
        if (ch.active !== undefined)
            ch.active = on
        if (!root.animated || Theme.reducedMotion) {
            ch.visible = on
            ch.opacity = on ? 1 : 0
            return
        }
        if (on) {
            ch.visible = true
            ch.opacity = 1
        } else {
            ch.opacity = 0
        }
    }

    function syncWidths() {
        for (var i = 0; i < host.children.length; ++i) {
            var ch = host.children[i]
            if (ch)
                ch.width = host.width
        }
    }

    background: Item {}
}
