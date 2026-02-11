import QtQuick
import QtQuick.Layouts
import md3.Core
Item {
    id: root
    implicitWidth: 320
    implicitHeight: 320

    property date currentDate: new Date()
    property color faceColor: Theme.color.primary
    property color featureColor: Theme.color.surfaceContainerHighest

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.currentDate = new Date()
    }

    Rectangle {
        anchors.fill: parent
        radius: 32
        color: Theme.color.surfaceContainerHighest
        
        // Canvas Face
        Canvas {
            id: faceCanvas
            anchors.fill: parent
            // Redraw when colors change or size changes
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var w = width;
                var h = height;
                var r = parent.radius;

                // Create clipping path for the rounded rectangle
                ctx.beginPath();
                ctx.roundedRect(0, 0, w, h, r, r);
                ctx.clip();

                // 1. Draw the Blue Blob (Face shape)
                var radius = w * 0.55; 
                var centerX = w; 
                var centerY = h;

                ctx.beginPath();
                ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                ctx.fillStyle = root.faceColor;
                ctx.fill();

                // 2. Draw Features (Eyes and Mouth)
                ctx.lineCap = "round";
                ctx.lineWidth = 5; // Slightly thinner line for smaller face
                ctx.strokeStyle = root.featureColor;

                var eyeY = h - (radius * 0.5); 
                var leftEyeX = w - (radius * 0.65);
                var rightEyeX = w - (radius * 0.25);
                var eyeRadius = 14; // Smaller eyes
                
                // Left Eye (U shape)
                ctx.beginPath();
                ctx.arc(leftEyeX, eyeY, eyeRadius, 0.1 * Math.PI, 0.9 * Math.PI);
                ctx.stroke();

                // Right Eye (U shape)
                ctx.beginPath();
                ctx.arc(rightEyeX, eyeY, eyeRadius, 0.1 * Math.PI, 0.9 * Math.PI); 
                ctx.stroke();

                // Mouth (Smile)
                var mouthRadius = 30; // Smaller mouth
                var mouthX = w - (radius * 0.45);
                var mouthY = h - (radius * 0.35);
                
                ctx.beginPath();
                ctx.arc(mouthX, mouthY, mouthRadius, 0.2 * Math.PI, 0.7 * Math.PI);
                ctx.stroke();
            }
            
            // Re-paint when theme changes
            Connections {
                target: Theme
                function onColorChanged() { faceCanvas.requestPaint() }
            }
        }

        // Time "12:36"
        Text {
            id: timeText
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 24
            anchors.topMargin: 24
            text: Qt.formatTime(root.currentDate, "hh:mm")
            font.family: Theme.typography.displayLarge.family
            font.pixelSize: 84
            font.weight: Font.Bold
            color: Theme.color.onSurfaceColor
        }

        // Date Info
        Column {
            anchors.left: parent.left
            anchors.top: timeText.bottom
            anchors.leftMargin: 24
            anchors.topMargin: 0
            spacing: 4

            Text {
                text: Qt.formatDate(root.currentDate, "dddd") // Monday
                font.family: Theme.typography.titleLarge.family
                font.pixelSize: 28
                font.weight: Font.Bold
                color: Theme.color.primary
            }

            Text {
                text: Qt.formatDate(root.currentDate, "d MMM") // 27 Sept
                font.family: Theme.typography.titleLarge.family
                font.pixelSize: 28
                font.weight: Font.Bold
                color: Theme.color.primary
                opacity: 0.8
            }
        }
    }
}

