import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import md3

ColumnLayout {
    id: root
    spacing: 16

    // Header
    Text {
        text: "Theme Controls"
        font.pixelSize: Theme.typography.headlineSmall.size
        color: Theme.color.onSurfaceColor
        font.weight: Font.Bold
        Layout.alignment: Qt.AlignLeft
    }

    // Card Background
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: contentCol.implicitHeight + 48
        radius: 16
        color: Theme.color.surfaceContainerLow 

        ColumnLayout {
            id: contentCol
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            // Hex Source Color
            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Text {
                    text: "Hex Source Color"
                    font.pixelSize: Theme.typography.bodyLarge.size
                    color: Theme.color.onSurfaceColor
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 48
                    height: 48
                    radius: 24
                    color: StyleManager.seedColor
                    border.width: 1
                    border.color: Theme.color.outline
                }
            }

            // Helper to update seed color
            function updateSeed() {
                // Use HCT directly via StyleManager
                StyleManager.setSeedColorHct(hueSlider.value, chromaSlider.value, toneSlider.value)
            }

            // Hue
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "Hue"; color: Theme.color.onSurfaceColor; font.pixelSize: Theme.typography.bodyMedium.size }
                    Item { Layout.fillWidth: true }
                    Text { 
                        text: Math.round(hueSlider.value)
                        color: Theme.color.onSurfaceVariantColor
                        font.pixelSize: Theme.typography.bodyMedium.size 
                    }
                }
                
                Slider {
                    id: hueSlider
                    Layout.fillWidth: true
                    from: 0; to: 360
                    // Break binding when dragging to avoid jitter/loops
                    value: pressed ? value : StyleManager.hctHue
                    onMoved: contentCol.updateSeed()
                }
                
                // Rainbow Gradient
                Rectangle {
                    Layout.fillWidth: true; height: 8; radius: 4
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "red" }
                        GradientStop { position: 0.17; color: "yellow" }
                        GradientStop { position: 0.33; color: "lime" }
                        GradientStop { position: 0.5; color: "cyan" }
                        GradientStop { position: 0.66; color: "blue" }
                        GradientStop { position: 0.83; color: "magenta" }
                        GradientStop { position: 1.0; color: "red" }
                    }
                }
            }

            // Chroma
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "Chroma"; color: Theme.color.onSurfaceColor; font.pixelSize: Theme.typography.bodyMedium.size }
                    Item { Layout.fillWidth: true }
                    Text { 
                        text: Math.round(chromaSlider.value)
                        color: Theme.color.onSurfaceVariantColor
                        font.pixelSize: Theme.typography.bodyMedium.size 
                    }
                }
                
                Slider {
                    id: chromaSlider
                    Layout.fillWidth: true
                    from: 0; to: 150
                    value: pressed ? value : StyleManager.hctChroma
                    onMoved: contentCol.updateSeed()
                }
                
                // Saturation Gradient
                Rectangle {
                    Layout.fillWidth: true; height: 8; radius: 4
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "gray" }
                        GradientStop { position: 1.0; color: Qt.hsva(hueSlider.value/360, 1.0, toneSlider.value/100, 1.0) }
                    }
                }
            }

            // Tone
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "Tone"; color: Theme.color.onSurfaceColor; font.pixelSize: Theme.typography.bodyMedium.size }
                    Item { Layout.fillWidth: true }
                    Text { 
                        text: Math.round(toneSlider.value)
                        color: Theme.color.onSurfaceVariantColor
                        font.pixelSize: Theme.typography.bodyMedium.size 
                    }
                }
                
                Slider {
                    id: toneSlider
                    Layout.fillWidth: true
                    from: 0; to: 100
                    value: pressed ? value : StyleManager.hctTone
                    onMoved: contentCol.updateSeed()
                }
                
                // Value Gradient
                Rectangle {
                    Layout.fillWidth: true; height: 8; radius: 4
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "black" }
                        GradientStop { position: 1.0; color: "white" }
                    }
                }
            }
        }
    }
}
