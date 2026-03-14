import QtQuick
import QtQuick.Layouts
import md3.Core
import "../../Core/Styles/animations"

Item {
    id: root
    width: parent.width
    height: parent.height
    property var appFeatures: (typeof AppFeatures !== "undefined" && AppFeatures) ? AppFeatures : ({})

    function hasExtra(key) {
        return !!appFeatures[key]
    }

    function appendTask(name, icon, page) {
        tasksModel.append({ name: name, icon: icon, page: page })
    }

    function rebuildTasks() {
        tasksModel.clear()

        if (hasExtra("performance")) appendTask("Performance Monitor", "monitor_heart", "Performance")
        if (hasExtra("dataGrid")) appendTask("Advanced DataGrid", "table_chart", "extras/DataGridPage.qml")
        if (hasExtra("charts")) appendTask("Interactive Charts", "bar_chart", "extras/ChartsPage.qml")
        if (hasExtra("hotReload")) appendTask("Hot Reload", "bolt", "extras/HotReloadPage.qml")
        if (hasExtra("mathSymbols")) appendTask("Math Symbol Support", "functions", "extras/MathSymbolsPage.qml")
        if (hasExtra("markdown")) appendTask("Rich Editors", "edit_note", "extras/MarkdownPage.qml")
        if (hasExtra("nodeGraph")) appendTask("Node Graph Editor", "polyline", "extras/NodeGraphPage.qml")
        if (hasExtra("gantt")) appendTask("Gantt & Scheduler", "calendar_month", "extras/GanttPage.qml")

        appendTask("Report Designer", "print", "")
        appendTask("3D Data Visualization", "view_in_ar", "")
        appendTask("Scientific Image Analyzer", "image_search", "")
        appendTask("Property & Parameter Tree", "account_tree", "")
        appendTask("Industrial Gauge Kit", "speed", "")
        appendTask("Advanced GIS Map", "map", "")
        appendTask("Video Wall & Player", "videocam", "")
        appendTask("Network Topology Diagram", "hub", "")
    }

    function togglePerformanceMonitor() {
        var win = Window.window
        if (!win || !win.contentItem) return

        var stack = [win.contentItem]
        while (stack.length > 0) {
            var obj = stack.pop()
            if (!obj) continue
            if (obj.objectName === "GlobalPerformanceMonitor") {
                obj.visible = !obj.visible
                return
            }
            if (obj.children && obj.children.length) {
                for (var i = 0; i < obj.children.length; ++i) stack.push(obj.children[i])
            }
        }
    }

    Component.onCompleted: rebuildTasks()

    AnimatedWindow {
        id: animatedWindow
        anchors.fill: parent
        
        Loader {
            id: pageLoader
            anchors.fill: parent
            onLoaded: {
                if (item && item.backClicked) {
                    item.backClicked.connect(function() {
                        animatedWindow.state = "iconState"
                    })
                }
            }
        }
        
        onVisibleChanged: {
            if (!visible) {
                pageLoader.source = ""
            }
        }
    }

    ListModel {
        id: tasksModel
    }

    // Dashboard View
    Flickable {
        id: dashboardView
        visible: animatedWindow.state !== "fullscreenState"
        anchors.fill: parent
        anchors.rightMargin: 48
        contentWidth: width
        contentHeight: contentLayout.implicitHeight + 64
        clip: true

        ColumnLayout {
            id: contentLayout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 32
            spacing: 24

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: "workspace_premium"
                    font.family: Theme.iconFont.name
                    font.pixelSize: 32
                    color: Theme.color.primary
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "Pro Components"
                        font.family: Theme.typography.headlineMedium.family
                        font.pixelSize: Theme.typography.headlineMedium.size
                        font.weight: Theme.typography.headlineMedium.weight
                        color: Theme.color.onSurfaceColor
                    }

                    Text {
                        text: "Comprehensive suite of advanced components for professional applications."
                        font.family: Theme.typography.bodyMedium.family
                        font.pixelSize: Theme.typography.bodyMedium.size
                        color: Theme.color.onSurfaceVariantColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.color.outlineVariant
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 4
                columnSpacing: 16
                rowSpacing: 16

                Repeater {
                    model: tasksModel
                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110

                        Card {
                            id: cardDelegate
                            anchors.fill: parent
                            type: "filled"
                            color: Theme.color.surfaceContainerLow
                            
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                width: parent.width - 24

                                Text { 
                                    text: icon
                                    font.family: Theme.iconFont.name
                                    font.pixelSize: 32
                                    color: Theme.color.primary 
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                
                                Text { 
                                    text: name
                                    font.family: Theme.typography.titleSmall.family
                                    font.pixelSize: Theme.typography.titleSmall.size
                                    font.weight: Theme.typography.titleSmall.weight
                                    color: Theme.color.onSurfaceColor
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (page === "Performance") {
                                    root.togglePerformanceMonitor()
                                } else if (page !== "") {
                                    pageLoader.source = page
                                    animatedWindow.open(cardDelegate)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
