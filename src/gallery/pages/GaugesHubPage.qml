import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Gauges (full inline deferred demos). Stable: RingGauge + KpiTile.

CatalogPage {
    id: page
    title: qsTr("Gauges")
    subtitle: qsTr("Deferred toolkit gauges — product apps use RingGauge / KpiTile. docs/charts.md")

    ControlExample {
        headerText: qsTr("Stable vs deferred")
        qmlSource: "RingGauge · KpiTile · ChartCard\ndocs/dashboard-compose-decision.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Shipping dashboards stay on RingGauge and KpiTile. Each gauge demo below is the full Gallery page — compare styling or copy a one-off, not for new stable API names.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    GalleryHubSection {
        title: qsTr("RingGauge")
        description: qsTr("Stable radial gauge — preferred for product dashboards.")
        RingGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("KpiTile")
        description: qsTr("Stable KPI tile with delta and spark trend.")
        KpiTilePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("MeterBar")
        description: qsTr("Horizontal meter bar gauge.")
        MeterBarPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("RadialGauge")
        description: qsTr("Deferred radial gauge variant.")
        RadialGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("LinearGauge")
        description: qsTr("Deferred linear gauge variant.")
        LinearGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ArcGauge")
        description: qsTr("Arc segment gauge.")
        ArcGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("SegmentedGauge")
        description: qsTr("Multi-segment arc gauge.")
        SegmentedGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ZoneGauge")
        description: qsTr("Color-zone radial gauge.")
        ZoneGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("TankGauge")
        description: qsTr("Fill-level tank visualization.")
        TankGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ThermometerGauge")
        description: qsTr("Vertical thermometer style gauge.")
        ThermometerGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("CompassGauge")
        description: qsTr("Compass heading indicator.")
        CompassGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("VuMeter")
        description: qsTr("Audio VU meter style gauge.")
        VuMeterPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("DualRingGauge")
        description: qsTr("Concentric dual ring gauge.")
        DualRingGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("LedRingGauge")
        description: qsTr("LED segment ring gauge.")
        LedRingGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("PressureGauge")
        description: qsTr("Pressure dial gauge.")
        PressureGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("QuarterGauge")
        description: qsTr("Quarter-arc gauge.")
        QuarterGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("DigitGauge")
        description: qsTr("Seven-segment digit gauge.")
        DigitGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("CylinderGauge")
        description: qsTr("Cylinder fill gauge.")
        CylinderGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("TachometerGauge")
        description: qsTr("Engine RPM tachometer.")
        TachometerGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("SpeedometerGauge")
        description: qsTr("Vehicle speedometer dial.")
        SpeedometerGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("BatteryGauge")
        description: qsTr("Battery level gauge.")
        BatteryGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("FuelGauge")
        description: qsTr("Fuel level gauge.")
        FuelGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("CoolantGauge")
        description: qsTr("Engine coolant temperature gauge.")
        CoolantGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("BoostGauge")
        description: qsTr("Turbo boost pressure gauge.")
        BoostGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("VoltageGauge")
        description: qsTr("Electrical voltage gauge.")
        VoltageGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("GearIndicator")
        description: qsTr("Transmission gear indicator.")
        GearIndicatorPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("OdometerGauge")
        description: qsTr("Rolling odometer display.")
        OdometerGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("TelltaleBar")
        description: qsTr("Warning telltale indicator bar.")
        TelltaleBarPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("TpmsGauge")
        description: qsTr("Tire pressure monitoring gauge.")
        TpmsGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("GMeterGauge")
        description: qsTr("Lateral G-force meter.")
        GMeterGaugePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("AutomotiveCluster")
        description: qsTr("Combined automotive instrument cluster.")
        AutomotiveClusterPage { hubEmbed: true; width: parent.width }
    }
}
