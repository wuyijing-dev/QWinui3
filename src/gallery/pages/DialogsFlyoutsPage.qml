import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Dialogs & flyouts (full inline demos). docs/dialogs-flyouts.md

CatalogPage {
    id: page
    title: qsTr("Dialogs & flyouts")
    subtitle: qsTr("ContentDialog queue · Flyout · TeachingTip · Drawer. docs/dialogs-flyouts.md (1.48).")

    ControlExample {
        headerText: qsTr("When to use which (1.16 / 1.37 / 1.48)")
        qmlSource: "ContentDialog · Flyout · TeachingTip · Drawer"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("ContentDialog (+ ContentDialogQueue) for confirms and multi-step save/export chains. Flyout for short contextual UI. TeachingTip for coach marks. Drawer for edge navigation. MenuFlyout for action lists — see Commands hub.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Queue busy=%1 · pendingCount=%2")
                    .arg(ContentDialogQueue.busy)
                    .arg(ContentDialogQueue.pendingCount)
            }
        }
    }

    GalleryHubSection {
        title: qsTr("ContentDialog")
        description: qsTr("Modal confirms with primary / close buttons and keyboard defaults.")
        ContentDialogPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Flyout")
        description: qsTr("Lightweight anchored popup for short contextual UI.")
        FlyoutPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("TeachingTip")
        description: qsTr("Coach marks with title, body, and action.")
        TeachingTipPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Onboarding coach")
        description: qsTr("Sequential coach marks for first-run flows.")
        OnboardingCoachPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Drawer")
        description: qsTr("Edge panel for navigation or tools.")
        DrawerPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Dialog")
        description: qsTr("Platform dialog wrapper patterns.")
        DialogPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ToolTip")
        description: qsTr("Hover / focus tooltips with delay.")
        ToolTipPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("InfoButton")
        description: qsTr("Info icon that opens a flyout or teaching tip.")
        InfoButtonPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("WebView2")
        description: qsTr("Embedded web content in flyouts / dialogs.")
        WebView2Page { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("InfoBar + TeachingTip recipe")
        description: qsTr("Pair durable InfoBar with contextual coach marks.")
        InfoTeachingRecipePage { hubEmbed: true; width: parent.width }
    }
}
