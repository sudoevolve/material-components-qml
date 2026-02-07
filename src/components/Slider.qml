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

    // Range Mode API
    property bool rangeMode: false
    property real firstValue: from
    property real secondValue: to
    
    // State properties
    readonly property alias pressed: mouseArea.pressed
    readonly property alias hovered: mouseArea.containsMouse
    
    // Signals
    signal moved()
    signal firstMoved()
    signal secondMoved()
    
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
    property real _firstPos: (firstValue - from) / _range
    property real _secondPos: (secondValue - from) / _range

    // Logic for interacting with handles
    property int _draggingHandle: 0 // 0: None, 1: First/Value, 2: Second
    property int _closestHandle: 1 // 1 or 2, determines which handle is targeted by hover/click

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

    function setFirstValue(v) {
        var upperLimit = rangeMode ? secondValue : to
        var val = Math.max(from, Math.min(upperLimit, v))
        if (stepSize > 0) {
            var steps = Math.round((val - from) / stepSize)
            val = from + (steps * stepSize)
            val = Math.max(from, Math.min(upperLimit, val))
        }
        if (firstValue !== val) {
            firstValue = val
            if (rangeMode) firstMoved()
            // In single mode, we might not use firstValue, but keeping it synced could be useful?
            // For now, keep them separate.
        }
    }

    function setSecondValue(v) {
        var lowerLimit = firstValue
        var val = Math.max(lowerLimit, Math.min(to, v))
        if (stepSize > 0) {
             var steps = Math.round((val - from) / stepSize)
             val = from + (steps * stepSize)
             val = Math.max(lowerLimit, Math.min(to, val))
        }
        if (secondValue !== val) {
            secondValue = val
            if (rangeMode) secondMoved()
        }
    }

    function updateFromMouse(mouseX) {
        var relativeX = mouseX - trackContainer.x
        var pos = relativeX / trackContainer.width
        var rawValue = from + (pos * _range)
        
        if (!rangeMode) {
            setValue(rawValue)
        } else {
            // Determine which handle to move if not already dragging
            if (_draggingHandle === 0) {
                var dist1 = Math.abs(rawValue - firstValue)
                var dist2 = Math.abs(rawValue - secondValue)
                if (dist1 <= dist2) {
                    _draggingHandle = 1
                } else {
                    _draggingHandle = 2
                }
            }
            
            if (_draggingHandle === 1) {
                setFirstValue(rawValue)
            } else if (_draggingHandle === 2) {
                setSecondValue(rawValue)
            }
        }
    }
    
    // Track Container
    Item {
        id: trackContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 5
        
        // Inactive Track (Background)
        Rectangle {
            anchors.fill: parent
            radius: 2
            color: control.enabled ? _colors.surfaceContainerHighest : Qt.rgba(_onSurfaceColor.r, _onSurfaceColor.g, _onSurfaceColor.b, 0.12)
        }
        
        // Active Track (Fill)
        Rectangle {
            id: activeTrack
            x: control.rangeMode ? control._firstPos * parent.width : 0
            width: control.rangeMode ? (control._secondPos - control._firstPos) * parent.width : control._position * parent.width
            height: 4
            radius: 2
            color: control.enabled ? _colors.primary : Qt.rgba(_onSurfaceColor.r, _onSurfaceColor.g, _onSurfaceColor.b, 0.38)
        }
        
        // Tick Marks
        Repeater {
            model: control.tickMarksEnabled && control.stepSize > 0 ? Math.floor(control._range / control.stepSize) + 1 : 0
            
            Rectangle {
                width: 4
                height: 4
                radius: 2
                y: (parent.height - height) / 2
                x: (index * control.stepSize / control._range) * parent.width - (width / 2)
                
                color: {
                    var stepVal = control.from + (index * control.stepSize)
                    var isActive = false
                    if (control.rangeMode) {
                        isActive = stepVal >= control.firstValue && stepVal <= control.secondValue
                    } else {
                        isActive = stepVal <= control.value
                    }
                    return isActive ? _colors.onPrimaryColor : _colors.onSurfaceVariantColor
                }
                opacity: 0.38
            }
        }
    }
    
    // Handle 1 (or Main Handle)
    Item {
        id: handle1
        property real pos: control.rangeMode ? control._firstPos : control._position
        x: (trackContainer.width * pos) - (width / 2)
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        height: 44
        z: 10
        
        // States for visual feedback
        property bool isHovered: control.rangeMode ? (mouseArea.containsMouse && control._closestHandle === 1) : mouseArea.containsMouse
        property bool isPressed: control.rangeMode ? (mouseArea.pressed && control._draggingHandle === 1) : mouseArea.pressed

        // State Layer (Hover/Press effect)
        Rectangle {
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: 20
            color: _colors.primary
            visible: control.enabled
            opacity: {
                if (handle1.isPressed) return 0.12
                if (handle1.isHovered) return 0.08
                return 0
            }
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
        
        // Value Label (Tooltip)
        Item {
            id: valueLabel1
            visible: control.valueLabelEnabled && (handle1.isPressed || handle1.isHovered)
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
                text: Math.round((control.rangeMode ? control.firstValue : control.value) * 100) / 100
                color: _colors.onPrimaryColor
                font.pixelSize: 12
                font.weight: Font.Medium
            }
        }

        // Thumb Backing
        Rectangle {
            anchors.fill: thumb1
            radius: thumb1.radius
            color: _colors.surface
            visible: !control.enabled
        }
        
        // Thumb
        Rectangle {
            id: thumb1
            anchors.centerIn: parent
            width: handle1.isPressed ? 22 : 20
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
    
    // Handle 2 (Only for Range Mode)
    Item {
        id: handle2
        visible: control.rangeMode
        x: (trackContainer.width * control._secondPos) - (width / 2)
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        height: 44
        z: 11
        
        property bool isHovered: mouseArea.containsMouse && control._closestHandle === 2
        property bool isPressed: mouseArea.pressed && control._draggingHandle === 2

        // State Layer
        Rectangle {
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: 20
            color: _colors.primary
            visible: control.enabled
            opacity: {
                if (handle2.isPressed) return 0.12
                if (handle2.isHovered) return 0.08
                return 0
            }
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
        
        // Value Label
        Item {
            id: valueLabel2
            visible: control.valueLabelEnabled && (handle2.isPressed || handle2.isHovered)
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

        Rectangle {
            anchors.fill: thumb2
            radius: thumb2.radius
            color: _colors.surface
            visible: !control.enabled
        }
        
        Rectangle {
            id: thumb2
            anchors.centerIn: parent
            width: handle2.isPressed ? 22 : 20
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
            
            Behavior on width { NumberAnimation { duration: 100 } }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.leftMargin: -10 
        anchors.rightMargin: -10
        hoverEnabled: true
        enabled: control.enabled
        preventStealing: true
        
        onPressed: (mouse) => {
            control.updateFromMouse(mouse.x)
        }
        
        onReleased: {
            control._draggingHandle = 0
        }
        
        onPositionChanged: (mouse) => {
            if (pressed) {
                control.updateFromMouse(mouse.x)
            } else {
                // Update closest handle for hover effect
                if (control.rangeMode) {
                    var relativeX = mouse.x - trackContainer.x
                    var pos = relativeX / trackContainer.width
                    var val = from + (pos * _range)
                    var dist1 = Math.abs(val - firstValue)
                    var dist2 = Math.abs(val - secondValue)
                    if (dist1 <= dist2) {
                        control._closestHandle = 1
                    } else {
                        control._closestHandle = 2
                    }
                } else {
                    control._closestHandle = 1
                }
            }
        }
    }
}

