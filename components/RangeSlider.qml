import QtQuick
import QtQuick.Effects
import md3

Item {
    id: control
    
    // API
    property real from: 0.0
    property real to: 1.0
    property bool enabled: true
    property real stepSize: 0.0
    property bool snapMode: false
    property bool tickMarksEnabled: false
    property bool valueLabelEnabled: false
    
    property real firstValue: 0.2
    property real secondValue: 0.8
    
    // Signals
    signal firstMoved()
    signal secondMoved()
    
    implicitWidth: 200
    implicitHeight: 44
    
    // Theme
    property var _colors: Theme.color
    property color _onSurfaceColor: _colors.onSurfaceColor
    property color _inverseSurfaceColor: _colors.inverseSurface
    property color _inverseOnSurfaceColor: _colors.inverseOnSurface
    property var _shape: Theme.shape
    
    // Internal
    property real _range: to - from
    property real _firstPos: (firstValue - from) / _range
    property real _secondPos: (secondValue - from) / _range
    
    function setFirstValue(v) {
        var val = Math.max(from, Math.min(secondValue, v))
        if (stepSize > 0) {
            var steps = Math.round((val - from) / stepSize)
            val = from + (steps * stepSize)
            val = Math.max(from, Math.min(secondValue, val))
        }
        if (firstValue !== val) {
            firstValue = val
            firstMoved()
        }
    }
    
    function setSecondValue(v) {
        var val = Math.max(firstValue, Math.min(to, v))
        if (stepSize > 0) {
             var steps = Math.round((val - from) / stepSize)
             val = from + (steps * stepSize)
             val = Math.max(firstValue, Math.min(to, val))
        }
        if (secondValue !== val) {
            secondValue = val
            secondMoved()
        }
    }
    
    // Track
    Item {
        id: trackContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 4
        
        // Background
        Rectangle {
            anchors.fill: parent
            radius: 2
            color: control.enabled ? _colors.surfaceContainerHighest : Qt.rgba(_onSurfaceColor.r, _onSurfaceColor.g, _onSurfaceColor.b, 0.12)
        }
        
        // Active Range
        Rectangle {
            x: control._firstPos * parent.width
            width: (control._secondPos - control._firstPos) * parent.width
            height: 4
            radius: 2
            color: control.enabled ? _colors.primary : Qt.rgba(_onSurfaceColor.r, _onSurfaceColor.g, _onSurfaceColor.b, 0.38)
        }
        
        // Tick Marks
         Repeater {
             model: control.tickMarksEnabled && control.stepSize > 0 ? Math.floor(control._range / control.stepSize) + 1 : 0
             
             Rectangle {
                 width: 2
                 height: 2
                 radius: 1
                 y: (parent.height - height) / 2
                 x: (index * control.stepSize / control._range) * parent.width - (width / 2)
                 
                 color: {
                    var stepVal = control.from + (index * control.stepSize)
                    var isActive = stepVal >= control.firstValue && stepVal <= control.secondValue
                    return isActive ? _colors.onPrimaryColor : _colors.onSurfaceVariantColor
                }
                opacity: 0.38
            }
        }
    }
    
    // Handle 1
    Item {
        id: handle1
        x: (trackContainer.width * control._firstPos) - (width / 2)
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        height: 44
        z: 10
        
        Rectangle {
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: 20
            color: _colors.primary
            visible: control.enabled
            opacity: mouseArea1.pressed || mouseArea1.containsMouse ? 0.12 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
        
        Rectangle {
            anchors.fill: thumb1
            radius: thumb1.radius
            color: _colors.surface
            visible: !control.enabled
        }

        Rectangle {
            id: thumb1
            anchors.centerIn: parent
            width: mouseArea1.pressed ? 22 : 20
            height: width
            radius: width / 2
            color: control.enabled ? _colors.primary : Qt.rgba(_onSurfaceColor.r, _onSurfaceColor.g, _onSurfaceColor.b, 0.38)
            
            layer.enabled: control.enabled
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: _colors.shadow
                shadowBlur: 4
                shadowVerticalOffset: 2
                shadowOpacity: 0.2
            }
        }
        
         // Value Label 1
         Item {
             visible: control.valueLabelEnabled && (mouseArea1.pressed || mouseArea1.containsMouse)
             y: -36
             anchors.horizontalCenter: parent.horizontalCenter
             width: 28
             height: 28
             
             opacity: visible ? 1 : 0
             scale: visible ? 1 : 0
             Behavior on opacity { NumberAnimation { duration: 100 } }
             Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
             
             Rectangle {
                 anchors.centerIn: parent
                 width: 28
                 height: 28
                 radius: 14
                 color: _colors.primary
                 rotation: 45
                 Rectangle {
                     width: 14
                     height: 14
                     color: _colors.primary
                     anchors.bottom: parent.bottom
                     anchors.right: parent.right
                 }
             }
             Text {
                anchors.centerIn: parent
                text: Math.round(control.firstValue * 100) / 100
                color: _colors.onPrimaryColor
                font.pixelSize: 12
                font.weight: Font.Medium
            }
         }
        
        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            hoverEnabled: true
            drag.target: null
            enabled: control.enabled
            
            function update(mouseX) {
                var absX = handle1.x + mouseX
                var relX = absX - trackContainer.x + (handle1.width/2)
                var pos = relX / trackContainer.width
                var val = from + (pos * _range)
                control.setFirstValue(val)
            }
            
            onPressed: (mouse) => update(mouse.x)
            onPositionChanged: (mouse) => { if (pressed) update(mouse.x) }
        }
    }
    
    // Handle 2
    Item {
        id: handle2
        x: (trackContainer.width * control._secondPos) - (width / 2)
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        height: 44
        z: 11
        
        Rectangle {
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: 20
            color: _colors.primary
            visible: control.enabled
            opacity: mouseArea2.pressed || mouseArea2.containsMouse ? 0.12 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
        
        Rectangle {
            anchors.fill: thumb2
            radius: thumb2.radius
            color: _colors.surface
            visible: !control.enabled
        }
        
        Rectangle {
            id: thumb2
            anchors.centerIn: parent
            width: mouseArea2.pressed ? 22 : 20
            height: width
            radius: width / 2
            color: control.enabled ? _colors.primary : Qt.rgba(_onSurfaceColor.r, _onSurfaceColor.g, _onSurfaceColor.b, 0.38)
            
            layer.enabled: control.enabled
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: _colors.shadow
                shadowBlur: 4
                shadowVerticalOffset: 2
                shadowOpacity: 0.2
            }
        }
        
         // Value Label 2
         Item {
             visible: control.valueLabelEnabled && (mouseArea2.pressed || mouseArea2.containsMouse)
             y: -36
             anchors.horizontalCenter: parent.horizontalCenter
             width: 28
             height: 28
             
             opacity: visible ? 1 : 0
             scale: visible ? 1 : 0
             Behavior on opacity { NumberAnimation { duration: 100 } }
             Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
             
             Rectangle {
                 anchors.centerIn: parent
                 width: 28
                 height: 28
                 radius: 14
                 color: _colors.primary
                 rotation: 45
                 Rectangle {
                     width: 14
                     height: 14
                     color: _colors.primary
                     anchors.bottom: parent.bottom
                     anchors.right: parent.right
                 }
             }
             Text {
                anchors.centerIn: parent
                text: Math.round(control.secondValue * 100) / 100
                color: _colors.onPrimaryColor
                font.pixelSize: 12
                font.weight: Font.Medium
            }
         }
        
        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            hoverEnabled: true
            drag.target: null
            enabled: control.enabled
            
            function update(mouseX) {
                var absX = handle2.x + mouseX
                var relX = absX - trackContainer.x + (handle2.width/2)
                var pos = relX / trackContainer.width
                var val = from + (pos * _range)
                control.setSecondValue(val)
            }
            
            onPressed: (mouse) => update(mouse.x)
            onPositionChanged: (mouse) => { if (pressed) update(mouse.x) }
        }
    }
}
