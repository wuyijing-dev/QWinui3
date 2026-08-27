import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ImeCandidateBar — Win11-style in-app IME candidate strip (1.74).
//
//   ImeCandidateBar { engine: osk.engine }
//   ImeCandidateBar { engine: osk.engine; placement: "floating"; dockInset: osk.implicitHeight }
//
// @notes
//   Host above OnScreenKeyboard (inline) or window overlay (floating). Theme acrylic
//   matches OSK dock in light and dark. No focus steal.
//   Shared by pinyin / romaji-kana / hangul. Digits 1–9 / Space via engine.
//   Not Microsoft IME.
//   Live-region: announce paged candidates / preedit on composeChanged (1.85).

T.Control {
    id: root

    property KeyboardEngine engine
    property string placement: "inline"
    property real dockInset: 0
    property int activeGroupIndex: 0
    property int groupPage: 0

    readonly property var _displayGroups: {
        if (!engine || !engine.pinyin || !engine.candidateGroups.length)
            return []
        return engine.candidateGroups
    }
    readonly property var _activeItems: {
        if (_displayGroups.length === 0)
            return engine ? engine.pagedCandidates : []
        const g = _displayGroups[Math.min(activeGroupIndex, _displayGroups.length - 1)]
        return g && g.items ? g.items : []
    }
    readonly property int _pageStart: _displayGroups.length > 0 ? groupPage * 9 : (engine ? engine.candidatePage * 9 : 0)
    readonly property var _pageItems: {
        const items = _activeItems
        const start = _pageStart
        const out = []
        for (let i = 0; i < 9 && start + i < items.length; ++i)
            out.push(items[start + i])
        return out
    }
    readonly property int _pageCount: {
        const n = _activeItems.length
        return n > 0 ? Math.ceil(n / 9) : (engine ? engine.candidatePageCount : 0)
    }

    visible: engine && (engine.composing || engine.candidates.length > 0)
    implicitHeight: visible ? Math.max(Theme.dp(40), Theme.controlHeight)
                              + (_displayGroups.length > 1 ? Theme.dp(28) : 0) : 0
    implicitWidth: 640
    focusPolicy: Qt.NoFocus
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("IME candidates")

    property string _lastLive: ""

    function _announceCompose() {
        if (!engine || !visible)
            return
        var text = ""
        var page = _pageItems
        if (page && page.length)
            text = qsTr("Candidates: %1").arg(page.slice(0, 5).join(", "))
        else if (engine.preedit.length)
            text = qsTr("Composition %1").arg(engine.preedit)
        if (!text.length || text === _lastLive)
            return
        _lastLive = text
        try {
            if (typeof Accessible.announce === "function")
                Accessible.announce(text)
        } catch (err) {
        }
    }

    function _prevPage() {
        if (_displayGroups.length > 0) {
            if (_pageCount <= 0)
                return
            groupPage = (groupPage + _pageCount - 1) % _pageCount
            return
        }
        if (engine)
            engine.prevCandidatePage()
    }

    function _nextPage() {
        if (_displayGroups.length > 0) {
            if (_pageCount <= 0)
                return
            groupPage = (groupPage + 1) % _pageCount
            return
        }
        if (engine)
            engine.nextCandidatePage()
    }

    function _pickAt(indexOnPage) {
        if (!engine)
            return
        if (_displayGroups.length === 0) {
            engine.pickCandidate(indexOnPage)
            return
        }
        const idx = _pageStart + indexOnPage
        const items = _activeItems
        if (idx < 0 || idx >= items.length)
            return
        engine.pickCandidateWord(items[idx])
    }

    onVisibleChanged: {
        if (!visible) {
            _lastLive = ""
            activeGroupIndex = 0
            groupPage = 0
        } else {
            Qt.callLater(function () {
                if (root)
                    root._announceCompose()
            })
        }
        if (placement === "floating")
            _syncFloatingParent()
    }

    Connections {
        target: root.engine
        function onComposeChanged() {
            root.activeGroupIndex = 0
            root.groupPage = 0
            root._announceCompose()
        }
    }

    onPlacementChanged: _syncFloatingParent()
    onDockInsetChanged: {
        if (placement === "floating" && parent)
            anchors.bottomMargin = dockInset + Theme.dp(8)
    }
    onWindowChanged: _syncFloatingParent()
    onActiveGroupIndexChanged: groupPage = 0

    function _syncFloatingParent() {
        if (placement !== "floating")
            return
        var w = Window.window
        if (!w)
            return
        var overlay = (w.Overlay && w.Overlay.overlay) ? w.Overlay.overlay : w.contentItem
        if (!overlay)
            return
        parent = overlay
        anchors.left = overlay.left
        anchors.right = overlay.right
        anchors.bottom = overlay.bottom
        anchors.leftMargin = Theme.dp(8)
        anchors.rightMargin = Theme.dp(8)
        anchors.bottomMargin = dockInset + Theme.dp(8)
        z = 900
    }

    Component.onCompleted: _syncFloatingParent()

    background: Rectangle {
        visible: root.visible
        color: Theme.bgAcrylic
        radius: Theme.cornerControl
        border.width: Theme.strokeHairline
        border.color: Theme.strokeCard
    }

    contentItem: Column {
        spacing: Theme.dp(4)
        width: parent.width

        Row {
            visible: root._displayGroups.length > 1
            spacing: Theme.dp(4)
            leftPadding: Theme.dp(8)
            Repeater {
                model: root._displayGroups
                delegate: Rectangle {
                    required property int index
                    required property var modelData
                    width: tierLabel.implicitWidth + Theme.dp(12)
                    height: Theme.dp(24)
                    radius: height / 2
                    color: root.activeGroupIndex === index ? Theme.fillAccent : Theme.fillControl
                    Text {
                        id: tierLabel
                        anchors.centerIn: parent
                        text: modelData.label
                        font.pixelSize: Theme.fontCaption
                        color: root.activeGroupIndex === index ? Theme.textOnAccent : Theme.textPrimary
                    }
                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true
                        onClicked: root.activeGroupIndex = index
                    }
                }
            }
        }

        Row {
            id: row
            spacing: Theme.dp(6)
            leftPadding: Theme.dp(8)
            rightPadding: Theme.dp(8)
            height: Math.max(Theme.dp(32), root.availableHeight - (root._displayGroups.length > 1 ? Theme.dp(28) : 0))

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.engine ? root.engine.preedit : ""
                font.pixelSize: Theme.fontBody
                font.underline: true
                color: Theme.textSecondary
                width: Theme.dp(88)
                elide: Text.ElideLeft
            }

            Repeater {
                model: root._pageItems
                delegate: Rectangle {
                    required property int index
                    required property string modelData
                    width: Math.max(Theme.dp(36), label.implicitWidth + Theme.dp(16))
                    height: Theme.dp(32)
                    anchors.verticalCenter: parent.verticalCenter
                    radius: Theme.cornerControl
                    color: ma.containsPress ? Theme.fillControlTertiary
                         : ma.containsMouse ? Theme.fillControlSecondary
                         : Theme.fillSubtle
                    border.width: Theme.strokeHairline
                    border.color: Theme.strokeControl

                    Text {
                        id: label
                        anchors.centerIn: parent
                        text: (index + 1) + " " + modelData
                        font.pixelSize: Theme.fontBody
                        color: Theme.textPrimary
                    }
                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        preventStealing: true
                        onClicked: root._pickAt(index)
                    }
                    Accessible.role: Accessible.Button
                    Accessible.name: qsTr("Candidate %1 %2").arg(index + 1).arg(modelData)
                }
            }

            Rectangle {
                visible: root._pageCount > 1
                width: Theme.dp(32)
                height: Theme.dp(32)
                anchors.verticalCenter: parent.verticalCenter
                radius: Theme.cornerControl
                color: Theme.fillControl
                FontIcon {
                    anchors.centerIn: parent
                    symbol: FluentIcons.ChevronLeft
                    fontSize: Theme.fontCaption
                }
                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    onClicked: root._prevPage()
                }
            }
            Rectangle {
                visible: root._pageCount > 1
                width: Theme.dp(32)
                height: Theme.dp(32)
                anchors.verticalCenter: parent.verticalCenter
                radius: Theme.cornerControl
                color: Theme.fillControl
                FontIcon {
                    anchors.centerIn: parent
                    symbol: FluentIcons.ChevronRight
                    fontSize: Theme.fontCaption
                }
                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    onClicked: root._nextPage()
                }
            }
        }
    }
}
