import QtQuick
import md3

Item {
    id: control
    
    property real value: 0.0
    property bool indeterminate: false
    
    implicitWidth: 200
    implicitHeight: 4
    
    property var _colors: Theme.color
    
    Rectangle {
        id: track
        anchors.fill: parent
        color: _colors.surfaceContainerHighest
        radius: height / 2
        clip: true
        
        // Determinate Indicator
        Rectangle {
            visible: !control.indeterminate
            height: parent.height
            width: parent.width * Math.max(0, Math.min(1, control.value))
            color: _colors.primary
            radius: height / 2
            
            Behavior on width {
                NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
            }
        }
        
        // Indeterminate Indicator
        Item {
            anchors.fill: parent
            visible: control.indeterminate
            
            // First bar
            Rectangle {
                id: bar1
                height: parent.height
                color: _colors.primary
                radius: height / 2
                
                SequentialAnimation {
                    running: control.indeterminate && control.visible
                    loops: Animation.Infinite
                    
                    ParallelAnimation {
                        NumberAnimation { target: bar1; property: "x"; from: -parent.width; to: parent.width; duration: 2000; easing.type: Easing.InOutCubic }
                        SequentialAnimation {
                            NumberAnimation { target: bar1; property: "width"; from: 0; to: parent.width * 0.5; duration: 1000; easing.type: Easing.OutCubic }
                            NumberAnimation { target: bar1; property: "width"; from: parent.width * 0.5; to: 0; duration: 1000; easing.type: Easing.InCubic }
                        }
                    }
                }
            }
            
            // Second bar (delayed)
            Rectangle {
                id: bar2
                height: parent.height
                color: _colors.primary
                radius: height / 2
                
                SequentialAnimation {
                    running: control.indeterminate && control.visible
                    loops: Animation.Infinite
                    
                    PauseAnimation { duration: 1000 }
                    
                    ParallelAnimation {
                        NumberAnimation { target: bar2; property: "x"; from: -parent.width; to: parent.width; duration: 2000; easing.type: Easing.InOutCubic }
                        SequentialAnimation {
                            NumberAnimation { target: bar2; property: "width"; from: 0; to: parent.width * 0.5; duration: 1000; easing.type: Easing.OutCubic }
                            NumberAnimation { target: bar2; property: "width"; from: parent.width * 0.5; to: 0; duration: 1000; easing.type: Easing.InCubic }
                        }
                    }
                }
            }
        }
    }
}
