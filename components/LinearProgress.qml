import QtQuick
import md3

Item {
    id: control
    
    property real value: 0.0
    property bool indeterminate: false
    property bool wavy: false
    
    implicitWidth: 200
    implicitHeight: wavy ? 16 : 4
    
    property var _colors: Theme.color
    
    // Standard Linear Progress
    Rectangle {
        id: track
        anchors.fill: parent
        visible: !control.wavy
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
                    running: control.indeterminate && control.visible && !control.wavy
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
                    running: control.indeterminate && control.visible && !control.wavy
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

    // Wavy Linear Progress
    Canvas {
        id: wavyCanvas
        visible: control.wavy
        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Threaded

        property real phase: 0.0

        // Animation for phase shift (make it flow)
        NumberAnimation on phase {
            running: control.wavy && control.visible && control.indeterminate
            from: 0
            to: Math.PI * 2
            duration: 1000 // 1Hz wave frequency
            loops: Animation.Infinite
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            
            var w = width;
            var h = height;
            var cy = h / 2;
            var amplitude = h / 4; // Wave height
            var frequency = 0.1; // Wave density
            
            ctx.lineWidth = 4;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            
            // Draw Track (Inactive)
            ctx.beginPath();
            ctx.strokeStyle = control._colors.surfaceContainerHighest;
            for (var x = 0; x <= w; x+=2) {
                var y = cy + amplitude * Math.sin((x * frequency) + phase); // Track also waves
                if (x === 0) ctx.moveTo(x, y);
                else ctx.lineTo(x, y);
            }
            ctx.stroke();

            // Draw Indicator (Active)
            ctx.beginPath();
            ctx.strokeStyle = control._colors.primary;
            
            var endX = 0;
            if (control.indeterminate) {
                 endX = w;
            } else {
                 endX = w * Math.max(0, Math.min(1, control.value));
            }

            if (control.indeterminate) {
                // Active Wave (Indeterminate)
                ctx.beginPath();
                ctx.strokeStyle = control._colors.primary;
                
                var progress = (phase % (Math.PI * 2)) / (Math.PI * 2); // 0 to 1
                var barWidth = w * 0.5;
                var startX = (w + barWidth) * progress - barWidth;
                var actualEndX = startX + barWidth;
                
                for (var x = 0; x <= w; x+=2) {
                    if (x >= startX && x <= actualEndX) {
                         var y = cy + amplitude * Math.sin((x * frequency) + phase);
                         if (x === 0 || Math.abs(x - startX) < 2) ctx.moveTo(x, y);
                         else ctx.lineTo(x, y);
                    }
                }
                ctx.stroke();
            } else {
                // Determinate
                for (var x = 0; x <= endX; x+=2) {
                    var y = cy + amplitude * Math.sin((x * frequency) + phase);
                    if (x === 0) ctx.moveTo(x, y);
                    else ctx.lineTo(x, y);
                }
                ctx.stroke();
            }
        }
        
        onPhaseChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }
}
