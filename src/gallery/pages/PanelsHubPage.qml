import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Panels & grids (full inline demos).

CatalogPage {
    id: page
    title: qsTr("Panels & grids")
    subtitle: qsTr("WrapPanel · UniformGrid · DockPanel · RelativePanel · StackPanel")

    ControlExample {
        headerText: qsTr("Panel types")
        qmlSource: "StackPanel · WrapPanel · UniformGrid · DockPanel · RelativePanel"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Layout primitives for stacking, wrapping, docking, and relative positioning. Each demo below is the full Gallery page.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    GalleryHubSection {
        title: qsTr("StackPanel")
        description: qsTr("Vertical or horizontal stacking with spacing.")
        StackPanelPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("WrapPanel")
        description: qsTr("Flow layout that wraps to the next row.")
        WrapPanelPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("UniformGrid")
        description: qsTr("Equal-size cells in a grid.")
        UniformGridPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("DockPanel")
        description: qsTr("Dock children to edges; last child fills remaining space.")
        DockPanelPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("RelativePanel")
        description: qsTr("Position elements relative to siblings or anchors.")
        RelativePanelPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ItemsWrapGrid")
        description: qsTr("ItemsControl with wrap grid panel.")
        ItemsWrapGridPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("SwitchPresenter")
        description: qsTr("Switch between child panels with transitions.")
        SwitchPresenterPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("HeaderedContentControl")
        description: qsTr("Header + content chrome for grouped UI.")
        HeaderedContentControlPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("AcrylicSurface")
        description: qsTr("Frosted acrylic background surface.")
        AcrylicSurfacePage { hubEmbed: true; width: parent.width }
    }
}
