import QtQuick
import QtQuick.Layouts
import md3.Core

Flickable {
    id: root
    contentWidth: width
    contentHeight: content.implicitHeight + 64
    clip: true

    ColumnLayout {
        id: content
        width: Math.min(parent.width - 48, 1200)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 32
        spacing: 32

        // Hero Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            Text {
                text: "Welcome to MD3"
                font: Theme.typography.displayMedium
                color: Theme.color.onSurfaceColor
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }

            Text {
                text: "A modern, high-performance Material Design 3 library for Qt Quick. Build beautiful desktop applications with ease."
                font: Theme.typography.bodyLarge
                color: Theme.color.onSurfaceVariantColor
                Layout.fillWidth: true
                Layout.maximumWidth: 800
                wrapMode: Text.WordWrap
                lineHeight: 1.4
            }

            RowLayout {
                Layout.topMargin: 16
                spacing: 12

                Button {
                    text: "Get Started"
                    icon: "rocket_launch"
                    type: "filled"
                    onClicked: Qt.openUrlExternally("https://meow2030.github.io/Qtcraft/")
                }

                Button {
                    text: "Documentation"
                    icon: "menu_book"
                    type: "outlined"
                    onClicked: Qt.openUrlExternally("https://github.com/sudoevolve")
                }
            }
        }

        // Features Grid
        GridLayout {
            Layout.fillWidth: true
            columns: root.width > 800 ? 3 : (root.width > 500 ? 2 : 1)
            columnSpacing: 16
            rowSpacing: 16

            // Feature 1
            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                type: "filled"
                padding: 24

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    Text {
                        text: "palette"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 32
                        color: Theme.color.primary
                    }

                    Text {
                        text: "Dynamic Theming"
                        font: Theme.typography.titleMedium
                        color: Theme.color.onSurfaceColor
                    }

                    Text {
                        text: "Generate color schemes from seed colors. Support for light and dark modes out of the box."
                        font: Theme.typography.bodyMedium
                        color: Theme.color.onSurfaceVariantColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        elide: Text.ElideRight
                    }
                }
            }

            // Feature 2
            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                type: "filled"
                padding: 24

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    Text {
                        text: "widgets"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 32
                        color: Theme.color.primary
                    }

                    Text {
                        text: "Rich Components"
                        font: Theme.typography.titleMedium
                        color: Theme.color.onSurfaceColor
                    }

                    Text {
                        text: "A comprehensive set of Material Design 3 components, from Buttons to Navigation Drawers."
                        font: Theme.typography.bodyMedium
                        color: Theme.color.onSurfaceVariantColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        elide: Text.ElideRight
                    }
                }
            }

            // Feature 3
            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                type: "filled"
                padding: 24

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    Text {
                        text: "speed"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 32
                        color: Theme.color.primary
                    }

                    Text {
                        text: "High Performance"
                        font: Theme.typography.titleMedium
                        color: Theme.color.onSurfaceColor
                    }

                    Text {
                        text: "Optimized for desktop. Includes performance monitoring tools and efficient rendering."
                        font: Theme.typography.bodyMedium
                        color: Theme.color.onSurfaceVariantColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        elide: Text.ElideRight
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
