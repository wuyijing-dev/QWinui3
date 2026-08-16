import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// FlipView — Page carousel with optional navigation buttons.
//
//   FlipView {
//       id: flipView
//       model: pages
//   }
//
//   // --- API ---
//   // signals: onSelectionChanged, onCurrentIndexChangedByUser
//   // methods: goNext(), goPrevious()
//   // flipView.goNext()
//   // flipView.goPrevious()
//
// @notes
//   Paged swipe view; currentIndex + buttonsVisible / isIndicatorVisible.
//   orientation: Qt.Horizontal | Qt.Vertical (WinUI Orientation).

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
    // WinUI Orientation — Qt.Horizontal (default) or Qt.Vertical
    property int orientation: Qt.Horizontal
    readonly property bool _vertical: orientation === Qt.Vertical
    // Currently selected page item
    readonly property var selectedItem: {
        if (swipe.currentIndex < 0 || swipe.currentIndex >= swipe.count)
            return null
        return swipe.itemAt(swipe.currentIndex)
    }
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
            anchors.leftMargin: !control._vertical && control._showButtons ? 40 : 0
            anchors.rightMargin: control._vertical
                                 ? (control.isIndicatorVisible && swipe.count > 1 ? 28 : 0)
                                 : (control._showButtons ? 40 : 0)
            anchors.topMargin: control._vertical && control._showButtons ? 40 : 0
            anchors.bottomMargin: control._vertical
                                  ? (control._showButtons ? 40 : 0)
                                  : (control.isIndicatorVisible && swipe.count > 1 ? 28 : 0)
            clip: true
            orientation: control.orientation
        }

        RoundButton {
            id: prevBtn
            visible: control._showButtons
            anchors.left: control._vertical ? undefined : parent.left
            anchors.leftMargin: control._vertical ? 0 : 4
            anchors.horizontalCenter: control._vertical ? parent.horizontalCenter : undefined
            anchors.top: control._vertical ? parent.top : undefined
            anchors.topMargin: control._vertical ? 4 : 0
            anchors.verticalCenter: control._vertical ? undefined : parent.verticalCenter
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
            text: control._vertical ? FluentIcons.ChevronUp : FluentIcons.ChevronLeft
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
            anchors.right: control._vertical ? undefined : parent.right
            anchors.rightMargin: control._vertical ? 0 : 4
            anchors.horizontalCenter: control._vertical ? parent.horizontalCenter : undefined
            anchors.bottom: control._vertical ? parent.bottom : undefined
            anchors.bottomMargin: control._vertical ? 4 : 0
            anchors.verticalCenter: control._vertical ? undefined : parent.verticalCenter
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
            text: control._vertical ? FluentIcons.ChevronDown : FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            Accessible.name: qsTr("Next")
            onClicked: control.goNext()
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        PipsPager {
            anchors.horizontalCenter: control._vertical ? undefined : parent.horizontalCenter
            anchors.verticalCenter: control._vertical ? parent.verticalCenter : undefined
            anchors.right: control._vertical ? parent.right : undefined
            anchors.rightMargin: control._vertical ? 4 : 0
            anchors.bottom: control._vertical ? undefined : parent.bottom
            anchors.bottomMargin: control._vertical ? 0 : 4
            count: swipe.count
            currentIndex: swipe.currentIndex
            wrap: control.wrap
            orientation: control._vertical ? Qt.Vertical : Qt.Horizontal
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
