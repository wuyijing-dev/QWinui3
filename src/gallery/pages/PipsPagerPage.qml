import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — PipsPager.
//
// Page indicators with selectedIndex, keyboard nav, and WinUI previous/next visibility. API: docs/components/PipsPager.md

CatalogPage {
    title: qsTr("PipsPager")
    subtitle: qsTr("Page indicators — FlipView / SwipeView hosts, maxVisiblePips — docs/carousel-recipes.md.")

    ControlExample {
        headerText: qsTr("SwipeView host")
        qmlSource: "SwipeView + PipsPager two-way sync — docs/carousel-recipes.md Recipe B"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            SwipeView {
                id: swipeHost
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                clip: true
                Rectangle {
                    color: Theme.systemAttentionBg
                    Label { anchors.centerIn: parent; text: qsTr("A"); color: Theme.textPrimary }
                }
                Rectangle {
                    color: Theme.systemSuccessBg
                    Label { anchors.centerIn: parent; text: qsTr("B"); color: Theme.textPrimary }
                }
                Rectangle {
                    color: Theme.systemCautionBg
                    Label { anchors.centerIn: parent; text: qsTr("C"); color: Theme.textPrimary }
                }
            }
            PipsPager {
                Layout.alignment: Qt.AlignHCenter
                count: swipeHost.count
                selectedIndex: swipeHost.currentIndex
                onCurrentIndexEdited: function (index) { swipeHost.currentIndex = index }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Reduced motion")
        qmlSource: "Theme.reducedMotion — pip size/color Behaviors"
        SettingsToggleCard {
            Layout.fillWidth: true
            title: qsTr("Reduced motion")
            description: qsTr("Pip expand/collapse and nav button hover colors snap when enabled.")
            symbol: FluentIcons.AlignLeft
            checked: Theme.reducedMotion
            onToggled: Theme.reducedMotion = checked
        }
    }

    ControlExample {
        headerText: qsTr("With FlipView")
        qmlSource: "PipsPager {\n    count: flip.count\n    selectedIndex: flip.currentIndex\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            FlipView {
                id: flip
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                wrap: true
                Rectangle {
                    color: Theme.bgAcrylic
                    Label { anchors.centerIn: parent; text: "1"; color: Theme.textPrimary }
                }
                Rectangle {
                    color: Theme.bgAcrylic
                    Label { anchors.centerIn: parent; text: "2"; color: Theme.textPrimary }
                }
                Rectangle {
                    color: Theme.bgAcrylic
                    Label { anchors.centerIn: parent; text: "3"; color: Theme.textPrimary }
                }
                Rectangle {
                    color: Theme.bgAcrylic
                    Label { anchors.centerIn: parent; text: "4"; color: Theme.textPrimary }
                }
            }
            PipsPager {
                Layout.alignment: Qt.AlignHCenter
                count: flip.count
                selectedIndex: flip.currentIndex
                wrap: true
                previousButtonVisibility: "visible"
                nextButtonVisibility: "visible"
                onCurrentIndexEdited: function (index) {
                    flip.currentIndex = index
                }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Visible on pointer over")
        qmlSource: "PipsPager {\n    previousButtonVisibility: \"visibleOnPointerOver\"\n}"
        PipsPager {
            Layout.alignment: Qt.AlignHCenter
            count: 5
            selectedIndex: 2
            previousButtonVisibility: "visibleOnPointerOver"
            nextButtonVisibility: "visibleOnPointerOver"
        }
    }
    ControlExample {
        headerText: qsTr("MaxVisiblePips")
        qmlSource: "PipsPager {\n    numberOfPages: 12\n    maxVisiblePips: 5\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                text: qsTr("12 pages, window of 5 pips — use arrows or click dots")
                color: Theme.textSecondary
            }
            PipsPager {
                id: manyPips
                Layout.alignment: Qt.AlignHCenter
                numberOfPages: 12
                selectedIndex: 0
                maxVisiblePips: 5
            }
            Label {
                text: qsTr("Page %1 / %2").arg(manyPips.selectedIndex + 1).arg(manyPips.numberOfPages)
                color: Theme.textSecondary
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
