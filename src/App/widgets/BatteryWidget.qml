import QtQuick
import QtQuick.Layouts
import md3.Core
Item {
    id: root
    implicitWidth: 320
    implicitHeight: 320

    // Properties for customization
    property int batteryPercentage: 60
    property bool isCharging: true

    // Background
    Rectangle {
        anchors.fill: parent
        radius: 32
        color: Theme.color.surfaceContainerHighest
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 0

        // Top Text Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            // Percentage Text
            Text {
                text: root.batteryPercentage + "%"
                font.family: Theme.typography.displayLarge.family
                font.pixelSize: 48
                font.weight: Font.Bold
                color: Theme.color.onSurfaceColor
            }

            // Charging Text
            Text {
                text: "CHARGING"
                font.family: Theme.typography.labelLarge.family
                font.pixelSize: 24
                font.weight: Font.DemiBold
                color: Theme.color.onSurfaceColor
                visible: root.isCharging
            }
        }
        
        Item { Layout.fillHeight: true } // Spacer

        // Battery Visual
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            Layout.alignment: Qt.AlignBottom

            // Canvas to draw the battery with partial fill and rounded corners
            Canvas {
                id: batteryCanvas
                anchors.fill: parent
                
                property color emptyColor: Theme.color.primaryContainer
                property color fillColor: Theme.color.primary
                property real fillRatio: 0.65 // Visual fill ratio (different from text percentage)
                
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var w = width;
                    var h = height;
                    var r = 32; // Corner radius

                    // 1. Draw Background (Empty part)
                    ctx.beginPath();
                    ctx.roundedRect(0, 0, w, h, r, r);
                    ctx.fillStyle = emptyColor;
                    ctx.fill();

                    // 2. Draw Fill (Charged part)
                    // We need to clip the fill to the rounded rectangle shape
                    ctx.save();
                    ctx.beginPath();
                    ctx.roundedRect(0, 0, w, h, r, r);
                    ctx.clip(); // Set clipping region to the full rounded rect

                    // Draw the fill rectangle
                    var fillWidth = w * fillRatio;
                    ctx.fillStyle = fillColor;
                    ctx.fillRect(0, 0, fillWidth, h);
                    
                    ctx.restore();
                }

                Connections {
                    target: Theme
                    function onColorChanged() { batteryCanvas.requestPaint() }
                }
            }
        }
        
        Item { Layout.preferredHeight: 24 } // Bottom margin spacer
    }
}

