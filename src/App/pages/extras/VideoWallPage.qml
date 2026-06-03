import QtQuick
import QtQuick.Layouts
import md3.Core
import md3.Extras.VideoWall 1.0

Item {
    id: root

    signal backClicked()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Item {
                width: 40
                height: 40

                Rectangle {
                    anchors.fill: parent
                    radius: 20
                    color: backMouse.containsMouse ? Theme.color.surfaceContainerHigh : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "arrow_back"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                    }

                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.backClicked()
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "Multi-Source Video Wall"
                    font.family: Theme.typography.headlineSmall.family
                    font.pixelSize: Theme.typography.headlineSmall.size
                    font.weight: Theme.typography.headlineSmall.weight
                    color: Theme.color.onSurfaceColor
                }

                Text {
                    text: "Display-only monitoring wall with external video surfaces, drag layout, GPU grading, watermark and ROI control."
                    font.family: Theme.typography.bodyMedium.family
                    font.pixelSize: Theme.typography.bodyMedium.size
                    color: Theme.color.onSurfaceVariantColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            type: "filled"
            color: Theme.color.surfaceContainerLow

            VideoWallView {
                anchors.fill: parent
                anchors.margins: 16
            }
        }
    }
}
