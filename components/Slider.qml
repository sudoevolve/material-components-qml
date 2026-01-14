import QtQuick
import QtQuick.Effects
import md3

Item {
    id: control
    
    // API
    property real from: 0.0
    property real to: 1.0
    property real value: 0.0
    property real stepSize: 0.0
    property bool snapMode: false // If true, snaps to steps
    property bool enabled: true
    property bool tickMarksEnabled: false
    property bool valueLabelEnabled: false
    
    // State properties
    readonly property alias pressed: mouseArea.pressed
    readonly property alias hovered: mouseArea.containsMouse
    
    // Signals
    signal moved()
    
    implicitWidth: 200
    implicitHeight: 44 // Touch target height
    
    // Theme
    property var _colors: Theme.color
    property color _onSurfaceColor: _colors.onSurfaceColor
    property color _inverseSurfaceColor: _colors.inverseSurface
    property color _inverseOnSurfaceColor: _colors.inverseOnSurface
    property var _shape: Theme.shape
    property var _state: Theme.state
    
    // Internal
    property real _range: to - from
    property real _position: (value - from) / _range
    
    function setValue(v) {
        var newValue = Math.max(from, Math.min(to, v))
        if (stepSize > 0) {
            var steps = Math.round((newValue - from) / stepSize)
            newValue = from + (steps * stepSize)
            newValue = Math.max(from, Math.min(to, newValue))
        }
        if (control.value !== newValue) {
            control.value = newValue
            control.moved()
        }
    }

    // Update position when value changes externally
    onValueChanged: {
        // Validation happens in setValue mostly, but if bound:
        // verify bounds? simpler to just trust for now or clamp
    }
    
    // Track Container
    Item {
        id: trackContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 4
        
        // Inactive Track (Background)
        Rectangle {
            anchors.fill: parent
            radius: 2
            color: control.enabled ? _colors.surfaceContainerHighest : Qt.rgba(_onSurfaceColor.r, _onSurfaceColor.g, _onSurfaceColor.b, 0.12)
        }
        
        // Active Track (Fill)
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: control._position * parent.width
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
                    var isActive = stepVal <= control.value
                    return isActive ? _colors.onPrimaryColor : _colors.onSurfaceVariantColor
                }
                opacity: 0.38
            }
        }
    }
    
    // Handle Container (Touch Target)
    Item {
        id: handle
        x: (trackContainer.width * control._position) - (width / 2)
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        height: 44
        
        // State Layer (Hover/Press effect)
        Rectangle {
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: 20
            color: _colors.primary
            visible: control.enabled
            opacity: {
                if (mouseArea.pressed) return 0.12
                if (mouseArea.containsMouse) return 0.08
                return 0
            }
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
        
        // Value Label (Tooltip)
        Item {
            id: valueLabel
            visible: control.valueLabelEnabled && (mouseArea.pressed || mouseArea.containsMouse)
            y: -36
            anchors.horizontalCenter: parent.horizontalCenter
            width: 28
            height: 28
            
            opacity: visible ? 1 : 0
            scale: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
            Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
            
            // Balloon shape
            Rectangle {
                anchors.centerIn: parent
                width: 28
                height: 28
                radius: 14
                color: _colors.primary
                rotation: 45
                
                // Tail
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
                text: Math.round(control.value * 100) / 100 // Simple formatting
                color: _colors.onPrimaryColor
                font.pixelSize: 12
                font.weight: Font.Medium
            }
        }

        // Thumb Backing (for disabled state to hide track)
        Rectangle {
            anchors.fill: thumb
            radius: thumb.radius
            color: _colors.surface
            visible: !control.enabled
        }
        
        // Thumb
        Rectangle {
            id: thumb
            anchors.centerIn: parent
            width: mouseArea.pressed ? 22 : 20 // Slight grow on press
            height: width
            radius: width / 2
            color: control.enabled ? _colors.primary : Qt.rgba(_onSurfaceColor.r, _onSurfaceColor.g, _onSurfaceColor.b, 0.38)
            
            // Shadow
            layer.enabled: control.enabled
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: _colors.shadow
                shadowBlur: 4
                shadowVerticalOffset: 2
                shadowOpacity: 0.2
            }
            
            Behavior on width { NumberAnimation { duration: 100 } }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.leftMargin: -10 // Extend touch area slightly
        anchors.rightMargin: -10
        hoverEnabled: true
        enabled: control.enabled
        
        function updateFromMouse(mouseX) {
            var relativeX = mouseX - trackContainer.x
            var pos = relativeX / trackContainer.width
            var newValue = from + (pos * _range)
            control.setValue(newValue)
        }
        
        onPressed: (mouse) => updateFromMouse(mouse.x)
        onPositionChanged: (mouse) => {
            if (pressed) updateFromMouse(mouse.x)
        }
    }
}
