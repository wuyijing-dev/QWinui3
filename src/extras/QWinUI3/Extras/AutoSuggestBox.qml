import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// AutoSuggestBox — Text field with filtered suggestion popup.
//
//   AutoSuggestBox {
//       id: autoSuggestBox
//       placeholderText: qsTr("Suggest")
//       model: items
//       onSuggestionChosen: (item) => apply(item)
//   }
//
//   // --- API ---
//   // signals: onSuggestionChosen, onQuerySubmitted, onAccepted, onCleared
//   // methods: focusField(), displayTextFor(item), refreshSuggestions(), clear()
//   // autoSuggestBox.focusField()
//   // autoSuggestBox.displayTextFor(item)
//   // autoSuggestBox.refreshSuggestions()
//   // autoSuggestBox.clear()
//
// @notes
//   Text field + filtered suggestion popup (model / text / suggestionChosen).
//   Call focusField() / clear(); refreshSuggestions() after model changes.
//   header / description (WinUI Description); maxSuggestionListHeight caps the popup.
//   filterDebounceMs (2.87 D21) debounces filter; highlightMatches + MatchHighlightText in popup rows.

T.Control {
    id: control

    // Display / input text
    property alias text: field.text
    // Placeholder when empty
    property alias placeholderText: field.placeholderText
    // Data model / item list for this control
    property var model: []
    // Filtered suggestion rows
    property var suggestionModel: []
    // Show clear affordance
    property bool clearButtonVisible: true
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: FluentIcons.Search
    // Search glyph fallback string
    property string queryIcon: ""
    // Write selection into the text field
    property bool updateTextOnSelect: true
    // Object field used as display text
    property string textMemberPath: ""
    // Suggestion popup open state
    property bool isSuggestionListOpen: false
    // Header label above the control
    property string header: ""
    // WinUI Description — supporting text under the header
    property string description: ""
    // Max height of the suggestion ListView (WinUI MaxSuggestionListHeight)
    property real maxSuggestionListHeight: 240
    // WinUI ChooseSuggestionOnEnter — Enter picks highlighted row when list is open
    property bool chooseSuggestionOnEnter: true
    // Debounce suggestion filter keystrokes (2.16 / 2.87 D21).
    property int filterDebounceMs: 120
    // Cap filtered suggestion rows (2.16).
    property int maxSuggestionResults: 32
    // Skip filter until query length >= this (2.59).
    property int minFilterLength: 0
    // Accent-highlight matching substring in suggestion rows (2.87 D21).
    property bool highlightMatches: true

    // Resolved search glyph
    readonly property string effectiveQueryIcon: IconSource.resolve(symbol, queryIcon)

    // Emitted when a suggestion is chosen
    signal suggestionChosen(var item)
    // Emitted when a query is submitted
    signal querySubmitted(string query)
    // Emitted on accept / submit
    signal accepted(string text)
    // Emitted when content is cleared
    signal cleared()

    implicitWidth: 280
    implicitHeight: column.implicitHeight
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Suggestions")
    Accessible.description: description

    property string _lastSuggestKey: ""

    Timer {
        id: suggestDebounce
        interval: control.filterDebounceMs
        onTriggered: control._rebuildSuggestions()
    }

    // Move keyboard focus to the text field
    function focusField() { field.forceActiveFocus() }

    // Display text for a model item
    function displayTextFor(item) {
        if (item === undefined || item === null)
            return ""
        if (typeof item === "string")
            return item
        if (control.textMemberPath && item[control.textMemberPath] !== undefined)
            return String(item[control.textMemberPath])
        return String(item.title || item.text || "")
    }

    // Match range for highlightMatches / external consumers (2.87 D21).
    function matchHighlightRange(text, query) {
        var q = String(query !== undefined ? query : (field.text || "")).trim().toLowerCase()
        var t = String(text || "")
        if (!q.length || !t.length)
            return { start: -1, length: 0 }
        var idx = t.toLowerCase().indexOf(q)
        if (idx < 0)
            return { start: -1, length: 0 }
        return { start: idx, length: q.length }
    }

    // Rebuild suggestion list from text (immediate — used after model changes).
    function refreshSuggestions() {
        suggestDebounce.stop()
        control._rebuildSuggestions()
    }

    function _scheduleSuggestions() {
        var q = (field.text || "").trim()
        if (!q.length) {
            suggestDebounce.stop()
            control._rebuildSuggestions()
            return
        }
        suggestDebounce.restart()
    }

    function _rebuildSuggestions() {
        var q = (field.text || "").trim().toLowerCase()
        if (minFilterLength > 0 && q.length > 0 && q.length < minFilterLength) {
            control.suggestionModel = []
            popup.close()
            return
        }
        if (q === control._lastSuggestKey)
            return
        control._lastSuggestKey = q
        if (!q.length) {
            control.suggestionModel = []
            popup.close()
            return
        }
        var out = control.model.filter(function (item) {
            var title = control.displayTextFor(item)
            return String(title).toLowerCase().indexOf(q) >= 0
        })
        if (control.maxSuggestionResults > 0 && out.length > control.maxSuggestionResults)
            out = out.slice(0, control.maxSuggestionResults)
        control.suggestionModel = out
        if (out.length) {
            list.currentIndex = 0
            popup.open()
        } else {
            popup.close()
        }
    }

    function _moveSuggestion(delta) {
        if (!popup.opened || !suggestionModel || !suggestionModel.length)
            return
        var next = list.currentIndex < 0 ? 0 : list.currentIndex + delta
        if (next < 0)
            next = suggestionModel.length - 1
        if (next >= suggestionModel.length)
            next = 0
        list.currentIndex = next
        list.positionViewAtIndex(next, ListView.Contain)
    }

    // Clear text or selection
    function clear() {
        field.text = ""
        suggestionModel = []
        _lastSuggestKey = ""
        popup.close()
        cleared()
    }

    function _chooseCurrentSuggestion() {
        if (!popup.opened || !suggestionModel || !suggestionModel.length)
            return false
        var idx = Math.max(0, list.currentIndex)
        if (idx >= suggestionModel.length)
            return false
        var item = suggestionModel[idx]
        if (updateTextOnSelect)
            field.text = displayTextFor(item)
        suggestionChosen(item)
        popup.close()
        return true
    }

    contentItem: ColumnLayout {
        id: column
        spacing: 4

        Text {
            visible: control.header.length > 0
            Layout.fillWidth: true
            text: control.header
            font.family: control.font.family
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
            elide: Text.ElideRight
        }
        Text {
            visible: control.description.length > 0
            Layout.fillWidth: true
            text: control.description
            font.family: control.font.family
            font.pixelSize: Theme.fontCaption
            color: control.enabled ? Theme.textSecondary : Theme.textDisabled
            wrapMode: Text.Wrap
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.searchBoxHeight

            TextField {
                id: field
                anchors.fill: parent
                leftPadding: 36
                rightPadding: clearBtn.visible ? 36 : Theme.paddingControlH
                placeholderText: control.placeholderText
                onTextChanged: control._scheduleSuggestions()
                onAccepted: {
                    if (control.chooseSuggestionOnEnter && control._chooseCurrentSuggestion())
                        return
                    control.accepted(text)
                    control.querySubmitted(text)
                    popup.close()
                }
                Keys.onDownPressed: function (event) {
                    if (popup.opened && suggestionModel.length) {
                        control._moveSuggestion(1)
                        event.accepted = true
                    }
                }
                Keys.onUpPressed: function (event) {
                    if (popup.opened && suggestionModel.length) {
                        control._moveSuggestion(-1)
                        event.accepted = true
                    }
                }
                Keys.onEscapePressed: function (event) {
                    if (popup.opened) {
                        popup.close()
                        event.accepted = true
                    }
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: control.effectiveQueryIcon
                font: Theme.iconFontFor(14)
                color: field.activeFocus ? Theme.accent : Theme.textSecondary
                z: 1
                scale: field.activeFocus && !Theme.reducedMotion ? 1.05 : 1
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
            }

            AbstractButton {
                id: clearBtn
                visible: control.clearButtonVisible && field.text.length > 0
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 32
                z: 1
                opacity: visible ? 1 : 0
                scale: down && !Theme.reducedMotion ? 0.9 : 1
                Accessible.name: qsTr("Clear")
                onClicked: control.clear()
                contentItem: Text {
                    text: FluentIcons.ChromeClose
                    font: Theme.iconFontFor(10)
                    color: Theme.textSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                    }
                }
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                    }
                }
                background: Rectangle {
                    radius: Theme.cornerControl
                    color: clearBtn.down ? Theme.fillSubtleTertiary
                         : (clearBtn.hovered ? Theme.fillSubtle : "transparent")
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                        }
                    }
                }
            }

            Popup {
                id: popup
                y: field.height + 4
                width: parent.width
                padding: 4
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                opacity: 0
                scale: 0.96
                transformOrigin: Item.Top
                onOpened: control.isSuggestionListOpen = true
                onClosed: control.isSuggestionListOpen = false

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
                    id: list
                    clip: true
                    implicitHeight: Math.min(contentHeight, control.maxSuggestionListHeight)
                    model: control.suggestionModel
                    keyNavigationEnabled: true
                    highlightMoveDuration: Theme.duration(Theme.motionFast)
                    delegate: ItemDelegate {
                        required property var modelData
                        required property int index
                        width: ListView.view.width
                        height: Theme.navItemHeight
                        highlighted: ListView.isCurrentItem
                        onClicked: {
                            if (control.updateTextOnSelect)
                                field.text = control.displayTextFor(modelData)
                            control.suggestionChosen(modelData)
                            popup.close()
                            field.forceActiveFocus()
                        }
                        Keys.onReturnPressed: clicked()
                        Keys.onEscapePressed: {
                            popup.close()
                            field.forceActiveFocus()
                        }
                        Keys.onUpPressed: function (event) {
                            if (index <= 0) {
                                field.forceActiveFocus()
                                event.accepted = true
                            }
                        }
                        onHoveredChanged: if (hovered) ListView.view.currentIndex = index
                        contentItem: MatchHighlightText {
                            sourceText: control.displayTextFor(modelData)
                            query: control.highlightMatches ? field.text : ""
                            font.weight: parent.highlighted ? Theme.fontWeightSemiBold : Theme.fontWeightNormal
                            normalColor: parent.highlighted ? Theme.textPrimary : Theme.textSecondary
                        }
                    }
                }
            }
        }
    }
}
