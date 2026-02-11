import QtQuick
import QtQuick.Layouts
import md3.Core
import "../widgets" as Widgets

Item {
    id: root
    width: parent.width
    height: parent.height

    Flickable {
        anchors.fill: parent
        contentHeight: contentLayout.height + 32
        clip: true
        pressDelay: 150 // Delay to allow children to grab touch events (e.g., long press)

        ColumnLayout {
            id: contentLayout
            width: Math.min(parent.width - 32, 600)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 16
            spacing: 24

            Text {
                text: "Widgets"
                font.family: Theme.typography.displayMedium.family
                font.pixelSize: Theme.typography.displayMedium.size
                font.weight: Theme.typography.displayMedium.weight
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Material Design 3 Widgets"
                font.family: Theme.typography.titleMedium.family
                font.pixelSize: Theme.typography.titleMedium.size
                color: Theme.color.onSurfaceVariantColor
                Layout.alignment: Qt.AlignHCenter
            }

            Widgets.DraggableWidgetWrapper {
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                Layout.alignment: Qt.AlignHCenter
                widgetSource: "ClockWidget.qml"

                Widgets.ClockWidget {
                    width: parent.width
                }
            }

            Widgets.DraggableWidgetWrapper {
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                Layout.alignment: Qt.AlignHCenter
                widgetSource: "GoogleSearchBar.qml"

                Widgets.GoogleSearchBar {
                    width: parent.width
                }
            }

            Widgets.DraggableWidgetWrapper {
                Layout.fillWidth: true
                Layout.maximumWidth: 320
                Layout.preferredHeight: 320
                Layout.alignment: Qt.AlignHCenter
                widgetSource: "GhostClockWidget.qml"

                Widgets.GhostClockWidget {
                    width: parent.width
                    height: parent.height
                }
            }

            Widgets.DraggableWidgetWrapper {
                Layout.fillWidth: true
                Layout.maximumWidth: 320
                Layout.preferredHeight: 320
                Layout.alignment: Qt.AlignHCenter
                widgetSource: "SleepyFaceClockWidget.qml"

                Widgets.SleepyFaceClockWidget {
                    width: parent.width
                    height: parent.height
                }
            }

            Widgets.DraggableWidgetWrapper {
                Layout.fillWidth: true
                Layout.maximumWidth: 320
                Layout.preferredHeight: 320
                Layout.alignment: Qt.AlignHCenter
                widgetSource: "AnalogClockWidget.qml"

                Widgets.AnalogClockWidget {
                    width: parent.width
                    height: parent.height
                }
            }

            Widgets.DraggableWidgetWrapper {
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                Layout.alignment: Qt.AlignHCenter
                widgetSource: "BatteryWidget.qml"

                Widgets.BatteryWidget {
                    width: parent.width
                }
            }
            
            Item { Layout.fillHeight: true }
        }
    }
}



