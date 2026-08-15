import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// FlipView — Page carousel with optional navigation buttons.
//
//   FlipView {
//       id: flipView
//      model: pages
//   }
//
//   // --- API ---
//   // signals: onSelectionChanged, onCurrentIndexChangedByUser
//   // methods: goNext(), goPrevious()
//   // flipView.goNext()
//   // flipView.goPrevious()

T.Control {
    id: control

    // Selected index
    property alias currentIndex: swipe.currentIndex
    // Selected index alias
    property alias selectedIndex: swipe.currentIndex
    // Item count
    property alias count: swipe.count
    // Enable hover / click interaction
    property alias interactive: swipe.interactive
    // Show next/prev buttons
    property bool buttonsVisible: true
    // Alias of buttonsVisible
    property alias isButtonsVisible: control.buttonsVisible
    // always | onHover | hidden
    property string buttonVisibility: "onHover"
    // Show page indicator
    property bool isIndicatorVisible: true
    // Wrap children to next line
    property bool wrap: false
    // Default children / content slot
    default property alias contentData: swipe.contentData
    // Selection changed
    signal selectionChanged(int index)
    // Selection changed by user
    signal currentIndexChangedByUser(int index)

    implicitWidth: 360
    implicitHeight: 200
    padding: 0
    hoverEnabled: true
    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Flip view")
    Accessible.description: qsTr("Page %1 of %2").arg(swipe.currentIndex + 1).arg(swipe.count)

    readonly property bool _showButtons: buttonsVisible && buttonVisibility !== "hidden"
    readonly property bool _buttonsAlways: buttonVisibility === "always"

    // Navigate to the next page / item
    function goNext() {
        if (swipe.count <= 0)
            return
        var prev = swipe.currentIndex
        if (swipe.currentIndex < swipe.count - 1)
            swipe.incrementCurrentIndex()
        else if (wrap)
            swipe.currentIndex = 0
        if (swipe.currentIndex !== prev)
            currentIndexChangedByUser(swipe.currentIndex)
    }

    // Navigate to the previous page / item
    function goPrevious() {
        if (swipe.count <= 0)
            return
        var prev = swipe.currentIndex
        if (swipe.currentIndex > 0)
            swipe.decrementCurrentIndex()
        else if (wrap)
            swipe.currentIndex = swipe.count - 1
        if (swipe.currentIndex !== prev)
            currentIndexChangedByUser(swipe.currentIndex)
    }

    Connections {
        target: swipe
        // React to currentIndex changes
        function onCurrentIndexChanged() { control.selectionChanged(swipe.currentIndex) }
    }

    contentItem: Item {
        SwipeView {
            id: swipe
            anchors.fill: parent
            anchors.leftMargin: control._showButtons ? 40 : 0
            anchors.rightMargin: control._showButtons ? 40 : 0
            anchors.bottomMargin: control.isIndicatorVisible && swipe.count > 1 ? 28 : 0
            clip: true
        }

        RoundButton {
            id: prevBtn
            visible: control._showButtons
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            flat: true
            opacity: {
                if (!visible)
                    return 0
                if (control._buttonsAlways || control.hovered || prevBtn.hovered)
                    return enabled ? 1 : 0.4
                return 0
            }
            enabled: control.wrap || swipe.currentIndex > 0
            text: FluentIcons.ChevronLeft
            font.family: Theme.fontFamilyIcon
            Accessible.name: qsTr("Previous")
            onClicked: control.goPrevious()
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        RoundButton {
            id: nextBtn
            visible: control._showButtons
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            flat: true
            opacity: {
                if (!visible)
                    return 0
                if (control._buttonsAlways || control.hovered || nextBtn.hovered)
                    return enabled ? 1 : 0.4
                return 0
            }
            enabled: control.wrap || swipe.currentIndex < swipe.count - 1
            text: FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            Accessible.name: qsTr("Next")
            onClicked: control.goNext()
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        PipsPager {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            count: swipe.count
            currentIndex: swipe.currentIndex
            wrap: control.wrap
            previousButtonVisibility: "collapsed"
            nextButtonVisibility: "collapsed"
            visible: control.isIndicatorVisible && swipe.count > 1
            onCurrentIndexEdited: function (index) {
                swipe.currentIndex = index
                control.currentIndexChangedByUser(index)
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
