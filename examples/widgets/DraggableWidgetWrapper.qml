import QtQuick
import md3

Item {
    id: wrapper
    
    // The content (the existing widget) to display in the list
    default property alias content: container.data
    
    // The URL of the widget to load when dragged out
    property string widgetSource: ""
    
    implicitWidth: container.children.length > 0 ? container.children[0].implicitWidth : 0
    implicitHeight: container.children.length > 0 ? container.children[0].implicitHeight : 0
    
    // Pass layout properties to the container if needed, 
    // but usually Layout properties are attached to the Item (wrapper) itself by the parent Layout.
    // So existing Layout.fillWidth etc on the usage site will apply to this Wrapper.

    Item {
        id: container
        anchors.fill: parent
        scale: tapHandler.pressed ? 0.95 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }
    }
    
    // Track the currently being dragged window
    property var currentWin: null
    
    // TapHandler for Long Press detection
    TapHandler {
        id: tapHandler
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onLongPressed: {
            var point = tapHandler.point.position
            var globalPos = wrapper.mapToGlobal(point.x, point.y)
            
            // Create the widget and store reference
            wrapper.currentWin = DesktopWidgetManager.createWidget(wrapper.widgetSource, globalPos.x - 160, globalPos.y - 160);
        }
    }
    
    // DragHandler to move the window AFTER long press
    // It will only affect the window if currentWin is set
    DragHandler {
        target: null
        grabPermissions: PointerHandler.CanTakeOverFromAnything
        
        onTranslationChanged: (delta) => {
            if (wrapper.currentWin) {
                wrapper.currentWin.x += delta.x
                wrapper.currentWin.y += delta.y
            }
        }
        
        onActiveChanged: {
            // Reset when drag ends (finger released)
            if (!active) {
                wrapper.currentWin = null
            }
        }
    }
}
