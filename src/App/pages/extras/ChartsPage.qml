import QtQuick
import QtQuick.Layouts
import QtQml
import md3.Core
import md3.Extras.Charts 1.0

Item {
    id: root
    property string title: "Charts"
    signal backClicked()
    
    // Line Chart Style State
    property int lineStyleIndex: 0
    property var lineStyles: [LineChart.Linear, LineChart.Smooth, LineChart.Step]
    property var lineStyleNames: ["Linear", "Smooth", "Step"]
    property bool lineAreaEnabled: false

    property int lineExampleIndex: 0
    property int barExampleIndex: 0

    function _makeLineExampleButtons(selectedIndex) {
        return [
            { text: "Gaps", selected: selectedIndex === 0 },
            { text: "Series", selected: selectedIndex === 1 },
            { text: "Value X", selected: selectedIndex === 2 },
            { text: "Model", selected: selectedIndex === 3 },
            { text: "Function", selected: selectedIndex === 4 },
            { text: "Race", selected: selectedIndex === 5 },
            { text: "Timeline", selected: selectedIndex === 6 }
        ]
    }

    function _makeBarExampleButtons(selectedIndex) {
        return [
            { text: "Stacked", selected: selectedIndex === 0 },
            { text: "Percent", selected: selectedIndex === 1 },
            { text: "Model", selected: selectedIndex === 2 },
            { text: "Realtime", selected: selectedIndex === 3 }
        ]
    }
    
    property bool overlayLegend: true
    property bool overlayTooltip: true
    property bool overlayCrosshair: true
    property bool overlayAxes: true
    property bool randomEnabled: false
    property bool negativeModeEnabled: false
    property bool bigDataEnabled: false
    property bool pieDonut: false
    property bool pieExplode: true
    property int pieGapIndex: 0
    property var pieGapAngles: [0, 2, 6]
    property int pieStartIndex: 0
    property var pieStartAngles: [-90, 0, 90]
    property var pieLabels: ["A", "B", "C", "D", "E"]
    property var pieData: [30, 20, 15, 10, 25]
    property var pieColors: [Theme.color.primary, Theme.color.secondary, Theme.color.tertiary, Theme.color.error, Theme.color.primaryContainer]

    function _randInt(minV, maxV) {
        return Math.round(minV + Math.random() * (maxV - minV))
    }

    function _randomSeriesValues(count, minV, maxV) {
        var out = new Array(count)
        for (var i = 0; i < count; ++i) out[i] = _randInt(minV, maxV)
        return out
    }

    function randomizeCharts() {
        const n = root.bigDataEnabled ? 100000 : 10
        const minV = root.negativeModeEnabled ? -1000 : 100
        const maxV = root.negativeModeEnabled ? 1000 : 1200
        revenueSeries.data = _randomSeriesValues(n, minV, maxV)
        costSeries.data = _randomSeriesValues(n, root.negativeModeEnabled ? -800 : 50, root.negativeModeEnabled ? 800 : 900)
        forecastSeries.data = _randomSeriesValues(n, minV, maxV)
        onlineSeries.data = _randomSeriesValues(n, root.negativeModeEnabled ? -1000 : 100, root.negativeModeEnabled ? 1000 : 1200)
        retailSeries.data = _randomSeriesValues(n, root.negativeModeEnabled ? -800 : 80, root.negativeModeEnabled ? 800 : 1000)
        pieData = _randomSeriesValues(5, 5, 40)
    }

    Timer {
        interval: 800
        repeat: true
        running: root.randomEnabled
        onTriggered: root.randomizeCharts()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            
            // Back Button
            Item {
                width: 40
                height: 40
                
                Rectangle {
                    anchors.fill: parent
                    radius: 20
                    color: backMouse.containsMouse ? Theme.color.surfaceContainerHigh : "transparent"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "arrow_back"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                    }
                    
                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.backClicked()
                    }
                }
            }
            
            Text {
                text: "QSG Charts"
                font.family: Theme.typography.headlineSmall.family
                font.pixelSize: Theme.typography.headlineSmall.size
                font.weight: Theme.typography.headlineSmall.weight
                color: Theme.color.onSurfaceColor
            }
            
            Item { Layout.fillWidth: true }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: width
            contentHeight: contentLayout.implicitHeight
            clip: true
            
            ColumnLayout {
                id: contentLayout
                width: parent.width
                spacing: 20
                
                // Line Chart
                RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                
                Text { 
                    text: "Line Chart"
                    font.bold: true
                    color: Theme.color.onSurfaceColor
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Style: " + lineStyleNames[lineStyleIndex]
                    icon: "show_chart"
                    type: "filledTonal"
                    height: 32
                    horizontalPadding: 16
                    onClicked: {
                        lineStyleIndex = (lineStyleIndex + 1) % lineStyles.length
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Switch {
                        text: "Legend"
                        checked: root.overlayLegend
                        onClicked: root.overlayLegend = !root.overlayLegend
                    }
                    Switch {
                        text: "Tooltip"
                        checked: root.overlayTooltip
                        onClicked: root.overlayTooltip = !root.overlayTooltip
                    }
                    Switch {
                        text: "Crosshair"
                        checked: root.overlayCrosshair
                        onClicked: root.overlayCrosshair = !root.overlayCrosshair
                    }
                    Switch {
                        text: "Axes"
                        checked: root.overlayAxes
                        onClicked: root.overlayAxes = !root.overlayAxes
                    }
                    Switch {
                        text: "Area"
                        checked: root.lineAreaEnabled
                        onClicked: root.lineAreaEnabled = !root.lineAreaEnabled
                    }

                    Item { Layout.fillWidth: true }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Switch {
                        text: "Random"
                        checked: root.randomEnabled
                        onClicked: {
                            root.randomEnabled = !root.randomEnabled
                            if (root.randomEnabled) root.randomizeCharts()
                        }
                    }

                    Switch {
                        text: "negative"
                        checked: root.negativeModeEnabled
                        onClicked: {
                            root.negativeModeEnabled = !root.negativeModeEnabled
                            root.randomizeCharts()
                        }
                    }

                    Switch {
                        text: "100000 points test"
                        checked: root.bigDataEnabled
                        onClicked: {
                            root.bigDataEnabled = !root.bigDataEnabled
                            if (root.bigDataEnabled) root.randomEnabled = false
                            root.randomizeCharts()
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                Layout.margins: 20
                color: Theme.color.surfaceContainerHighest
                radius: 12
                clip: false

                ChartView {
                    anchors.fill: parent
                    anchors.margins: 12

                    legendEnabled: root.overlayLegend
                    tooltipEnabled: root.overlayTooltip
                    crosshairEnabled: root.overlayCrosshair
                    axesEnabled: root.overlayAxes
                    gridEnabled: true

                    LineChart {
                        color: Theme.color.primary
                        axisColor: Theme.color.onSurfaceColor
                        gridColor: Theme.color.outlineVariant
                        lineWidth: 4
                        lineStyle: lineStyles[lineStyleIndex]
                        areaEnabled: root.lineAreaEnabled
                        includeZeroInRange: root.negativeModeEnabled
                        downsampleMode: root.bigDataEnabled ? LineChart.LTTB : LineChart.None
                        maxRenderPoints: root.bigDataEnabled ? 2000 : 0

                        series: [
                            QtObject { id: revenueSeries; property string name: "Revenue"; property color color: Theme.color.primary; property var data: [120, 520, 310, 860, 430, 920, 210, 680, 1050, 440]; property bool visible: true },
                            QtObject { id: costSeries; property string name: "Cost"; property color color: Theme.color.secondary; property var data: [60, 320, 240, 560, 290, 650, 140, 480, 720, 310]; property bool visible: true },
                            QtObject { id: forecastSeries; property string name: "Forecast"; property color color: Theme.color.tertiary; property var data: [150, 460, 390, 810, 540, 880, 320, 610, 940, 580]; property bool visible: true }
                        ]
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                spacing: 16

                Text {
                    text: "Line Chart Examples"
                    font.bold: true
                    color: Theme.color.onSurfaceColor
                }

                Item { Layout.fillWidth: true }

                SegmentedButton {
                    id: lineExampleSeg
                    buttons: root._makeLineExampleButtons(root.lineExampleIndex)
                    onClicked: (index) => {
                        root.lineExampleIndex = index
                        lineExampleSeg.buttons = root._makeLineExampleButtons(index)
                    }
                }
            }

            Loader {
                id: lineExampleLoader
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                sourceComponent: {
                    if (root.lineExampleIndex === 0) return lineExampleChartData
                    if (root.lineExampleIndex === 1) return lineExampleSeries
                    if (root.lineExampleIndex === 2) return lineExampleValueX
                    if (root.lineExampleIndex === 3) return lineExampleModel
                    if (root.lineExampleIndex === 4) return lineExampleFunction
                    if (root.lineExampleIndex === 5) return lineExampleRace
                    return lineExampleTimeline
                }
            }

            Component {
                id: lineExampleChartData
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        ChartView {
                            anchors.fill: parent
                            anchors.margins: 12
                            legendEnabled: false
                            tooltipEnabled: root.overlayTooltip
                            crosshairEnabled: root.overlayCrosshair
                            axesEnabled: root.overlayAxes
                            gridEnabled: true
                            xLabels: ["0", "1", "2", "3", "4", "5", "6", "7"]
                            LineChart {
                                color: Theme.color.primary
                                lineWidth: 3
                                lineStyle: lineStyles[lineStyleIndex]
                                areaEnabled: root.lineAreaEnabled
                                chartData: [12, 18, null, 22, 14, null, 28, 20]
                            }
                        }
                    }
                }
            }

            Component {
                id: lineExampleSeries
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        ChartView {
                            anchors.fill: parent
                            anchors.margins: 12
                            legendEnabled: root.overlayLegend
                            tooltipEnabled: root.overlayTooltip
                            crosshairEnabled: root.overlayCrosshair
                            axesEnabled: root.overlayAxes
                            gridEnabled: true
                            xLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                            LineChart {
                                lineWidth: 3
                                lineStyle: lineStyles[lineStyleIndex]
                                areaEnabled: root.lineAreaEnabled
                                series: [
                                    QtObject { property string name: "A"; property color color: Theme.color.primary; property var data: [10, 12, 11, 16, 18, 19, 21]; property bool visible: true },
                                    QtObject { property string name: "B"; property color color: Theme.color.secondary; property var data: [8, 9, 7, 12, 11, 14, 15]; property bool visible: true }
                                ]
                            }
                        }
                    }
                }
            }

            Component {
                id: lineExampleValueX
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        ChartView {
                            anchors.fill: parent
                            anchors.margins: 12
                            legendEnabled: root.overlayLegend
                            tooltipEnabled: root.overlayTooltip
                            crosshairEnabled: root.overlayCrosshair
                            axesEnabled: root.overlayAxes
                            gridEnabled: true
                            xLabelFormatter: function(x) { return Number(x).toFixed(0) }
                            LineChart {
                                lineWidth: 3
                                lineStyle: lineStyles[lineStyleIndex]
                                areaEnabled: root.lineAreaEnabled
                                xAxisMode: LineChart.Value
                                series: [
                                    QtObject {
                                        property string name: "S1"
                                        property color color: Theme.color.primary
                                        property bool visible: true
                                        property var data: [
                                            Qt.point(-3, 10),
                                            Qt.point(-2, 12),
                                            Qt.point(-1, 8),
                                            Qt.point(0, 14),
                                            Qt.point(0, 9),
                                            Qt.point(2, 15),
                                            Qt.point(1, 11),
                                            Qt.point(3, 18)
                                        ]
                                    }
                                ]
                            }
                        }
                    }
                }
            }

            Component {
                id: lineExampleModel
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        Item {
                            anchors.fill: parent
                            ListModel {
                                id: demoModel
                                ListElement { series: "A"; x: 0; y: 10; color: "#4CAF50"; visible: true }
                                ListElement { series: "A"; x: 1; y: 12; color: "#4CAF50"; visible: true }
                                ListElement { series: "A"; x: 2; y: 11; color: "#4CAF50"; visible: true }
                                ListElement { series: "B"; x: 0; y: 8; color: "#2196F3"; visible: true }
                                ListElement { series: "B"; x: 1; y: 9; color: "#2196F3"; visible: true }
                                ListElement { series: "B"; x: 2; y: 7; color: "#2196F3"; visible: true }
                                ListElement { series: "A"; x: 3; y: 16; color: "#4CAF50"; visible: true }
                                ListElement { series: "B"; x: 3; y: 12; color: "#2196F3"; visible: true }
                            }
                            ChartView {
                                anchors.fill: parent
                                anchors.margins: 12
                                legendEnabled: root.overlayLegend
                                tooltipEnabled: root.overlayTooltip
                                crosshairEnabled: root.overlayCrosshair
                                axesEnabled: root.overlayAxes
                                gridEnabled: true
                                xTickCount: 3
                                xLabelFormatter: function(x) { return Number(x).toFixed(0) }
                                LineChart {
                                    model: demoModel
                                    xAxisMode: LineChart.Value
                                    xRole: "x"
                                    yRole: "y"
                                    seriesRole: "series"
                                    colorRole: "color"
                                    visibleRole: "visible"
                                    lineWidth: 3
                                    lineStyle: lineStyles[lineStyleIndex]
                                    areaEnabled: root.lineAreaEnabled
                                }
                            }
                        }
                    }
                }
            }

            Component {
                id: lineExampleFunction
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        ChartView {
                            anchors.fill: parent
                            anchors.margins: 12
                            legendEnabled: false
                            tooltipEnabled: root.overlayTooltip
                            crosshairEnabled: root.overlayCrosshair
                            axesEnabled: root.overlayAxes
                            gridEnabled: true
                            xLabelFormatter: function(x) { return Number(x).toFixed(1) }
                            LineChart {
                                lineWidth: 3
                                lineStyle: lineStyles[lineStyleIndex]
                                areaEnabled: root.lineAreaEnabled
                                xAxisMode: LineChart.Value
                                series: [
                                    QtObject {
                                        property string name: "f(x)"
                                        property color color: Theme.color.primary
                                        property bool visible: true
                                        property var data: (function() {
                                            var pts = []
                                            var x0 = -12
                                            var x1 = 12
                                            var step = 0.25
                                            for (var x = x0; x <= x1 + 1e-9; x += step) {
                                                var y = 500 * Math.sin(x * 0.8) + 220 * Math.cos(x * 0.23)
                                                pts.push(Qt.point(x, y))
                                            }
                                            return pts
                                        })()
                                    }
                                ]
                            }
                        }
                    }
                }
            }

            Component {
                id: lineExampleRace
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12

                        Item {
                            id: race
                            anchors.fill: parent
                            property int t: 0

                            property real aV: 200
                            property real bV: 260
                            property real cV: 180
                            property real dV: 320

                            Timer {
                                id: raceTimer
                                interval: 250
                                repeat: true
                                running: true
                                onTriggered: {
                                    var x = race.t
                                    if (x > 200) {
                                        raceTimer.running = false
                                        return
                                    }

                                    race.aV += root._randInt(-80, 160) + 160 * Math.sin(x * 0.08)
                                    race.bV += root._randInt(-70, 140) + 140 * Math.cos(x * 0.07)
                                    race.cV += root._randInt(-90, 180) + 180 * Math.sin(x * 0.06)
                                    race.dV += root._randInt(-60, 120) + 120 * Math.cos(x * 0.09)

                                    raceChart.appendData([Qt.point(x, race.aV)], 0)
                                    raceChart.appendData([Qt.point(x, race.bV)], 1)
                                    raceChart.appendData([Qt.point(x, race.cV)], 2)
                                    raceChart.appendData([Qt.point(x, race.dV)], 3)

                                    raceChart.xMin = 0
                                    raceChart.xMax = 200

                                    race.t = x + 1
                                    if (x === 200) {
                                        raceTimer.running = false
                                    }
                                }
                            }

                            ChartView {
                                anchors.fill: parent
                                anchors.margins: 12
                                legendEnabled: root.overlayLegend
                                tooltipEnabled: root.overlayTooltip
                                crosshairEnabled: root.overlayCrosshair
                                axesEnabled: root.overlayAxes
                                gridEnabled: true
                                xLabelFormatter: function(x) { return Number(x).toFixed(0) }
                                LineChart {
                                    id: raceChart
                                    animationDuration: 0
                                    lineWidth: 3
                                    lineStyle: lineStyles[lineStyleIndex]
                                    areaEnabled: root.lineAreaEnabled
                                    xAxisMode: LineChart.Value
                                    series: [
                                        QtObject { property string name: "A"; property color color: Theme.color.primary; property var data: []; property bool visible: true },
                                        QtObject { property string name: "B"; property color color: Theme.color.secondary; property var data: []; property bool visible: true },
                                        QtObject { property string name: "C"; property color color: Theme.color.tertiary; property var data: []; property bool visible: true },
                                        QtObject { property string name: "D"; property color color: Theme.color.error; property var data: []; property bool visible: true }
                                    ]
                                }
                            }
                        }
                    }
                }
            }

            Component {
                id: lineExampleTimeline
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        Item {
                            id: timeline
                            anchors.fill: parent
                            property real windowSec: 25
                            property real t0Sec: 0
                            property real nowSec: 0

                            Timer {
                                id: timelineTimer
                                interval: 200
                                repeat: true
                                running: true
                                onTriggered: {
                                    if (timeline.t0Sec <= 0) {
                                        timeline.t0Sec = Date.now() / 1000.0
                                    }
                                    timeline.nowSec = Date.now() / 1000.0 - timeline.t0Sec
                                    if (timeline.nowSec > 200) {
                                        timelineTimer.running = false
                                        return
                                    }
                                    var x = timeline.nowSec
                                    timelineChart.appendData([Qt.point(x, 800 + 220 * Math.sin(x * 0.9) + root._randInt(-60, 60))], 0)
                                    timelineChart.appendData([Qt.point(x, 760 + 180 * Math.cos(x * 0.7) + root._randInt(-60, 60))], 1)
                                    timelineChart.xMin = Math.max(0, timeline.nowSec - timeline.windowSec)
                                    timelineChart.xMax = Math.min(200, Math.max(timeline.windowSec, timeline.nowSec))
                                    if (timeline.nowSec >= 200) {
                                        timelineTimer.running = false
                                    }
                                }
                            }

                            ChartView {
                                anchors.fill: parent
                                anchors.margins: 12
                                legendEnabled: root.overlayLegend
                                tooltipEnabled: root.overlayTooltip
                                crosshairEnabled: root.overlayCrosshair
                                axesEnabled: root.overlayAxes
                                gridEnabled: true
                                xLabelFormatter: function(x) { return Number(x).toFixed(0) }
                                LineChart {
                                    id: timelineChart
                                    xAxisMode: LineChart.Value
                                    animationDuration: 0
                                    lineWidth: 3
                                    lineStyle: lineStyles[lineStyleIndex]
                                    areaEnabled: root.lineAreaEnabled
                                    series: [
                                        QtObject { property string name: "A"; property color color: Theme.color.primary; property var data: []; property bool visible: true },
                                        QtObject { property string name: "B"; property color color: Theme.color.secondary; property var data: []; property bool visible: true }
                                    ]
                                }
                            }
                        }
                    }
                }
            }

            // Bar Chart
            Text { 
                text: "Bar Chart"
                Layout.leftMargin: 20
                font.bold: true
                color: Theme.color.onSurfaceColor
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                Layout.margins: 20
                color: Theme.color.surfaceContainerHighest
                radius: 12
                clip: false
                
                ChartView {
                    anchors.fill: parent
                    anchors.margins: 12

                    legendEnabled: root.overlayLegend
                    tooltipEnabled: root.overlayTooltip
                    crosshairEnabled: root.overlayCrosshair
                    axesEnabled: root.overlayAxes
                    gridEnabled: true

                    BarChart {
                        color: Theme.color.secondary
                        spacing: 0.3
                        includeZeroInRange: root.negativeModeEnabled
                        splitBySign: root.negativeModeEnabled
                        negativeColor: Theme.color.error
                        downsampleMode: root.bigDataEnabled ? BarChart.MinMax : BarChart.None
                        maxRenderPoints: root.bigDataEnabled ? 2000 : 0
                        series: [
                            QtObject { id: onlineSeries; property string name: "Online"; property color color: Theme.color.secondary; property var data: [20, 40, 60, 80, 50, 30, 70, 90, 10, 50]; property bool visible: true },
                            QtObject { id: retailSeries; property string name: "Retail"; property color color: Theme.color.primary; property var data: [10, 30, 45, 60, 40, 25, 55, 70, 8, 35]; property bool visible: true }
                        ]
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                spacing: 16

                Text {
                    text: "Bar Chart Examples"
                    font.bold: true
                    color: Theme.color.onSurfaceColor
                }

                Item { Layout.fillWidth: true }

                SegmentedButton {
                    id: barExampleSeg
                    buttons: root._makeBarExampleButtons(root.barExampleIndex)
                    onClicked: (index) => {
                        root.barExampleIndex = index
                        barExampleSeg.buttons = root._makeBarExampleButtons(index)
                    }
                }
            }

            Loader {
                id: barExampleLoader
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                sourceComponent: {
                    if (root.barExampleIndex === 0) return barExampleStacked
                    if (root.barExampleIndex === 1) return barExamplePercent
                    if (root.barExampleIndex === 2) return barExampleModel
                    return barExampleRealtime
                }
            }

            Component {
                id: barExampleStacked
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        ChartView {
                            anchors.fill: parent
                            anchors.margins: 12
                            legendEnabled: root.overlayLegend
                            tooltipEnabled: root.overlayTooltip
                            crosshairEnabled: root.overlayCrosshair
                            axesEnabled: root.overlayAxes
                            gridEnabled: true
                            xLabels: ["Q1", "Q2", "Q3", "Q4"]
                            BarChart {
                                mode: BarChart.Stacked
                                spacing: 0.25
                                includeZeroInRange: true
                                series: [
                                    QtObject { property string name: "Search"; property color color: Theme.color.primary; property var data: [120, 180, 160, 220]; property bool visible: true },
                                    QtObject { property string name: "Social"; property color color: Theme.color.secondary; property var data: [80, 60, 90, 110]; property bool visible: true },
                                    QtObject { property string name: "Direct"; property color color: Theme.color.tertiary; property var data: [40, 70, 55, 95]; property bool visible: true }
                                ]
                            }
                        }
                    }
                }
            }

            Component {
                id: barExamplePercent
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        ChartView {
                            anchors.fill: parent
                            anchors.margins: 12
                            legendEnabled: root.overlayLegend
                            tooltipEnabled: root.overlayTooltip
                            crosshairEnabled: root.overlayCrosshair
                            axesEnabled: root.overlayAxes
                            gridEnabled: true
                            xLabels: ["Mon", "Tue", "Wed", "Thu", "Fri"]
                            BarChart {
                                mode: BarChart.PercentStacked
                                spacing: 0.25
                                includeZeroInRange: true
                                series: [
                                    QtObject { property string name: "A"; property color color: Theme.color.primary; property var data: [12, 9, 14, 10, 16]; property bool visible: true },
                                    QtObject { property string name: "B"; property color color: Theme.color.secondary; property var data: [7, 10, 8, 12, 9]; property bool visible: true },
                                    QtObject { property string name: "C"; property color color: Theme.color.tertiary; property var data: [3, 2, 5, 3, 4]; property bool visible: true }
                                ]
                            }
                        }
                    }
                }
            }

            Component {
                id: barExampleModel
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        Item {
                            anchors.fill: parent
                            ListModel {
                                id: barModel
                                ListElement { series: "North"; y: 120; color: "#4CAF50"; visible: true }
                                ListElement { series: "South"; y: 90; color: "#2196F3"; visible: true }
                                ListElement { series: "North"; y: 160; color: "#4CAF50"; visible: true }
                                ListElement { series: "South"; y: 110; color: "#2196F3"; visible: true }
                                ListElement { series: "North"; y: 140; color: "#4CAF50"; visible: true }
                                ListElement { series: "South"; y: 70; color: "#2196F3"; visible: true }
                                ListElement { series: "North"; y: 190; color: "#4CAF50"; visible: true }
                                ListElement { series: "South"; y: 130; color: "#2196F3"; visible: true }
                            }
                            ChartView {
                                anchors.fill: parent
                                anchors.margins: 12
                                legendEnabled: root.overlayLegend
                                tooltipEnabled: root.overlayTooltip
                                crosshairEnabled: root.overlayCrosshair
                                axesEnabled: root.overlayAxes
                                gridEnabled: true
                                xLabels: ["A", "B", "C", "D"]
                                BarChart {
                                    model: barModel
                                    yRole: "y"
                                    seriesRole: "series"
                                    colorRole: "color"
                                    visibleRole: "visible"
                                    spacing: 0.25
                                    includeZeroInRange: true
                                }
                            }
                        }
                    }
                }
            }

            Component {
                id: barExampleRealtime
                Item {
                    implicitHeight: 300
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        Item {
                            id: realtime
                            anchors.fill: parent
                            property var items: [
                                { name: "A", v: 110, s: 3.5, drift: 4.0, vol: 1.3, x: 0, color: Theme.color.primary },
                                { name: "B", v: 90, s: 3.0, drift: 3.4, vol: 1.2, x: 1, color: Theme.color.secondary },
                                { name: "C", v: 75, s: 2.6, drift: 3.0, vol: 1.1, x: 2, color: Theme.color.tertiary },
                                { name: "D", v: 60, s: 2.2, drift: 2.6, vol: 1.0, x: 3, color: Theme.color.error },
                                { name: "E", v: 55, s: 2.0, drift: 2.4, vol: 1.0, x: 4, color: Theme.color.primaryContainer },
                                { name: "F", v: 50, s: 1.8, drift: 2.2, vol: 0.9, x: 5, color: Theme.color.secondaryContainer },
                                { name: "G", v: 45, s: 1.6, drift: 2.0, vol: 0.9, x: 6, color: Theme.color.tertiaryContainer },
                                { name: "H", v: 40, s: 1.4, drift: 1.8, vol: 0.8, x: 7, color: Theme.color.outline }
                            ]
                            property var rankNames: []

                            function _clamp(v, lo, hi) {
                                return Math.max(lo, Math.min(hi, v))
                            }

                            function _step() {
                                if (barRaceSeries === null || barRaceSeries === undefined) return
                                for (var i = 0; i < realtime.items.length; ++i) {
                                    var it = realtime.items[i]
                                    var noise = (root._randInt(-100, 100) / 100.0) * it.vol
                                    it.s = realtime._clamp(it.s + noise + 0.06 * (it.drift - it.s), 0.2, 30)
                                    it.v = it.v + it.s + root._randInt(0, 5) + it.v * (0.004 + 0.002 * it.vol) * Math.max(0, noise)
                                }

                                var ordered = realtime.items.slice(0)
                                ordered.sort(function(a, b) { return a.v - b.v })

                                var names = []
                                for (var r = 0; r < ordered.length; ++r) {
                                    ordered[r].x = r
                                    names.push(ordered[r].name)
                                }
                                realtime.rankNames = names

                                var pts = []
                                var cols = []
                                for (var k = 0; k < realtime.items.length; ++k) {
                                    var cur = realtime.items[k]
                                    pts.push(Qt.point(cur.x, cur.v))
                                    cols.push(cur.color)
                                }

                                realtime.items = realtime.items.slice(0)
                                barRaceSeries.data = pts
                                barRaceSeries.colors = cols
                            }

                            Timer {
                                id: realtimeTimer
                                interval: 180
                                repeat: true
                                running: false
                                triggeredOnStart: false
                                onTriggered: {
                                    realtime._step()
                                }
                            }
                            
                            Component.onCompleted: {
                                Qt.callLater(function() {
                                    realtime._step()
                                    realtimeTimer.running = true
                                })
                            }

                            ChartView {
                                anchors.fill: parent
                                anchors.margins: 12
                                legendEnabled: root.overlayLegend
                                tooltipEnabled: root.overlayTooltip
                                crosshairEnabled: root.overlayCrosshair
                                axesEnabled: root.overlayAxes
                                gridEnabled: true
                                yAxisAtZeroWhenValueXAxis: false
                                xTickCount: realtime.items.length - 1
                                xLabelFormatter: function(x) {
                                    var i = Math.round(x)
                                    return (i >= 0 && i < realtime.rankNames.length) ? realtime.rankNames[i] : ""
                                }
                                BarChart {
                                    id: barRaceChart
                                    spacing: 0.25
                                    includeZeroInRange: true
                                    animationDuration: 260
                                    xAxisMode: BarChart.Value
                                    xMin: -0.5
                                    xMax: realtime.items.length - 0.5
                                    series: [
                                        ChartSeries {
                                            id: barRaceSeries
                                            name: "Runners"
                                            color: Theme.color.primary
                                            data: []
                                            property var colors: []
                                            visible: true
                                        }
                                    ]
                                }
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20

                Text {
                    text: "Transport I/O Demo"
                    font.bold: true
                    color: Theme.color.onSurfaceColor
                }

                Item { Layout.fillWidth: true }
            }

            SerialPortDemoCard {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
            }
             
            // Pie Chart
            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                spacing: 20

                // Pie Chart
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 0 // Force equal width
                    
                    Text { 
                        text: "Pie (Advanced)"
                        font.bold: true
                        color: Theme.color.onSurfaceColor
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Switch {
                            text: "Donut"
                            checked: root.pieDonut
                            onClicked: root.pieDonut = !root.pieDonut
                        }

                        Switch {
                            text: "Explode"
                            checked: root.pieExplode
                            onClicked: root.pieExplode = !root.pieExplode
                        }

                        Button {
                            text: "Gap: " + root.pieGapAngles[root.pieGapIndex] + "°"
                            type: "outlined"
                            height: 32
                            horizontalPadding: 14
                            onClicked: root.pieGapIndex = (root.pieGapIndex + 1) % root.pieGapAngles.length
                        }

                        Button {
                            text: "Start: " + root.pieStartAngles[root.pieStartIndex] + "°"
                            type: "outlined"
                            height: 32
                            horizontalPadding: 14
                            onClicked: root.pieStartIndex = (root.pieStartIndex + 1) % root.pieStartAngles.length
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: "Clear"
                            type: "text"
                            height: 32
                            horizontalPadding: 12
                            onClicked: pieAdvanced.selectedIndex = -1
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 300
                        color: Theme.color.surfaceContainerHighest
                        radius: 12
                        
                        PieChart {
                            id: pieAdvanced
                            anchors.centerIn: parent
                            width: 200
                            height: 200
                            sliceColors: root.pieColors
                            sliceLabels: root.pieLabels
                            chartData: root.pieData
                            holeSize: root.pieDonut ? 0.55 : 0.0
                            sliceGapAngle: root.pieGapAngles[root.pieGapIndex]
                            startAngle: root.pieStartAngles[root.pieStartIndex]
                            explodeDistance: root.pieExplode ? 10 : 0
                            selectOnClick: true

                            Behavior on holeSize { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                            Behavior on sliceGapAngle { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                            Behavior on startAngle { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                            Behavior on explodeDistance { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

                            Item {
                                anchors.centerIn: parent
                                width: 160
                                height: 80
                                visible: root.pieDonut && (activeIndex >= 0)

                                readonly property int activeIndex: pieAdvanced.selectedIndex >= 0 ? pieAdvanced.selectedIndex : pieAdvanced.hoveredIndex
                                readonly property bool usingSelected: pieAdvanced.selectedIndex >= 0

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 2

                                    Text {
                                        text: parent.parent.activeIndex >= 0 ? root.pieLabels[parent.parent.activeIndex] : "Tap a slice"
                                        color: Theme.color.onSurfaceColor
                                        font: Theme.typography.titleMedium
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width
                                        elide: Text.ElideRight
                                    }
                                }
                            }

                            Rectangle {
                                visible: parent.hoveredIndex !== -1
                                x: parent.hoverPosition.x - width / 2
                                y: parent.hoverPosition.y - height / 2
                                width: labelPie.implicitWidth + 16
                                height: labelPie.implicitHeight + 8
                                radius: 4
                                color: Theme.color.inverseSurface
                                
                                Text {
                                    id: labelPie
                                    anchors.centerIn: parent
                                    text: root.pieLabels[parent.parent.hoveredIndex] + ": " + parent.parent.hoveredValue.toFixed(0)
                                    color: Theme.color.inverseOnSurface
                                    font.pixelSize: 12
                                }
                            }
                        }
                    }

                    Flow {
                        Layout.fillWidth: true
                        visible: root.overlayLegend
                        spacing: 12

                        Repeater {
                            model: root.pieData.length
                            delegate: Item {
                                required property int index
                                implicitHeight: 24
                                implicitWidth: legendRow.implicitWidth

                                Row {
                                    id: legendRow
                                    spacing: 8

                                    Rectangle {
                                        width: 10
                                        height: 10
                                        radius: 5
                                        color: root.pieColors[index % root.pieColors.length]
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text: {
                                            var v = root.pieData[index]
                                            var t = pieAdvanced.totalValue
                                            var p = t > 0 ? (v / t) * 100 : 0
                                            return root.pieLabels[index] + " " + v.toFixed(0) + " (" + p.toFixed(1) + "%)"
                                        }
                                        color: (index === pieAdvanced.selectedIndex || index === pieAdvanced.hoveredIndex) ? Theme.color.onSurfaceColor : Theme.color.onSurfaceVariantColor
                                        font: Theme.typography.bodySmall
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: pieAdvanced.selectedIndex = index
                                }
                            }
                        }
                    }
                }
            }
            // Spacer for bottom padding
            Item {
                Layout.preferredHeight: 20
            }
            }
        }
    }
}
