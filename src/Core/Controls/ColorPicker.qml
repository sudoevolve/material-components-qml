import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import md3.Core
ColumnLayout {
    id: root
    spacing: 16

    property bool asSeedColor: true // For compability
    property bool hasAlpha: false   // Also for compability
    property string title: ""
    property string hueText: "Hue"
    property string chromaText: "Chroma"
    property string toneText: "Tone"
    property string alphaText: "Alpha"
    property color selectedColor: StyleManager.seedColor

    Connections {
        target: StyleManager
        enabled: root.asSeedColor
        function onSeedColorChanged() {
            root.selectedColor = StyleManager.seedColor;
        }
    }

    onSelectedColorChanged: {
        hueSlider.value = ColorHelper.hue(selectedColor);
        chromaSlider.value = ColorHelper.chroma(selectedColor);
        toneSlider.value = ColorHelper.tone(selectedColor);
        alphaSlider.value = selectedColor.a;
    }

    // Header
    Text {
        visible: title !== ""
        text: title
        font.pixelSize: Theme.typography.titleMedium.size
        color: Theme.color.onSurfaceColor
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

            // Color hex + preview rectangle
            Rectangle {
                Layout.fillWidth: true
                height: 48; radius: 24
                color: selectedColor

                Text {
                    anchors.centerIn: parent
                    text: hasAlpha ? ColorHelper.ahex(root.selectedColor) : ColorHelper.hex(root.selectedColor)
                    font.pixelSize: Theme.typography.titleLarge.size
                    color: (0.299 * root.selectedColor.r + 0.587 * root.selectedColor.g + 0.114 * root.selectedColor.b) > 0.5 ? "black" : "white"
                }
            }

            // Helper to update seed color
            function updateSeed() {
                // Set seed color via StyleManager
                StyleManager.seedColor = selectedColor;
            }

            // Hue
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: hueText
                        color: Theme.color.onSurfaceColor
                        font.pixelSize: Theme.typography.bodyMedium.size
                    }
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
                    value: pressed ? value : ColorHelper.hue(root.selectedColor)
                    onMoved: {
                        selectedColor = ColorHelper.hct2QColor(hueSlider.value, chromaSlider.value, toneSlider.value);
                        if (root.asSeedColor)
                            contentCol.updateSeed();
                    }
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
                    Text {
                        text: chromaText
                        color: Theme.color.onSurfaceColor
                        font.pixelSize: Theme.typography.bodyMedium.size
                    }
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
                    value: pressed ? value : ColorHelper.chroma(root.selectedColor)
                    onMoved: {
                        selectedColor = ColorHelper.hct2QColor(hueSlider.value, chromaSlider.value, toneSlider.value);
                        if (root.asSeedColor)
                            contentCol.updateSeed();
                    }
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
                    Text {
                        text: toneText
                        color: Theme.color.onSurfaceColor
                        font.pixelSize: Theme.typography.bodyMedium.size
                    }
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
                    value: pressed ? value : ColorHelper.tone(root.selectedColor)
                    onMoved: {
                        selectedColor = ColorHelper.hct2QColor(hueSlider.value, chromaSlider.value, toneSlider.value);
                        if (root.asSeedColor)
                            contentCol.updateSeed();
                    }
                }

                // Value Gradient
                Rectangle {
                    Layout.fillWidth: true
                    height: 8; radius: 4
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "black" }
                        GradientStop { position: 1.0; color: "white" }
                    }
                }
            }

            // Alpha
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                visible: root.hasAlpha
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: root.alphaText
                        color: Theme.color.onSurfaceColor
                        font.pixelSize: Theme.typography.bodyMedium.size
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: (alphaSlider.value * 100).toFixed(1) + "%"
                        color: Theme.color.onSurfaceVariantColor
                        font.pixelSize: Theme.typography.bodyMedium.size
                    }
                }

                Slider {
                    id: alphaSlider
                    Layout.fillWidth: true
                    from: 0; to: 1
                    value: pressed ? value : root.selectedColor.a
                    onMoved: selectedColor.a = value
                }

                // Value Gradient
                Rectangle {
                    Layout.fillWidth: true
                    height: 8; radius: 4
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: Qt.rgba(selectedColor.r, selectedColor.g, selectedColor.b, 1) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }
            }
        }
    }
}

