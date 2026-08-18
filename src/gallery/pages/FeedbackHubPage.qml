import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Feedback surfaces (full inline demos). docs/feedback.md

CatalogPage {
    id: page
    title: qsTr("Feedback surfaces")
    subtitle: qsTr("InfoBar / Toast / TeachingTip / progress — docs/feedback.md (2.27).")

    ControlExample {
        headerText: qsTr("When to use which")
        qmlSource: "InfoBar · ToastHost · TeachingTip · ProgressRing\ndocs/feedback.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("InfoBar for in-page durable status (stack with InfoBarHost). ToastHost for transient queued toasts. TeachingTip for coach marks. ProgressRing / ProgressBar for determinate work — not a toast substitute. Blocking confirms → ContentDialog.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    GalleryHubSection {
        title: qsTr("InfoBar")
        description: qsTr("Inline status strip with severity, title, message, and actions.")
        InfoBarPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("InfoBarHost")
        description: qsTr("Stack multiple InfoBars with dismiss and spacing.")
        InfoBarHostPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Toast")
        description: qsTr("Queued toasts on the window overlay; corner placement and severity helpers.")
        ToastPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ToastHost")
        description: qsTr("Host API: info / success / warning / error with queue and max visible.")
        ToastHostPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("TeachingTip")
        description: qsTr("Coach marks anchored to controls with light dismiss.")
        TeachingTipPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Onboarding coach")
        description: qsTr("Multi-step coach sequence for first-run experiences.")
        OnboardingCoachPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("InfoBar + TeachingTip recipe")
        description: qsTr("Combine durable InfoBar with contextual TeachingTip.")
        InfoTeachingRecipePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ProgressRing")
        description: qsTr("Indeterminate and determinate ring progress.")
        ProgressRingPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ProgressBar")
        description: qsTr("Horizontal bar progress with label and value.")
        ProgressBarPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("BusyIndicator")
        description: qsTr("Inline spinner for short waits.")
        BusyIndicatorPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("InfoBadge")
        description: qsTr("Counts / status dots on icons and labels.")
        InfoBadgePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("StatusDot")
        description: qsTr("Presence / availability dot indicator.")
        StatusDotPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Shimmer")
        description: qsTr("Skeleton loading placeholder animation.")
        ShimmerPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("EmptyState")
        description: qsTr("Zero-data placeholder with icon, title, and action.")
        EmptyStatePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("StatusBar")
        description: qsTr("Bottom status strip with text, progress, and slots.")
        StatusBarPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ContentDialog")
        description: qsTr("Modal confirms, queues, and keyboard defaults.")
        ContentDialogPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Notification center")
        description: qsTr("Grouped notification list with read / dismiss actions.")
        NotificationCenterPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("NotificationBridge")
        description: qsTr("Bridge OS notifications into in-app center.")
        NotificationBridgePage { hubEmbed: true; width: parent.width }
    }
}
