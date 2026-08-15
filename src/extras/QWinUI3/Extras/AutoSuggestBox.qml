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
    implicitHeight: Theme.searchBoxHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Suggestions")

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

    // Rebuild suggestion list from text
    function refreshSuggestions() {
        var q = (field.text || "").trim().toLowerCase()
        if (!q.length) {
            control.suggestionModel = []
            popup.close()
            return
        }
        control.suggestionModel = control.model.filter(function (item) {
            var title = control.displayTextFor(item)
            return String(title).toLowerCase().indexOf(q) >= 0
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

    contentItem: Item {
        TextField {
            id: field
            anchors.fill: parent
            leftPadding: 36
            rightPadding: clearBtn.visible ? 36 : Theme.paddingControlH
            placeholderText: control.placeholderText
            onTextChanged: control.refreshSuggestions()
            onAccepted: {
                control.accepted(text)
                control.querySubmitted(text)
                popup.close()
            }
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
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 10
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
            width: control.width
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
                // Host item for popup anchoring
                property var host: control
                keyNavigationEnabled: true
                highlightMoveDuration: Theme.duration(Theme.motionFast)
                delegate: ItemDelegate {
                    required property var modelData
                    required property int index
                    width: ListView.view.width
                    height: Theme.navItemHeight
                    text: list.host.displayTextFor(modelData)
                    highlighted: ListView.isCurrentItem
                    onClicked: {
                        if (list.host.updateTextOnSelect)
                            field.text = text
                        list.host.suggestionChosen(modelData)
                        popup.close()
                    }
                    Keys.onReturnPressed: clicked()
                }
            }
        }
    }
}
