pragma Singleton
import QtQuick

QtObject {
    id: manager

    // Keep track of active widgets to prevent garbage collection
    property var activeWidgets: []

    function createWidget(source, x, y) {
        var component = Qt.createComponent("DesktopWidgetWindow.qml");
        
        if (component.status === Component.Ready) {
            // Set 'manager' as the parent to ensure persistence across page navigation
            var win = component.createObject(manager, {
                "x": x,
                "y": y,
                "widgetSource": source
            });
            
            if (win) {
                // Add to list
                var widgets = activeWidgets;
                widgets.push(win);
                activeWidgets = widgets;
                
                win.show();
                
                // Cleanup when window is destroyed
                win.closing.connect(function() {
                    removeWidget(win);
                });
                
                return win;
            }
        } else {
            console.error("Error loading DesktopWidgetWindow:", component.errorString());
        }
        return null;
    }

    function removeWidget(win) {
        var widgets = activeWidgets;
        var index = widgets.indexOf(win);
        if (index !== -1) {
            widgets.splice(index, 1);
            activeWidgets = widgets;
        }
    }
}
