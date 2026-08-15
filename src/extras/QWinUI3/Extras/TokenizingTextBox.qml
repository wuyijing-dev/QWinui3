import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TokenizingTextBox — Token chips + text input.
//
//   TokenizingTextBox {
//       id: tokenizingTextBox
//       model: tokens
//       placeholderText: qsTr("Add…")
//   }
//
//   // --- API ---
//   // signals: onTokenAdded, onTokenRemoved, onAccepted, onQuerySubmitted, onCleared
//   // methods: focusField(), clear(), addToken(value), removeToken(index)
//   // tokenizingTextBox.focusField()
//   // tokenizingTextBox.clear()
//   // tokenizingTextBox.addToken(value)
//   // tokenizingTextBox.removeToken(index)

T.Control {
    id: root

    // Display / input text
    property alias text: input.text
    // Current token list
    property var tokens: []
    // Filtered suggestion rows
    property var suggestionModel: []
    // Placeholder when empty
    property string placeholderText: qsTr("Type and press Enter")
    // Suggestion popup open
    property bool suggestionsOpen: false
    // Open / visible state
    property alias isOpen: root.suggestionsOpen
    // Maximum number of tokens
    property int maxTokens: 0 // 0 = unlimited
    // Allow duplicate tokens
    property bool allowDuplicates: false
    // Characters that commit a token
    property string tokenDelimiters: ",;"
    // Header label above the control
    property string header: ""
    // Supporting description text
    property string description: ""
    // Validation error text
    property string errorMessage: ""
    // True when validation failed
    readonly property bool hasError: errorMessage.length > 0
    // Number of tokens
    readonly property int tokenCount: tokens ? tokens.length : 0

    // Token added
    signal tokenAdded(string token)
    // Token removed
    signal tokenRemoved(string token, int index)
    // Emitted on accept / submit
    signal accepted(string token)
    // Emitted when a query is submitted
    signal querySubmitted(string token)
    // Emitted when content is cleared
    signal cleared()

    padding: 6
    leftPadding: 8
    rightPadding: 8
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.EditableText
    Accessible.name: header.length ? header : qsTr("Tokens")
    Accessible.description: hasError ? errorMessage
                           : (description.length ? description
                                                 : qsTr("%1 tokens").arg(tokenCount))

    implicitWidth: 280
    implicitHeight: column.implicitHeight

    // Move keyboard focus to the text field
    function focusField() { input.forceActiveFocus() }

    // Clear text or selection
    function clear() {
        if (!tokens || tokens.length === 0)
            return
        tokens = []
        input.text = ""
        suggestionsOpen = false
        cleared()
    }

    // Insert a token from text
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

    // Remove a token
    function removeToken(index) {
        if (index < 0 || index >= tokens.length)
            return
        var removed = tokens[index]
        var next = tokens.slice()
        next.splice(index, 1)
        tokens = next
        tokenRemoved(removed, index)
    }

    // Suggestions matching the query
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

    contentItem: ColumnLayout {
        id: column
        spacing: 4

        Text {
            visible: root.header.length > 0
            Layout.fillWidth: true
            text: root.header
            font.family: root.font.family
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: root.enabled ? Theme.textPrimary : Theme.textDisabled
            elide: Text.ElideRight
        }
        Text {
            visible: root.description.length > 0 && !root.hasError
            Layout.fillWidth: true
            text: root.description
            font.family: root.font.family
            font.pixelSize: Theme.fontCaption
            color: root.enabled ? Theme.textSecondary : Theme.textDisabled
            wrapMode: Text.Wrap
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(Theme.controlHeight, flow.implicitHeight + 12)

            Item {
                id: fieldHost
                anchors.fill: parent
                implicitHeight: flow.implicitHeight

                Flow {
                    id: flow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 6
                    width: parent.width - 16

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
                    parent: fieldHost
                    y: fieldHost.height + 2
                    width: root.width
                    padding: 4
                    visible: root.suggestionsOpen && root.filteredSuggestions.length > 0
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                    opacity: 0
                    scale: 0.96
                    transformOrigin: Item.Top

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

                    background: ElevatedChrome {
                        color: Theme.bgCardElevated
                        radius: Theme.cornerOverlay
                        borderColor: Theme.strokeCard
                        borderWidth: 1
                        elevation: 6
                        shadowOpacity: Theme.dark ? 0.28 : 0.14
                    }

                    contentItem: ListView {
                        id: suggestList
                        clip: true
                        implicitHeight: Math.min(contentHeight, 180)
                        model: root.filteredSuggestions
                        keyNavigationEnabled: true
                        highlightMoveDuration: Theme.duration(Theme.motionFast)
                        delegate: ItemDelegate {
                            required property int index
                            required property var modelData
                            width: ListView.view.width
                            height: Theme.controlHeight
                            text: "" + modelData
                            highlighted: ListView.isCurrentItem
                            onClicked: root.addToken(modelData)
                            Keys.onReturnPressed: clicked()
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    z: -1
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
                    border.color: root.hasError ? Theme.systemCritical : Theme.strokeControl
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
                        height: input.activeFocus || root.hasError ? 2 : 1
                        color: root.hasError ? Theme.systemCritical
                             : (input.activeFocus ? Theme.accent : Theme.strokeControl)
                        opacity: input.activeFocus || root.hasError ? 1 : 0.85
                    }
                }
            }
        }

        Text {
            visible: root.hasError
            Layout.fillWidth: true
            text: root.errorMessage
            font.family: root.font.family
            font.pixelSize: Theme.fontCaption
            color: Theme.systemCritical
            wrapMode: Text.Wrap
        }
    }

    background: Item {}
}
