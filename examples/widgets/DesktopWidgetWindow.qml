import QtQuick
import QtQuick.Window
import md3

Window {
    id: desktopWindow
    
    // Default size fallback
    property real baseWidth: loader.item ? loader.item.implicitWidth : 320
    property real baseHeight: loader.item ? loader.item.implicitHeight : 100
    
    property real scaleFactor: 1.0
    property bool isPinned: false
    property bool alwaysOnTop: true
    property real windowOpacity: 1.0

    width: baseWidth * scaleFactor
    height: baseHeight * scaleFactor
    visible: true
    
    // Frameless window for desktop widget look
    // Dynamic flags handling
    flags: Qt.FramelessWindowHint | Qt.Tool | (alwaysOnTop ? Qt.WindowStaysOnTopHint : 0)
    
    color: "transparent"

    property string widgetSource: ""
    
    // Refresh window to apply flag changes
    onAlwaysOnTopChanged: {
        var wasVisible = visible
        visible = false
        visible = wasVisible
    }

    Loader {
        id: loader
        anchors.centerIn: parent
        source: widgetSource
        scale: scaleFactor
        opacity: windowOpacity
        
        onLoaded: {
            // Ensure the widget fits or adapts
            if (item) {
                // If the widget has properties to control sizing, set them
                if (item.hasOwnProperty("layout")) {
                    // Reset layout properties that might conflict with standalone mode
                }
            }
        }
    }



    // Drag behavior to move the widget on desktop
    MouseArea {
        id: dragArea
        anchors.fill: parent
        z: -1 // Behind the widget content
        // enabled: !isPinned // REMOVED: Must always be enabled to handle clicks for menu closing
        
        propagateComposedEvents: true
        
        property point startPos

        onPressed: (mouse) => {
            menuWindow.visible = false
            startPos = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: (mouse) => {
            if (isPinned) return; // Prevent dragging if pinned
            
            if (mouse.buttons & Qt.LeftButton) {
                var deltaX = mouse.x - startPos.x
                var deltaY = mouse.y - startPos.y
                desktopWindow.x += deltaX
                desktopWindow.y += deltaY
            }
        }
    }

    Window {
        id: menuWindow
        width: 220
        height: 320
        visible: false
        flags: Qt.FramelessWindowHint | Qt.Tool | Qt.WindowStaysOnTopHint
        color: "transparent"
        transientParent: desktopWindow

        onVisibleChanged: {
            if (visible) {
                requestActivate()
            }
        }

        onActiveChanged: {
            if (!active) {
                visible = false
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Theme.color.surfaceContainerHigh
            radius: 16
            border.color: Theme.color.outline
            border.width: 1
            
            Column {
                    anchors.centerIn: parent
                    spacing: 16
                    width: parent.width - 32

                    Text {
                        text: "Widget Settings"
                        font: Theme.typography.titleMedium
                        color: Theme.color.onSurfaceColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.color.outlineVariant
                    }
 
                    Row {
                        width: parent.width
                        spacing: 8
                        
                        Text { 
                            text: "Scale"
                            font: Theme.typography.bodyMedium
                            color: Theme.color.onSurfaceColor
                            anchors.verticalCenter: parent.verticalCenter
                            width: 60
                        }
                        
                        SimpleButton {
                            text: "-"
                            width: 30; height: 30
                            onClicked: desktopWindow.scaleFactor = Math.max(0.5, desktopWindow.scaleFactor - 0.1)
                        }
                        
                        Text {
                            text: Math.round(desktopWindow.scaleFactor * 100) + "%"
                            font: Theme.typography.bodyMedium
                            color: Theme.color.onSurfaceColor
                            anchors.verticalCenter: parent.verticalCenter
                            width: 40
                            horizontalAlignment: Text.AlignHCenter
                        }
                        
                        SimpleButton {
                            text: "+"
                            width: 30; height: 30
                            onClicked: desktopWindow.scaleFactor = Math.min(2.0, desktopWindow.scaleFactor + 0.1)
                        }
                    }
                    
                    Row {
                        width: parent.width
                        spacing: 8
                        
                        Text { 
                            text: "Layer"
                            font: Theme.typography.bodyMedium
                            color: Theme.color.onSurfaceColor
                            anchors.verticalCenter: parent.verticalCenter
                            width: 60
                        }
                        
                        SimpleButton {
                            text: desktopWindow.alwaysOnTop ? "Top" : "Normal"
                            width: 110
                            color: desktopWindow.alwaysOnTop ? Theme.color.primary : Theme.color.surfaceContainerHighest
                            textColor: desktopWindow.alwaysOnTop ? Theme.color.onPrimaryColor : Theme.color.onSurfaceColor
                            onClicked: desktopWindow.alwaysOnTop = !desktopWindow.alwaysOnTop
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: 8
                        
                        Text { 
                            text: "Position"
                            font: Theme.typography.bodyMedium
                            color: Theme.color.onSurfaceColor
                            anchors.verticalCenter: parent.verticalCenter
                            width: 60
                        }
                        
                        SimpleButton {
                            text: desktopWindow.isPinned ? "Pinned" : "Draggable"
                            width: 110
                            color: desktopWindow.isPinned ? Theme.color.primary : Theme.color.surfaceContainerHighest
                            textColor: desktopWindow.isPinned ? Theme.color.onPrimaryColor : Theme.color.onSurfaceColor
                            onClicked: desktopWindow.isPinned = !desktopWindow.isPinned
                        }
                    }
                    
                    Row {
                        width: parent.width
                        spacing: 8
                        
                        Text { 
                            text: "Opacity"
                            font: Theme.typography.bodyMedium
                            color: Theme.color.onSurfaceColor
                            anchors.verticalCenter: parent.verticalCenter
                            width: 60
                        }
                        
                        SimpleButton {
                            text: "-"
                            width: 30; height: 30
                            onClicked: desktopWindow.windowOpacity = Math.max(0.2, desktopWindow.windowOpacity - 0.1)
                        }
                        
                        Text {
                            text: Math.round(desktopWindow.windowOpacity * 100) + "%"
                            font: Theme.typography.bodyMedium
                            color: Theme.color.onSurfaceColor
                            anchors.verticalCenter: parent.verticalCenter
                            width: 40
                            horizontalAlignment: Text.AlignHCenter
                        }
                        
                        SimpleButton {
                            text: "+"
                            width: 30; height: 30
                            onClicked: desktopWindow.windowOpacity = Math.min(1.0, desktopWindow.windowOpacity + 0.1)
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    SimpleButton {
                        text: "Remove Widget"
                        width: parent.width
                        color: Theme.color.error
                        textColor: Theme.color.onErrorColor
                        onClicked: desktopWindow.destroy()
                    }
                }
        }
    }
    
    // Helper Component for Buttons
    component SimpleButton: Rectangle {
        property string text: ""
        property color textColor: Theme.color.onSurfaceColor
        signal clicked()
        
        height: 36
        radius: height / 2
        color: Theme.color.surfaceContainerHighest
        
        Text {
            anchors.centerIn: parent
            text: parent.text
            color: parent.textColor
            font: Theme.typography.labelLarge
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
            onPressed: parent.opacity = 0.8
            onReleased: parent.opacity = 1.0
        }
    }
    
    MouseArea {
        id: rightClickArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: (mouse) => {
            var globalPos = rightClickArea.mapToGlobal(mouse.x, mouse.y)
            menuWindow.x = globalPos.x
            menuWindow.y = globalPos.y
            menuWindow.visible = true
        }
        z: 998 // Below the menu overlay
    }
}
