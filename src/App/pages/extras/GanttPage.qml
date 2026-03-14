import QtQuick
import QtQuick.Layouts
import md3.Core
import md3.Extras.Gantt 1.0

Item {
    id: root

    signal backClicked()

    property var ganttModel: ([
        {
            id: "phase",
            name: "Project",
            start: 0,
            end: 32,
            color: "#BCE7FF",
            children: [
                        { id: "req", name: "Requirement", start: 0, end: 6, progress: 0.35, color: "#FFB3BA" },
                        { id: "design", name: "Design", start: 4, end: 10, progress: 0.2, color: "#FFDFBA", deps: ["req"] },
                        { id: "impl", name: "Impl", start: 9, end: 22, progress: 0.1, color: "#BAFFC9", deps: ["design"] },
                        { id: "test", name: "Testing", start: 18, end: 28, progress: 0, color: "#BAE1FF", deps: ["impl"] },
                        { id: "release", name: "Release", start: 32, end: 32, color: "#E6C7FF", deps: ["test"] }
            ]
        }
    ])

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

            Text {
                text: "Gantt"
                font.family: Theme.typography.headlineSmall.family
                font.pixelSize: Theme.typography.headlineSmall.size
                font.weight: Theme.typography.headlineSmall.weight
                color: Theme.color.onSurfaceColor
            }

            Item { Layout.fillWidth: true }
        }

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            type: "filled"
            color: Theme.color.surfaceContainerLow

            GanttView {
                anchors.fill: parent
                anchors.margins: 16
                model: ganttModel
                autoRange: true
                dateHeader: true
                baseDate: new Date(2026, 0, 1)
                pixelsPerUnit: 18
                rowHeight: 40
                labelWidth: 320
            }
        }
    }
}
