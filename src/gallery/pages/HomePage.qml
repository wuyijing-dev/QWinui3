import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Getting started.
//
// Custom hero wash; intentionally not using CatalogPage title/subtitle (empty title hides PageHeader).

CatalogPage {
    id: page
    title: ""
    pagePadding: 0

    signal openControl(var item)
    signal openSettings()

    property int homeTab: 0 // 0 = Recent, 1 = Favorites

    readonly property var featuredModel: [
        {
            title: qsTr("Getting started"),
            description: qsTr("Explore Fluent controls and try interactive samples."),
            icon: "\uE8F1",
            tint: "#0F7B0F",
            tintBg: Theme.dark ? "#393D1B" : "#DFF6DD",
            action: "button"
        },
        {
            title: qsTr("Window shells"),
            description: qsTr("Blank, left-nav, and menu + status application hosts."),
            icon: "\uE8A7",
            tint: "#005FB8",
            tintBg: Theme.dark ? "#272727" : "#F3F9FD",
            action: "shells"
        },
        {
            title: qsTr("Design"),
            description: qsTr("Switch light/dark theme and motion preferences."),
            icon: "\uE790",
            tint: "#8764B8",
            tintBg: Theme.dark ? "#3A2F4A" : "#F2EDF9",
            action: "settings"
        }
    ]

    readonly property int _historyTick: GalleryHistory.recentIds.length
                                        + GalleryHistory.favoriteIds.length
                                        + homeTab

    readonly property var listModel: {
        var _ = _historyTick
        return homeTab === 0 ? GalleryHistory.recentControls()
                             : GalleryHistory.favoriteControls()
    }

    function activateFeatured(action) {
        if (action === "settings") {
            page.openSettings()
            return
        }
        if (action === "shells") {
            var shells = ControlCatalog.findByComponent("WindowParadigmPage")
            if (shells)
                page.openControl(shells)
            return
        }
        if (action === "new") {
            var added = ControlCatalog.recentlyAdded(1)
            if (added.length)
                page.openControl(added[0])
            return
        }
        var btn = ControlCatalog.findByComponent("ButtonPage")
        if (btn)
            page.openControl(btn)
    }

    function cardWidth(available) {
        if (available >= 980)
            return (available - 24) / 3
        if (available >= 640)
            return (available - 12) / 2
        return available
    }

    function itemCardWidth(available) {
        if (available >= 900)
            return (available - 24) / 3
        if (available >= 560)
            return (available - 12) / 2
        return available
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: heroHeader.implicitHeight + Theme.spacingSection
        clip: false

        Item {
            id: heroWash
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 360
            z: -1

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: Theme.dark ? "#1B2430" : "#E8F1FA"
                    }
                    GradientStop {
                        position: 0.55
                        color: Theme.dark ? "#222018" : "#F3F0E8"
                    }
                    GradientStop {
                        position: 1
                        color: Theme.bgLayer
                    }
                }
            }

            Rectangle {
                width: 420
                height: 420
                radius: 210
                x: parent.width * 0.55
                y: -140
                color: Theme.dark ? "#22406A" : "#B7D4F0"
                opacity: Theme.dark ? 0.35 : 0.55
            }
            Rectangle {
                width: 280
                height: 280
                radius: 140
                x: parent.width * 0.72
                y: 40
                color: Theme.dark ? "#3A4A28" : "#D6E8C8"
                opacity: Theme.dark ? 0.3 : 0.5
            }
            Rectangle {
                width: 200
                height: 200
                radius: 100
                x: parent.width * 0.48
                y: 100
                color: Theme.dark ? "#4A3A5A" : "#E4D8F2"
                opacity: Theme.dark ? 0.25 : 0.45
            }
        }

        ColumnLayout {
            id: heroHeader
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: Theme.spacingSection
            anchors.rightMargin: Theme.spacingSection
            anchors.topMargin: Theme.spacingSection
            spacing: 4

            Text {
                text: qsTr("Qt 6.8 · Fluent · App shells")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
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

    // Featured cards
    Flow {
        id: featuredFlow
        Layout.fillWidth: true
        Layout.leftMargin: Theme.spacingSection
        Layout.rightMargin: Theme.spacingSection
        spacing: Theme.spacingLoose

        Repeater {
            model: page.featuredModel

            delegate: Item {
                id: featuredWrap
                required property var modelData
                width: page.cardWidth(featuredFlow.width)
                height: 156

                Rectangle {
                    id: featuredCard
                    anchors.fill: parent
                    radius: Theme.cornerCard
                    color: Theme.bgCard
                    border.width: 1
                    border.color: Theme.strokeCard
                    scale: featuredHover.hovered ? 1.01 : 1

                    Behavior on scale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingStandard
                        }
                    }

                    layer.enabled: true
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
                        }
                        Text {
                            text: modelData.description
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontCaption
                            color: Theme.textSecondary
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        Item { Layout.fillWidth: true; Layout.preferredHeight: 1 }

                        Text {
                            Layout.alignment: Qt.AlignRight
                            text: "\uE8A7"
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 14
                            color: Theme.textSecondary
                            opacity: 0.7
                        }
                    }
                }
            }
        }
    }

    RowLayout {
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
                    text: "\uE823"
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
                    text: "\uE734"
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

    ColumnLayout {
        Layout.fillWidth: true
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

                        layer.enabled: true
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
                                    text: modelData.description
                                    font.pixelSize: Theme.fontCaption
                                    color: Theme.textSecondary
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                    Layout.fillWidth: true
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
                                    text: starBtn.favorited ? "\uE735" : "\uE734"
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

    ColumnLayout {
        Layout.fillWidth: true
        Layout.leftMargin: Theme.spacingSection
        Layout.rightMargin: Theme.spacingSection
        spacing: Theme.spacingLoose

        Text {
            text: qsTr("Recently added or updated")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSubtitle
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
        }

        Flow {
            id: addedFlow
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Repeater {
                model: ControlCatalog.recentlyAdded(9)

                delegate: Item {
                    id: addedWrap
                    required property var modelData
                    width: page.itemCardWidth(addedFlow.width)
                    height: 72

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.cornerCard
                        color: addedHover.hovered ? Theme.bgCardElevated : Theme.bgCard
                        border.width: 1
                        border.color: Theme.strokeCard

                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation {
                                duration: Theme.duration(Theme.motionFast)
                            }
                        }

                        layer.enabled: true
                        layer.effect: MultiEffect {
                            shadowEnabled: true
                            shadowOpacity: Theme.dark ? 0.16 : 0.07
                            shadowColor: "#000000"
                            shadowVerticalOffset: 2
                            blurMax: 12
                            autoPaddingEnabled: true
                        }

                        HoverHandler { id: addedHover }
                        TapHandler {
                            onTapped: page.openControl(modelData)
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 12

                            Text {
                                text: modelData.icon
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 22
                                color: Theme.accent
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
                                    text: modelData.description
                                    font.pixelSize: Theme.fontCaption
                                    color: Theme.textSecondary
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                    Layout.fillWidth: true
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
