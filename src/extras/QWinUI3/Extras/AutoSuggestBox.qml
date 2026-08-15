import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Control {
    id: control

    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property var model: []
    property var suggestionModel: []
    property bool clearButtonVisible: true
    // WinUI QueryIcon — Segoe Fluent glyph
    property string queryIcon: "\uE721"
    // When true, selecting a suggestion replaces the field text
    property bool updateTextOnSelect: true
    // Optional object-model field (falls back to title / text)
    property string textMemberPath: ""

    signal suggestionChosen(var item)
    // WinUI QuerySubmitted — Enter or commit without picking a suggestion
    signal querySubmitted(string query)
    signal accepted(string text)
    signal cleared()

    implicitWidth: 280
    implicitHeight: Theme.searchBoxHeight
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    function displayTextFor(item) {
        if (item === undefined || item === null)
            return ""
        if (typeof item === "string")
            return item
        if (control.textMemberPath && item[control.textMemberPath] !== undefined)
            return String(item[control.textMemberPath])
        return String(item.title || item.text || "")
    }

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
            text: control.queryIcon
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

        ToolButton {
            id: clearBtn
            visible: control.clearButtonVisible && field.text.length > 0
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 32
            height: 32
            z: 1
            opacity: visible ? 1 : 0
            scale: down && !Theme.reducedMotion ? 0.9 : 1
            text: "\uE711"
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
            onClicked: control.clear()
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
                id: list
                clip: true
                implicitHeight: Math.min(contentHeight, 240)
                model: control.suggestionModel
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
