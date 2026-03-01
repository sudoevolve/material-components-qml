import QtQuick
import QtQuick.Layouts
import md3.Core
import "../../Core/Styles/animations"

Item {
    id: root
    width: parent.width
    height: parent.height

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

    // Model for tasks derived from task.md
    ListModel {
        id: tasksModel
        ListElement { name: "Performance Monitor"; icon: "monitor_heart"; page: "" }
        ListElement { name: "Advanced DataGrid"; icon: "table_chart"; page: "" }
        ListElement { name: "Interactive Charts"; icon: "bar_chart"; page: "" }
        ListElement { name: "Hot Reload"; icon: "bolt"; page: "" }
        ListElement { name: "Math Symbol Support"; icon: "functions"; page: " " }
        ListElement { name: "Rich Editors"; icon: "edit_note"; page: "" }
        ListElement { name: "Node Graph Editor"; icon: "polyline"; page: "" }
        ListElement { name: "Gantt & Scheduler"; icon: "calendar_month"; page: "" }
        ListElement { name: "Report Designer"; icon: "print"; page: "" }
        ListElement { name: "3D Data Visualization"; icon: "view_in_ar"; page: "" }
        ListElement { name: "Scientific Image Analyzer"; icon: "image_search"; page: "" }
        ListElement { name: "Property & Parameter Tree"; icon: "account_tree"; page: "" }
        ListElement { name: "Industrial Gauge Kit"; icon: "speed"; page: "" }
        ListElement { name: "Advanced GIS Map"; icon: "map"; page: "" }
        ListElement { name: "Video Wall & Player"; icon: "videocam"; page: "" }
        ListElement { name: "Network Topology Diagram"; icon: "hub"; page: "" }
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
                                    var win = Window.window
                                    if (win) {
                                        // Find PerformanceMonitor in window children
                                        for (var i = 0; i < win.contentItem.children.length; ++i) {
                                            var child = win.contentItem.children[i]
                                            if (child.toString().indexOf("PerformanceMonitor") !== -1) {
                                                child.visible = !child.visible
                                                break
                                            }
                                        }
                                    }
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
