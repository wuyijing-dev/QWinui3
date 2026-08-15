import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Control {
    id: root

    property alias text: input.text
    property var tokens: []
    property var suggestionModel: []
    property string placeholderText: qsTr("Type and press Enter")
    property bool suggestionsOpen: false
    property int maxTokens: 0 // 0 = unlimited
    property bool allowDuplicates: false
    // Characters that also commit a token (in addition to Enter)
    property string tokenDelimiters: ",;"

    signal tokenAdded(string token)
    signal tokenRemoved(string token, int index)
    signal accepted(string token)
    signal querySubmitted(string token)

    padding: 6
    leftPadding: 8
    rightPadding: 8
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    implicitWidth: 280
    implicitHeight: Math.max(Theme.controlHeight,
                             flow.implicitHeight + topPadding + bottomPadding)

    function addToken(value) {
        var t = ("" + value).trim()
        if (!t.length)
            return
        if (maxTokens > 0 && tokens.length >= maxTokens)
            return
        if (!allowDuplicates) {
            for (var i = 0; i < tokens.length; ++i) {
                if (tokens[i] === t)
                    return
            }
        }
        var next = tokens.slice()
        next.push(t)
        tokens = next
        input.text = ""
        tokenAdded(t)
        accepted(t)
        querySubmitted(t)
        suggestionsOpen = false
    }

    function removeToken(index) {
        if (index < 0 || index >= tokens.length)
            return
        var removed = tokens[index]
        var next = tokens.slice()
        next.splice(index, 1)
        tokens = next
        tokenRemoved(removed, index)
    }

    readonly property var filteredSuggestions: {
        var q = input.text.trim().toLowerCase()
        var out = []
        var src = suggestionModel || []
        for (var i = 0; i < src.length; ++i) {
            var s = "" + src[i]
            if (q.length === 0 || s.toLowerCase().indexOf(q) >= 0) {
                var dup = false
                for (var j = 0; j < tokens.length; ++j) {
                    if (tokens[j] === s) { dup = true; break }
                }
                if (!dup)
                    out.push(s)
            }
            if (out.length >= 8)
                break
        }
        return out
    }

    contentItem: Item {
        implicitHeight: flow.implicitHeight

        Flow {
            id: flow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6
            width: parent.width

            Repeater {
                model: root.tokens
                Chip {
                    required property int index
                    required property var modelData
                    text: "" + modelData
                    closable: true
                    checked: true
                    onCloseClicked: root.removeToken(index)
                }
            }

            TextField {
                id: input
                implicitWidth: Math.max(80, Math.min(160, root.width * 0.35))
                placeholderText: root.tokens.length === 0 ? root.placeholderText : ""
                background: Item {}
                onTextChanged: {
                    root.suggestionsOpen = text.length > 0 && root.filteredSuggestions.length > 0
                    if (!root.tokenDelimiters.length || text.length === 0)
                        return
                    var last = text.charAt(text.length - 1)
                    if (root.tokenDelimiters.indexOf(last) >= 0) {
                        var value = text.substring(0, text.length - 1)
                        root.addToken(value)
                    }
                }
                Keys.onReturnPressed: root.addToken(text)
                Keys.onEnterPressed: root.addToken(text)
                Keys.onPressed: function (event) {
                    if (event.key === Qt.Key_Backspace && text.length === 0
                            && root.tokens.length > 0) {
                        root.removeToken(root.tokens.length - 1)
                        event.accepted = true
                    }
                }
                onActiveFocusChanged: {
                    if (!activeFocus)
                        root.suggestionsOpen = false
                }
            }
        }

        Popup {
            id: suggestPopup
            y: root.height + 2
            width: root.width
            padding: 4
            visible: root.suggestionsOpen && root.filteredSuggestions.length > 0
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

            background: Rectangle {
                color: Theme.bgCardElevated
                radius: Theme.cornerOverlay
                border.width: 1
                border.color: Theme.strokeCard

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowOpacity: Theme.dark ? 0.28 : 0.14
                    shadowColor: "#000000"
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 6
                    blurMax: 24
                    autoPaddingEnabled: true
                }
            }

            contentItem: ListView {
                id: suggestList
                clip: true
                implicitHeight: Math.min(contentHeight, 180)
                model: root.filteredSuggestions
                delegate: ItemDelegate {
                    required property int index
                    required property var modelData
                    width: ListView.view.width
                    height: Theme.controlHeight
                    text: "" + modelData
                    onClicked: root.addToken(modelData)
                }
            }
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: {
            if (!root.enabled)
                return Theme.fillControlDisabled
            if (input.activeFocus)
                return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
            if (root.hovered)
                return Theme.fillControlSecondary
            return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
        }
        border.width: 1
        border.color: Theme.strokeControl
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }

        Rectangle {
            id: underline
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: input.activeFocus ? 2 : 1
            color: input.activeFocus ? Theme.accent : Theme.strokeControl
            opacity: input.activeFocus ? 1 : 0.85
            Behavior on height {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            transform: Scale {
                origin.x: underline.width / 2
                xScale: input.activeFocus ? 1 : (Theme.reducedMotion ? 1 : 0.28)
                Behavior on xScale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }
    }
}
