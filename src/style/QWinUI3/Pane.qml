import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Pane — Fluent styled Pane.
//
//   Pane {
//       id: pane
//       padding: Theme.paddingControlH
//       TextBlock {
//           width: pane.availableWidth   // required for Wrap / Elide
//           text: qsTr("Pane body")
//           textWrapping: "wrap"
//       }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Pane.
//   Long text (WinUI): size the Pane (Layout.fillWidth / width), then bind
//   child text width to availableWidth — TextWrapping / TextTrimming via TextBlock.

T.Pane {
    id: control


    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Pane")
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Theme.spacingLoose
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    // WinUI ContentPresenter stretch: give text-like children the content width
    // so TextWrapping / TextTrimming can apply once the Pane itself is sized.
    contentItem: Item {
        function _isTextLike(ch) {
            if (!ch)
                return false
            if (ch.textWrapping !== undefined || ch.textTrimming !== undefined)
                return true
            if (ch.wrapMode !== undefined || ch.elide !== undefined)
                return true
            // Plain Text / Label (not a nested Control)
            if (ch.text !== undefined && ch.font !== undefined && ch.contentItem === undefined)
                return true
            return false
        }

        function fitContentWidth() {
            if (width <= 0)
                return
            for (var i = 0; i < children.length; ++i) {
                var ch = children[i]
                if (!_isTextLike(ch))
                    continue
                if (ch.anchors && ch.anchors.fill)
                    continue
                if (ch.anchors && ch.anchors.left && ch.anchors.right
                        && ch.anchors.left.item && ch.anchors.right.item)
                    continue
                ch.width = width
            }
        }

        onWidthChanged: Qt.callLater(fitContentWidth)
        onChildrenChanged: Qt.callLater(fitContentWidth)
        Component.onCompleted: Qt.callLater(fitContentWidth)
    }

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerCard
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 2
        shadowOpacity: Theme.dark ? 0.22 : 0.08
    }
}
