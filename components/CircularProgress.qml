import QtQuick
import md3

Item {
    id: control
    
    property real value: 0.0 // 0.0 to 1.0
    property bool indeterminate: false
    property bool showTrack: true
    
    implicitWidth: 48
    implicitHeight: 48
    
    property var _colors: Theme.color
    
    // Internal animation properties
    property real _rotation: 0
    property real _arcOffset: 0
    property real _arcSweep: 0
    
    onIndeterminateChanged: {
        if (!indeterminate) {
            _rotation = 0
            _arcOffset = 0
            _arcSweep = 0
            canvas.requestPaint()
        } else {
            // Reset animation state when entering indeterminate mode
            _rotation = 0
            _arcOffset = 0
            _arcSweep = 10
        }
    }
    
    onValueChanged: canvas.requestPaint()
    onShowTrackChanged: canvas.requestPaint()

    // Indeterminate Animations
    ParallelAnimation {
        running: control.indeterminate && control.visible
        loops: Animation.Infinite
        
        // Continuous body rotation
        NumberAnimation {
            target: control
            property: "_rotation"
            from: 0
            to: 360
            duration: 2000
        }
        
        // Arc expansion/contraction
        SequentialAnimation {
            // Expand (Head moves fast, Tail moves slow)
            ParallelAnimation {
                NumberAnimation { target: control; property: "_arcSweep"; from: 10; to: 300; duration: 1000; easing.type: Easing.InOutCubic }
                NumberAnimation { target: control; property: "_arcOffset"; from: 0; to: 50; duration: 1000; easing.type: Easing.InOutCubic }
            }
            // Contract (Head moves slow, Tail moves fast)
            ParallelAnimation {
                NumberAnimation { target: control; property: "_arcSweep"; from: 300; to: 10; duration: 1000; easing.type: Easing.InOutCubic }
                NumberAnimation { target: control; property: "_arcOffset"; from: 50; to: 360; duration: 1000; easing.type: Easing.InOutCubic }
            }
        }
    }

    // Trigger paint on animation changes
    on_RotationChanged: canvas.requestPaint()
    on_ArcOffsetChanged: canvas.requestPaint()
    on_ArcSweepChanged: canvas.requestPaint()
    
    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Threaded
        
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            
            var w = width;
            var h = height;
            var centerX = w / 2;
            var centerY = h / 2;
            var lineWidth = 4;
            var radius = Math.min(w, h) / 2 - lineWidth / 2; 
            
            ctx.lineWidth = lineWidth;
            ctx.lineCap = "round";
            
            // Draw Track (only for determinate)
            if (!control.indeterminate && control.showTrack) {
                ctx.beginPath();
                ctx.strokeStyle = control._colors.surfaceContainerHighest;
                ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                ctx.stroke();
            }
            
            // Draw Indicator
            ctx.beginPath();
            ctx.strokeStyle = control._colors.primary;
            
            var startAngle, endAngle;
            
            if (control.indeterminate) {
                // Rotated frame + expanding/contracting arc
                // Canvas arc angles are in radians. 0 is 3 o'clock.
                // We want to start from 12 o'clock (-PI/2) plus rotation.
                
                var rotationRad = (control._rotation - 90) * Math.PI / 180;
                var offsetRad = control._arcOffset * Math.PI / 180;
                var sweepRad = control._arcSweep * Math.PI / 180;
                
                startAngle = rotationRad + offsetRad;
                endAngle = startAngle + sweepRad;
                
                ctx.arc(centerX, centerY, radius, startAngle, endAngle, false);
                ctx.stroke();
            } else {
                // Determinate
                if (control.value > 0) {
                    startAngle = -Math.PI / 2; // -90 degrees (12 o'clock)
                    endAngle = startAngle + (control.value * 2 * Math.PI);
                    ctx.arc(centerX, centerY, radius, startAngle, endAngle, false);
                    ctx.stroke();
                }
            }
        }
    }
}
