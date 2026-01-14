import QtQuick
import QtQuick.Layouts
import md3
import "../components" as Md3

Item {
    id: root
    anchors.fill: parent

    RowLayout {
        anchors.fill: parent
        anchors.margins: 48
        spacing: 32

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
                    onClicked: Qt.openUrlExternally("https://m3.material.io/")
                }

                Md3.Button {
                    text: "About me"
                    type: "outlined"
                    onClicked: Qt.openUrlExternally("https://github.com/sudoevolve/material-components-qml")
                }
            }

            Item { height: 32; width: 1 }

            // Bottom section
            Text {
                text: "M3 Expressive: Design with emotion"
                font.family: Theme.typography.headlineMedium.family
                font.pixelSize: Theme.typography.headlineMedium.size
                color: Theme.color.onSurfaceColor
            }
             Text {
                text: "Build more usable and engaging products with emotion-driven UX. M3\nExpressive adds vibrant colors, intuitive motion, adaptive components,\nflexible typography, and contrasting shapes."
                font.family: Theme.typography.bodyLarge.family
                font.pixelSize: Theme.typography.bodyLarge.size
                color: Theme.color.onSurfaceVariantColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.maximumWidth: 600
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
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                height: 500
                width: 550
                itemWidth: 450
                itemHeight: 300
                type: "hero"
                spacing: 12
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
