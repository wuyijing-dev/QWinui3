import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery home — WinUI 3 Gallery–style layout:
// hero + horizontal featured strip + Recent/Favorites + visited / added grids.

CatalogPage {
    id: page
    title: ""
    pagePadding: 0

    signal openControl(var item)
    signal openSettings()

    property int homeTab: 0 // 0 = Recent, 1 = Favorites
    property bool cardEffectsReady: false

    Component.onCompleted: Qt.callLater(function () { page.cardEffectsReady = true })

    readonly property var featuredModel: {
        GalleryLanguage.currentLocale
        return [
            {
                title: qsTr("Getting started"),
                description: qsTr("Copy-ready starters — gallery-shell and first-app recipes."),
                icon: FluentIcons.PageList,
                tint: "#0F7B0F",
                tintBg: Theme.dark ? "#393D1B" : "#DFF6DD",
                action: "templates"
            },
            {
                title: qsTr("Design"),
                description: qsTr("Light/dark theme, accent, density, and motion preferences."),
                icon: FluentIcons.Color,
                tint: "#8764B8",
                tintBg: Theme.dark ? "#3A2F4A" : "#F2EDF9",
                action: "settings"
            },
            {
                title: qsTr("App shells"),
                description: qsTr("Blank, left-nav, and menu + status application hosts."),
                icon: FluentIcons.OpenInNewWindow,
                tint: "#005FB8",
                tintBg: Theme.dark ? "#1B2A3A" : "#E8F1FA",
                action: "shells"
            },
            {
                title: qsTr("Style spot-check"),
                description: qsTr("Button, field, and pointer baseline for Fluent chrome."),
                icon: FluentIcons.Checkbox,
                tint: "#CA5010",
                tintBg: Theme.dark ? "#3A2A1B" : "#FFF0E4",
                action: "style"
            },
            {
                title: qsTr("Charts & gauges"),
                description: qsTr("Dashboard charts and interactive gauge samples."),
                icon: FluentIcons.AreaChart,
                tint: "#0078D4",
                tintBg: Theme.dark ? "#1A2E3A" : "#E5F3FB",
                action: "charts"
            },
            {
                title: qsTr("Accessibility"),
                description: qsTr("Focus, contrast, reduced motion, and screen-reader recipes."),
                icon: FluentIcons.EaseOfAccess,
                tint: "#038387",
                tintBg: Theme.dark ? "#1B3333" : "#E0F5F5",
                action: "a11y"
            }
        ]
    }

    readonly property int _historyTick: GalleryHistory.recentIds.length
                                        + GalleryHistory.favoriteIds.length
                                        + homeTab

    readonly property var listModel: {
        var _ = _historyTick
        GalleryLanguage.currentLocale
        return homeTab === 0 ? GalleryHistory.recentControls()
                             : GalleryHistory.favoriteControls()
    }

    readonly property real featuredCardWidth: 208
    readonly property real featuredCardHeight: 168
    readonly property real featuredGap: 12

    function activateFeatured(action) {
        if (action === "settings") {
            page.openSettings()
            return
        }
        var map = {
            "shells": "WindowParadigmPage",
            "templates": "ExamplesTemplatesPage",
            "style": "StyleSpotCheckPage",
            "charts": "ChartsPage",
            "a11y": "AccessibilityPage"
        }
        var name = map[action] || ""
        var item = ControlCatalog.findByComponent(name)
        if (item)
            page.openControl(item)
    }

    function itemCardWidth(available) {
        if (available >= 960)
            return (available - 36) / 4
        if (available >= 720)
            return (available - 24) / 3
        if (available >= 480)
            return (available - 12) / 2
        return available
    }

    function scrollFeatured(dir) {
        var step = page.featuredCardWidth + page.featuredGap
        var target = Math.max(0, Math.min(featuredList.contentWidth - featuredList.width,
                                          featuredList.contentX + dir * step * 2))
        if (Theme.reducedMotion) {
            featuredList.contentX = target
            return
        }
        featuredScrollAnim.to = target
        featuredScrollAnim.restart()
    }

    NumberAnimation {
        id: featuredScrollAnim
        target: featuredList
        property: "contentX"
        duration: Theme.duration(Theme.motionNormal)
        easing.type: Theme.easingStandard
    }

    // --- Hero ---
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: heroCol.implicitHeight + Theme.spacingSection
        clip: false

        Item {
            id: heroWash
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 320
            z: -1

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: Theme.dark ? "#1A2330" : "#E9F2FA"
                    }
                    GradientStop {
                        position: 0.5
                        color: Theme.dark ? "#1E2228" : "#F4F1F8"
                    }
                    GradientStop {
                        position: 1
                        color: Theme.bgLayer
                    }
                }
            }

            // Soft abstract shapes (WinUI home wash)
            Rectangle {
                width: 380
                height: 380
                radius: 48
                rotation: -18
                x: parent.width - width * 0.42
                y: -160
                color: Theme.dark ? "#2A4A72" : "#A8C8EC"
                opacity: Theme.dark ? 0.35 : 0.45
            }
            Rectangle {
                width: 260
                height: 260
                radius: 40
                rotation: 22
                x: parent.width - width * 0.55
                y: -40
                color: Theme.dark ? "#3D3A5C" : "#C9B8E8"
                opacity: Theme.dark ? 0.28 : 0.4
            }
            Rectangle {
                width: 180
                height: 180
                radius: 36
                rotation: -8
                x: parent.width - width * 0.9
                y: 60
                color: Theme.dark ? "#2E4A3A" : "#B8D4C8"
                opacity: Theme.dark ? 0.22 : 0.35
            }
        }

        ColumnLayout {
            id: heroCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: Theme.spacingSection
            anchors.rightMargin: Theme.spacingSection
            anchors.topMargin: Theme.spacingSection
            spacing: 2

            Text {
                text: qsTr("Qt Quick · Fluent controls")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                text: qsTr("QWinUI3 Gallery")
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontTitleLarge
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
        }
    }

    // --- Featured horizontal strip ---
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: page.featuredCardHeight + 8
        Layout.leftMargin: Theme.spacingSection
        Layout.rightMargin: Theme.spacingSection

        ListView {
            id: featuredList
            anchors.fill: parent
            orientation: ListView.Horizontal
            clip: true
            spacing: page.featuredGap
            boundsBehavior: Flickable.StopAtBounds
            model: page.featuredModel
            cacheBuffer: 480

            delegate: Item {
                id: featuredWrap
                required property var modelData
                width: page.featuredCardWidth
                height: page.featuredCardHeight

                Rectangle {
                    id: featuredCard
                    anchors.fill: parent
                    radius: Theme.cornerCard
                    color: Theme.bgCard
                    border.width: 1
                    border.color: Theme.strokeCard
                    scale: featuredHover.hovered ? 1.015 : 1

                    Behavior on scale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingStandard
                        }
                    }

                    layer.enabled: page.cardEffectsReady && !Theme.reducedMotion && !page.viewMoving
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowOpacity: featuredHover.hovered
                                       ? (Theme.dark ? 0.28 : 0.14)
                                       : (Theme.dark ? 0.18 : 0.08)
                        shadowColor: "#000000"
                        shadowVerticalOffset: featuredHover.hovered ? 6 : 3
                        blurMax: 20
                        autoPaddingEnabled: true
                    }

                    HoverHandler { id: featuredHover }
                    TapHandler {
                        onTapped: page.activateFeatured(modelData.action)
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            radius: 8
                            color: modelData.tintBg

                            Text {
                                anchors.centerIn: parent
                                text: modelData.icon
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 20
                                color: modelData.tint
                            }
                        }

                        Text {
                            text: modelData.title
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontBody
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: modelData.description || ""
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontCaption
                            color: Theme.textSecondary
                            wrapMode: Text.Wrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: !!(modelData.description)
                        }

                        Text {
                            Layout.alignment: Qt.AlignRight
                            text: FluentIcons.OpenInNewWindow
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 12
                            color: Theme.textSecondary
                            opacity: 0.65
                        }
                    }
                }
            }
        }

        // Peek / scroll affordance (WinUI chevron)
        RoundButton {
            visible: featuredList.contentWidth > featuredList.width + 8
                     && featuredList.contentX + featuredList.width < featuredList.contentWidth - 4
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 4
            width: 36
            height: 36
            text: FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            Accessible.name: qsTr("Scroll featured cards")
            onClicked: page.scrollFeatured(1)
        }
        RoundButton {
            visible: featuredList.contentWidth > featuredList.width + 8
                     && featuredList.contentX > 4
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 4
            width: 36
            height: 36
            text: FluentIcons.ChevronLeft
            font.family: Theme.fontFamilyIcon
            Accessible.name: qsTr("Scroll featured cards back")
            onClicked: page.scrollFeatured(-1)
        }
    }

    // --- Recent / Favorites pills ---
    RowLayout {
        Layout.topMargin: Theme.spacingLoose
        Layout.leftMargin: Theme.spacingSection
        Layout.rightMargin: Theme.spacingSection
        spacing: 8

        AbstractButton {
            id: recentPill
            checkable: true
            checked: page.homeTab === 0
            implicitHeight: 32
            leftPadding: 14
            rightPadding: 14
            onClicked: page.homeTab = 0

            contentItem: RowLayout {
                spacing: 8
                Text {
                    text: FluentIcons.Clock
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 14
                    color: recentPill.checked ? Theme.textOnAccent : Theme.textPrimary
                }
                Text {
                    text: qsTr("Recent")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    font.weight: Theme.fontWeightSemiBold
                    color: recentPill.checked ? Theme.textOnAccent : Theme.textPrimary
                }
            }
            background: Rectangle {
                radius: height / 2
                color: recentPill.checked ? Theme.accent
                     : (recentPill.hovered ? Theme.fillSubtle : "transparent")
                border.width: recentPill.checked ? 0 : 1
                border.color: Theme.strokeControl
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }
        }

        AbstractButton {
            id: favPill
            checkable: true
            checked: page.homeTab === 1
            implicitHeight: 32
            leftPadding: 14
            rightPadding: 14
            onClicked: page.homeTab = 1

            contentItem: RowLayout {
                spacing: 8
                Text {
                    text: FluentIcons.Favorite
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 14
                    color: favPill.checked ? Theme.textOnAccent : Theme.textPrimary
                }
                Text {
                    text: qsTr("Favorites")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    font.weight: Theme.fontWeightSemiBold
                    color: favPill.checked ? Theme.textOnAccent : Theme.textPrimary
                }
            }
            background: Rectangle {
                radius: height / 2
                color: favPill.checked ? Theme.accent
                     : (favPill.hovered ? Theme.fillSubtle : "transparent")
                border.width: favPill.checked ? 0 : 1
                border.color: Theme.strokeControl
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }
        }
    }

    // --- Recently visited / Favorites ---
    ColumnLayout {
        Layout.fillWidth: true
        Layout.topMargin: Theme.spacingLoose
        Layout.leftMargin: Theme.spacingSection
        Layout.rightMargin: Theme.spacingSection
        spacing: Theme.spacingLoose

        Text {
            text: page.homeTab === 0 ? qsTr("Recently visited")
                                     : qsTr("Favorites")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSubtitle
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
        }

        Text {
            visible: page.listModel.length === 0
            text: page.homeTab === 0
                  ? qsTr("Visit a control sample to see it here.")
                  : qsTr("Star a control card to add it to Favorites.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }

        Flow {
            id: recentFlow
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Repeater {
                model: page._historyTick >= 0 ? page.listModel : []

                delegate: Item {
                    id: itemWrap
                    required property var modelData
                    width: page.itemCardWidth(recentFlow.width)
                    height: 72

                    Rectangle {
                        id: itemCard
                        anchors.fill: parent
                        radius: Theme.cornerCard
                        color: itemHover.hovered ? Theme.bgCardElevated : Theme.bgCard
                        border.width: 1
                        border.color: Theme.strokeCard

                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation {
                                duration: Theme.duration(Theme.motionFast)
                            }
                        }

                        layer.enabled: page.cardEffectsReady && !Theme.reducedMotion && !page.viewMoving
                        layer.effect: MultiEffect {
                            shadowEnabled: true
                            shadowOpacity: Theme.dark ? 0.16 : 0.07
                            shadowColor: "#000000"
                            shadowVerticalOffset: 2
                            blurMax: 12
                            autoPaddingEnabled: true
                        }

                        HoverHandler { id: itemHover }
                        TapHandler {
                            onTapped: page.openControl(modelData)
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 8
                            anchors.topMargin: 12
                            anchors.bottomMargin: 12
                            spacing: 12

                            Text {
                                text: modelData.icon
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 22
                                color: Theme.accent
                                Layout.alignment: Qt.AlignVCenter
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text {
                                    text: modelData.title
                                    font.pixelSize: Theme.fontBody
                                    font.weight: Theme.fontWeightSemiBold
                                    color: Theme.textPrimary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: modelData.description || ""
                                    font.pixelSize: Theme.fontCaption
                                    color: Theme.textSecondary
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                    Layout.fillWidth: true
                                    visible: !!(modelData.description)
                                }
                            }

                            AbstractButton {
                                id: starBtn
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 32
                                Layout.alignment: Qt.AlignVCenter
                                hoverEnabled: true
                                readonly property bool favorited: GalleryHistory.favoriteIds.indexOf(modelData.component) >= 0
                                onClicked: GalleryHistory.toggleFavorite(modelData.component)

                                contentItem: Text {
                                    anchors.centerIn: parent
                                    text: starBtn.favorited ? FluentIcons.FavoriteStarFill : FluentIcons.Favorite
                                    font.family: Theme.fontFamilyIcon
                                    font.pixelSize: 14
                                    color: starBtn.favorited ? Theme.systemCaution
                                                             : Theme.textSecondary
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                background: Rectangle {
                                    radius: 4
                                    color: starBtn.hovered ? Theme.fillSubtle : "transparent"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
}
