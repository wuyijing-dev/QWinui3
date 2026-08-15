import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// SearchBox — Search field with suggestion list.
//
//   SearchBox {
//       id: searchBox
//       placeholderText: qsTr("Search")
//       model: suggestions
//       onSuggestionChosen: (item) => open(item)
//   }
//
//   // --- API ---
//   // signals: onAccepted, onQuerySubmitted, onSuggestionChosen, onCleared
//   // methods: focusField(), displayTextFor(item), refreshSuggestions(), clear(), submitQuery()
//   // searchBox.focusField()
//   // searchBox.displayTextFor(item)
//   // searchBox.refreshSuggestions()
//   // searchBox.clear()

T.Control {
    id: control

    // Display / input text
    property alias text: field.text
    // Placeholder when empty
    property alias placeholderText: field.placeholderText
    // Show clear affordance
    property bool clearButtonVisible: true
    // FluentIcons symbol or leave empty to use queryIcon glyph
    property var symbol: FluentIcons.Search
    // Search glyph fallback string
    property string queryIcon: ""
    // Header label above the control
    property string header: ""
    // Supporting description text
    property string description: ""
    // Full suggestion catalog; filtered into suggestionModel while typing
    property var model: []
    // Filtered suggestion rows
    property var suggestionModel: []
    // When true, choosing a suggestion writes display text into the field
    property bool updateTextOnSelect: true
    // Object field used as display text (fallback: title | text | name)
    property string textMemberPath: ""
    // Suggestion popup open state
    property bool isSuggestionListOpen: false

    // Resolved search glyph
    readonly property string effectiveQueryIcon: IconSource.resolve(symbol, queryIcon)

    // Enter / submit with current text
    signal accepted(string text)
    // Emitted when a query is submitted
    signal querySubmitted(string query)
    // User picked a suggestion row
    signal suggestionChosen(var item)
    // Emitted when content is cleared
    signal cleared()

    implicitWidth: 280
    implicitHeight: column.implicitHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.EditableText
    Accessible.name: header.length ? header : qsTr("Search")
    Accessible.description: description

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
        return String(item.title || item.text || item.name || "")
    }

    // Rebuild suggestion list from text
    function refreshSuggestions() {
        if (!control.model || !control.model.length) {
            control.suggestionModel = []
            popup.close()
            return
        }
        var q = (field.text || "").trim().toLowerCase()
        if (!q.length) {
            control.suggestionModel = []
            popup.close()
            return
        }
        control.suggestionModel = control.model.filter(function (item) {
            return String(control.displayTextFor(item)).toLowerCase().indexOf(q) >= 0
        })
        if (control.suggestionModel.length)
            popup.open()
        else
            popup.close()
    }

    // Clear text or selection
    function clear() {
        field.text = ""
        suggestionModel = []
        popup.close()
        cleared()
    }

    // Submit the search query
    function submitQuery() {
        accepted(field.text)
        querySubmitted(field.text)
        popup.close()
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
                placeholderText: control.placeholderText.length ? control.placeholderText : qsTr("Search")
                onTextChanged: control.refreshSuggestions()
                onAccepted: control.submitQuery()
                Keys.onDownPressed: {
                    if (popup.opened)
                        list.forceActiveFocus()
                }
                Keys.onEscapePressed: popup.close()
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: control.effectiveQueryIcon
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 14
                color: field.activeFocus ? Theme.accent : Theme.textSecondary
                z: 1
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
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
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: Theme.textSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                background: Rectangle {
                    radius: Theme.cornerControl
                    color: clearBtn.down ? Theme.fillSubtleTertiary
                         : (clearBtn.hovered ? Theme.fillSubtle : "transparent")
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
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
                    implicitHeight: Math.min(contentHeight, 240)
                    model: control.suggestionModel
                    keyNavigationEnabled: true
                    highlightMoveDuration: Theme.duration(Theme.motionFast)
                    delegate: ItemDelegate {
                        required property var modelData
                        required property int index
                        width: ListView.view.width
                        height: Theme.navItemHeight
                        text: control.displayTextFor(modelData)
                        highlighted: ListView.isCurrentItem
                        onClicked: {
                            if (control.updateTextOnSelect)
                                field.text = text
                            control.suggestionChosen(modelData)
                            popup.close()
                        }
                        Keys.onReturnPressed: clicked()
                    }
                }
            }
        }
    }

    background: Item {}
}
