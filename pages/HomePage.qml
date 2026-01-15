import QtQuick
import QtQuick.Layouts
import md3
import "../components" as Md3

Item {
    id: root
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 48
        spacing: 24

        // Upper Section: Left Content + Right Carousel
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 64

            // Left Content
            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                spacing: 24
                
                // Spacer to push content to center vertically
                Item { Layout.fillHeight: true }

                Text {
                    text: "Material\nDesign"
                    font.family: Theme.typography.displayLarge.family
                    font.pixelSize: 100 
                    font.weight: Theme.typography.displayLarge.weight
                    color: Theme.color.onSurfaceColor
                    lineHeight: 0.9
                }

                Text {
                    text: "Material Design 3 is Google’s open-source design system for\nbuilding beautiful, usable products."
                    font.family: Theme.typography.headlineSmall.family
                    font.pixelSize: Theme.typography.headlineSmall.size
                    color: Theme.color.onSurfaceVariantColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.maximumWidth: 600
                }

                Item { height: 16; width: 1 }

                RowLayout {
                    spacing: 12

                    Md3.Button {
                        text: "Get started"
                        type: "filled"
                        onClicked: Qt.openUrlExternally("https://github.com/sudoevolve/material-components-qml")
                    }

                    Md3.Button {
                        text: "About MD3"
                        type: "outlined"
                        onClicked: Qt.openUrlExternally("https://m3.material.io/")    
                    }
                }

                // Spacer
                Item { Layout.fillHeight: true }
            }

            // Right Content (Carousel)
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: 1

                Md3.Carousel {
                    id: heroCarousel
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 64
                    height: 500
                    width: 550
                    itemWidth: 450
                    itemHeight: 300
                    type: "hero"
                    spacing: 12
                }
            }
        }

        // Bottom Features Section
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 32
            spacing: 24

            // Feature 1
            Md3.Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                type: "filled"
                color: Theme.color.surfaceContainerLow

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 12

                    Text {
                        text: "widgets" // Icon name
                        font.family: Theme.iconFont.name
                        font.pixelSize: 32
                        color: Theme.color.primary
                    }

                    Text {
                        text: "Components"
                        font.family: Theme.typography.titleLarge.family
                        font.pixelSize: Theme.typography.titleLarge.size
                        font.weight: Theme.typography.titleLarge.weight
                        color: Theme.color.onSurfaceColor
                    }

                    Text {
                        text: "Includes a wide range of MD3 components like Navigation Drawer, FAB, Cards, and more, ready to use."
                        font.family: Theme.typography.bodyMedium.family
                        font.pixelSize: Theme.typography.bodyMedium.size
                        color: Theme.color.onSurfaceVariantColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }

            // Feature 2
            Md3.Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                type: "filled"
                color: Theme.color.surfaceContainerLow

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 12

                    Text {
                        text: "palette" // Icon name
                        font.family: Theme.iconFont.name
                        font.pixelSize: 32
                        color: Theme.color.primary
                    }

                    Text {
                        text: "Dynamic Theming"
                        font.family: Theme.typography.titleLarge.family
                        font.pixelSize: Theme.typography.titleLarge.size
                        font.weight: Theme.typography.titleLarge.weight
                        color: Theme.color.onSurfaceColor
                    }

                    Text {
                        text: "Built-in support for Material You dynamic color system, dark mode, and customizable typography."
                        font.family: Theme.typography.bodyMedium.family
                        font.pixelSize: Theme.typography.bodyMedium.size
                        color: Theme.color.onSurfaceVariantColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }

            // Feature 3
            Md3.Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                type: "filled"
                color: Theme.color.surfaceContainerLow

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 12

                    Text {
                        text: "devices" // Icon name
                        font.family: Theme.iconFont.name
                        font.pixelSize: 32
                        color: Theme.color.primary
                    }

                    Text {
                        text: "Cross-Platform"
                        font.family: Theme.typography.titleLarge.family
                        font.pixelSize: Theme.typography.titleLarge.size
                        font.weight: Theme.typography.titleLarge.weight
                        color: Theme.color.onSurfaceColor
                    }

                    Text {
                        text: "Powered by Qt Quick, ensuring high performance and native look and feel on Windows, macOS, and Linux."
                        font.family: Theme.typography.bodyMedium.family
                        font.pixelSize: Theme.typography.bodyMedium.size
                        color: Theme.color.onSurfaceVariantColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        var urls = []
        for (var i = 0; i <= 4; i++) {
            urls.push("https://github.com/sudoevolve/material-components-qml/raw/main/introduce/" + i + ".jpg")
        }
        heroCarousel.model = urls
    }
}
