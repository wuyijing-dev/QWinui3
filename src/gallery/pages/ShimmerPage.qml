import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Shimmer.

CatalogPage {
    title: qsTr("Shimmer")
    subtitle: qsTr("Skeleton placeholders with direction (Horizontal/Vertical), isActive, and shapes.")

    ControlExample {
        headerText: qsTr("Card skeleton")
        qmlSource: "Shimmer { shape: Shimmer.Circle; isActive: true }"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Shimmer {
                shape: Shimmer.Circle
                implicitWidth: 48
                implicitHeight: 48
                isActive: true
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Shimmer { Layout.fillWidth: true; implicitHeight: 14; shape: Shimmer.TextLine }
                Shimmer { Layout.fillWidth: true; Layout.preferredWidth: parent.width * 0.7; implicitHeight: 12; shape: Shimmer.TextLine }
                Shimmer {
                    Layout.fillWidth: true
                    implicitHeight: 64
                    cornerRadius: Theme.cornerCard
                    durationMs: 1000
                    direction: Qt.Vertical
                    baseColor: Theme.fillSubtleSecondary
                }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Skeleton host")
        qmlSource: "Skeleton { rows: 4; showAvatar: true; active: true }"
        Skeleton {
            Layout.fillWidth: true
            rows: 4
            showAvatar: true
            active: true
        }
    }
    ControlExample {
        headerText: qsTr("Paused")
        qmlSource: "Shimmer { isActive: false }"
        Shimmer {
            Layout.fillWidth: true
            implicitHeight: 20
            isActive: false
        }
    }
}
