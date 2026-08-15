import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Pivot — Header tabs with sliding underline and pages.
//
//   Pivot {
//       id: pivot
//      model: ["Overview", "Details"]
//   }
//
//   // --- API ---
//   // signals: onCurrentIndexChangedByUser, onSelectionChanged
//   // methods: selectIndex(index)
//   // pivot.selectIndex(index)

T.Control {
    id: control

    // Data model / item list for this control
    property var model: []
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // Allow arrow-key navigation
    property bool keyboardNavigationEnabled: true
    // Selection changed by user
    signal currentIndexChangedByUser(int index)
    // Selection changed
    signal selectionChanged(int index)

    implicitWidth: 480
    implicitHeight: 280
    padding: 0
    spacing: 0
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Pivot")
    Accessible.description: qsTr("Tab %1 of %2").arg(currentIndex + 1).arg(model ? model.length : 0)

    onCurrentIndexChanged: selectionChanged(currentIndex)

    Keys.onLeftPressed: {
        if (!keyboardNavigationEnabled || model.length === 0)
            return
        var next = Math.max(0, currentIndex - 1)
        if (next !== currentIndex) {
            currentIndex = next
            currentIndexChangedByUser(next)
        }
    }
    Keys.onRightPressed: {
        if (!keyboardNavigationEnabled || model.length === 0)
            return
        var next = Math.min(model.length - 1, currentIndex + 1)
        if (next !== currentIndex) {
            currentIndex = next
            currentIndexChangedByUser(next)
        }
    }

    // Select by index
    function selectIndex(index) {
        if (index < 0 || index >= model.length)
            return
        currentIndex = index
        currentIndexChangedByUser(index)
    }

    contentItem: ColumnLayout {
        spacing: 0

        Flickable {
            id: headerFlick
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            contentWidth: headerRow.implicitWidth
            contentHeight: height
            clip: true
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds

            Row {
                id: headerRow
                height: headerFlick.height
                spacing: 4

                Repeater {
                    model: control.model
                    AbstractButton {
                        id: tab
                        required property var modelData
                        required property int index
                        height: headerRow.height
                        width: Math.max(72, headerContent.implicitWidth + 24)
                        hoverEnabled: true
                        checkable: true
                        checked: index === control.currentIndex
                        onClicked: control.selectIndex(index)

                        readonly property string _icon: {
                            if (typeof modelData === "string" || !modelData)
                                return ""
                            return IconSource.resolve(modelData.symbol || "",
                                                      modelData.icon || modelData.glyph || "")
                        }
                        readonly property string _title: typeof modelData === "string"
                                                        ? modelData : (modelData.title || "")

                        contentItem: Row {
                            id: headerContent
                            spacing: 8
                            anchors.centerIn: parent
                            Text {
                                visible: tab._icon.length > 0
                                anchors.verticalCenter: parent.verticalCenter
                                text: tab._icon
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 14
                                color: tab.checked ? Theme.accent : Theme.textSecondary
                                Behavior on color {
                                    enabled: !Theme.reducedMotion
                                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                                }
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: tab._title
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontBody
                                font.weight: tab.checked ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                                color: tab.checked ? Theme.textPrimary : Theme.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                Behavior on color {
                                    enabled: !Theme.reducedMotion
                                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                                }
                            }
                        }

                        background: Item {
                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 2
                                radius: Theme.cornerControl
                                color: tab.hovered && !tab.checked ? Theme.fillSubtle : "transparent"
                            }
                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                width: tab.checked ? Math.min(parent.width - 16, headerContent.implicitWidth + 8) : 0
                                height: 3
                                radius: 1.5
                                color: Theme.accent
                                Behavior on width {
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
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.strokeDivider
        }

        StackLayout {
            id: stack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: control.currentIndex

            Repeater {
                model: control.model
                Item {
                    id: pageHost
                    required property var modelData
                    required property int index

                    // True when page is present / set
                    readonly property bool hasPage: typeof modelData === "object"
                                                   && modelData !== null
                                                   && modelData.page !== undefined
                                                   && modelData.page !== null

                    Loader {
                        id: pageLoader
                        anchors.fill: parent
                        anchors.margins: 12
                        active: pageHost.hasPage
                        sourceComponent: pageHost.hasPage ? modelData.page : null
                        opacity: control.currentIndex === pageHost.index ? 1 : 0
                        Behavior on opacity {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.duration(Theme.motionNormal)
                                easing.type: Theme.easingStandard
                            }
                        }
                    }

                    Label {
                        anchors.centerIn: parent
                        width: parent.width - 48
                        visible: !pageHost.hasPage || pageLoader.status !== Loader.Ready
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.textSecondary
                        opacity: control.currentIndex === pageHost.index ? 1 : 0
                        text: typeof modelData === "string"
                              ? modelData
                              : (modelData.content || modelData.title || "")
                        Behavior on opacity {
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
    }

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
