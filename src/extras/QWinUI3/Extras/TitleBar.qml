import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Effects
import QWinUI3.Theme

Item {
    id: root

    property string title: qsTr("Application")
    property url iconSource: ""
    property alias searchText: searchField.text
    property var searchModel: []
    property bool searchEnabled: true
    property bool embedded: false
    property bool useSystemMove: true
    property real trailingReserve: 0
    property var dragWindow: null
    default property alias content: trailing.data

    signal searchActivated(var item)
    signal searchTextEdited(string text)

    height: 48
    implicitHeight: 48

    // Window-local rects that must stay HTCLIENT under native chrome (search, etc.).
    function clientExcludeRectsFor(window) {
        var list = []
        if (!window || !root.searchEnabled || !searchField.visible)
            return list
        var g = searchField.mapToGlobal(0, 0)
        list.push(Qt.rect(Math.floor(g.x - window.x) - 2,
                          Math.floor(g.y - window.y) - 2,
                          Math.ceil(searchField.width) + 4,
                          Math.ceil(searchField.height) + 4))
        return list
    }

    Rectangle {
        anchors.fill: parent
        visible: !root.embedded
        color: Theme.bgAcrylic
        // No bottom seam — title and body should read as one surface.
    }

    MouseArea {
        anchors.fill: parent
        anchors.rightMargin: root.trailingReserve
        z: -1
        // Always allow Qt drag; native HTCAPTION still wins when hit-test is ready.
        enabled: root.embedded && root.dragWindow
        acceptedButtons: Qt.LeftButton
        onPressed: {
            if (root.dragWindow && root.dragWindow.startSystemMove)
                root.dragWindow.startSystemMove()
        }
        onDoubleClicked: {
            if (!root.dragWindow)
                return
            if (root.dragWindow.visibility === Window.Maximized)
                root.dragWindow.showNormal()
            else
                root.dragWindow.showMaximized()
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12 + root.trailingReserve
        spacing: Theme.spacing

        Image {
            visible: root.iconSource.toString().length > 0
            source: root.iconSource
            sourceSize.width: 16
            sourceSize.height: 16
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
        }

        Text {
            text: root.title
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            elide: Text.ElideRight
            Layout.preferredWidth: Math.min(implicitWidth, 180)
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.searchBoxHeight
            Layout.maximumWidth: 480
            visible: root.searchEnabled

            TextField {
                id: searchField
                anchors.fill: parent
                placeholderText: qsTr("Search controls")
                leftPadding: 36
                rightPadding: clearBtn.visible ? 36 : Theme.paddingControlH
                onTextChanged: {
                    if (text.length === 0) {
                        searchDebounce.stop()
                        root.searchTextEdited("")
                        suggestPopup.close()
                        return
                    }
                    // Debounce catalog search while typing.
                    searchDebounce.restart()
                }
                Keys.onDownPressed: suggestList.forceActiveFocus()
                Keys.onReturnPressed: {
                    if (root.searchModel.length > 0)
                        root.searchActivated(root.searchModel[0])
                }
                Keys.onEscapePressed: {
                    text = ""
                    suggestPopup.close()
                }
            }

            Timer {
                id: searchDebounce
                interval: 100
                repeat: false
                onTriggered: {
                    root.searchTextEdited(searchField.text)
                    if (searchField.text.length > 0 && root.searchModel.length > 0)
                        suggestPopup.open()
                    else if (searchField.text.length === 0)
                        suggestPopup.close()
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: "\uE721"
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 14
                color: searchField.activeFocus ? Theme.accent : Theme.textSecondary
                z: 1
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }

            ToolButton {
                id: clearBtn
                visible: searchField.text.length > 0
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 32
                z: 1
                text: "\uE711"
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 10
                onClicked: {
                    searchField.text = ""
                    searchField.forceActiveFocus()
                }
            }

            Popup {
                id: suggestPopup
                y: searchField.height + 4
                width: searchField.width
                padding: 4
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                visible: searchField.activeFocus
                         && root.searchText.length > 0
                         && root.searchModel.length > 0
                transformOrigin: Item.Top

                enter: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 0; to: 1
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingEnter
                    }
                    NumberAnimation {
                        property: "scale"
                        from: 0.98; to: 1
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
                        shadowOpacity: Theme.dark ? 0.3 : 0.16
                        shadowColor: "#000000"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 8
                        blurMax: 28
                        autoPaddingEnabled: true
                    }
                }

                contentItem: ListView {
                    id: suggestList
                    implicitHeight: Math.min(contentHeight, 280)
                    clip: true
                    model: root.searchModel
                    highlightMoveDuration: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionFast)
                    delegate: ItemDelegate {
                        required property var modelData
                        required property int index
                        width: ListView.view.width
                        height: Theme.navItemHeight
                        text: modelData.title
                        onClicked: {
                            root.searchActivated(modelData)
                            suggestPopup.close()
                            searchField.text = ""
                        }

                        contentItem: RowLayout {
                            spacing: 12
                            Text {
                                text: modelData.icon || "\uE8A7"
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 16
                                color: Theme.textSecondary
                            }
                            ColumnLayout {
                                spacing: 0
                                Layout.fillWidth: true
                                Text {
                                    text: modelData.title !== undefined ? String(modelData.title) : ""
                                    font.pixelSize: Theme.fontBody
                                    color: Theme.textPrimary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    visible: modelData.description !== undefined
                                             && modelData.description !== null
                                             && String(modelData.description).length > 0
                                    text: modelData.description !== undefined && modelData.description !== null
                                          ? String(modelData.description) : ""
                                    font.pixelSize: Theme.fontCaption
                                    color: Theme.textSecondary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true; Layout.preferredWidth: 1 }

        Row {
            id: trailing
            spacing: Theme.spacing
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }
    }
}
