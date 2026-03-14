import QtQuick
import QtQuick.Layouts
import md3.Core
import md3.Extras.Markdown 1.0

Item {
    id: root
    property string title: "Markdown"
    signal backClicked()

    property bool sanitizeEnabled: true
    property int dialect: MarkdownRenderer.GitHub

    property string markdownText: "# Markdown Preview\n\nThis module renders **Markdown** into RichText.\n\n- Lists\n- `inline code`\n- [Link](https://example.com)\n\n> Blockquote\n\n```cpp\nint add(int a, int b) {\n  return a + b;\n}\n```"

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
                text: "Markdown Support"
                font.family: Theme.typography.headlineSmall.family
                font.pixelSize: Theme.typography.headlineSmall.size
                font.weight: Theme.typography.headlineSmall.weight
                color: Theme.color.onSurfaceColor
            }

            Item { Layout.fillWidth: true }

            RowLayout {
                spacing: 8

                Button {
                    text: "Doc"
                    icon: "description"
                    type: "filledTonal"
                    height: 32
                    horizontalPadding: 16
                    onClicked: root.markdownText = "# Title\n\n## Section\n\nThis is *italic*, this is **bold**.\n\n- One\n- Two\n- Three"
                }

                Button {
                    text: "Code"
                    icon: "code"
                    type: "filledTonal"
                    height: 32
                    horizontalPadding: 16
                    onClicked: root.markdownText = "### Code Blocks\n\n```qml\nItem {\n  width: 200\n  height: 120\n}\n```\n\n`inline` and **bold**."
                }

                Button {
                    text: "Advanced"
                    icon: "auto_awesome"
                    type: "filledTonal"
                    height: 32
                    horizontalPadding: 16
                    onClicked: root.markdownText =
                               "# Advanced Markdown\n\n"
                               + "## Lists\n\n"
                               + "- Bullet A\n"
                               + "  - Nested A.1\n"
                               + "  - Nested A.2\n"
                               + "- Bullet B\n\n"
                               + "1. First\n"
                               + "2. Second\n"
                               + "3. Third\n\n"
                               + "## Quote & Divider\n\n"
                               + "> A blockquote with **bold** and `inline code`.\n\n"
                               + "---\n\n"
                               + "## Code Fence\n\n"
                               + "```cpp\n"
                               + "struct Point { int x; int y; };\n"
                               + "```\n\n"
                               + "## Links & Inline HTML\n\n"
                               + "- Normal link: [Qt](https://www.qt.io)\n"
                               + "- Unsafe link: <a href=\"javascript:alert('x')\">javascript:</a>\n"
                               + "- Inline HTML: <span onclick=\"alert('x')\">onclick attr</span>\n"
                               + "\n"
                               + "- [ ] task list item\n"
                               + "- [x] done item\n"
                               + "\n"
                               + "## Table\n\n"
                               + "| Name | Value |\n"
                               + "| --- | --- |\n"
                               + "| Alpha | 1 |\n"
                               + "| Beta | 2 |\n\n"
                               + "## Footnote\n\n"
                               + "Text with a footnote[^note].\n\n"
                               + "[^note]: Footnote content rendered at the bottom.\n\n"
                               + "## Highlight\n\n"
                               + "Use ==highlight== to mark important words.\n"
                }

                Switch {
                    text: "Sanitize"
                    checked: root.sanitizeEnabled
                    onClicked: root.sanitizeEnabled = checked
                }

                Button {
                    text: root.dialect === MarkdownRenderer.GitHub ? "GitHub" : "CommonMark"
                    icon: "tune"
                    type: "outlined"
                    height: 32
                    horizontalPadding: 16
                    onClicked: root.dialect = (root.dialect === MarkdownRenderer.GitHub)
                               ? MarkdownRenderer.CommonMark
                               : MarkdownRenderer.GitHub
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                color: Theme.color.surfaceContainerHighest
                radius: 12
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Text {
                        text: "Markdown"
                        color: Theme.color.onSurfaceVariantColor
                        font.family: Theme.typography.titleSmall.family
                        font.pixelSize: Theme.typography.titleSmall.size
                        font.weight: Theme.typography.titleSmall.weight
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.color.surfaceContainerLow
                        radius: 10
                        clip: true

                        TextEdit {
                            anchors.fill: parent
                            anchors.margins: 12
                            text: root.markdownText
                            wrapMode: TextEdit.Wrap
                            color: Theme.color.onSurfaceColor
                            font.family: Theme.typography.bodyLarge.family
                            font.pixelSize: Theme.typography.bodyLarge.size
                            selectByMouse: true
                            onTextChanged: root.markdownText = text
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                color: Theme.color.surfaceContainerHighest
                radius: 12
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Text {
                        text: "Preview"
                        color: Theme.color.onSurfaceVariantColor
                        font.family: Theme.typography.titleSmall.family
                        font.pixelSize: Theme.typography.titleSmall.size
                        font.weight: Theme.typography.titleSmall.weight
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.color.surfaceContainerLow
                        radius: 10
                        clip: true

                        Flickable {
                            anchors.fill: parent
                            contentWidth: width
                            contentHeight: previewWrap.implicitHeight + 24
                            clip: true

                            MarkdownText {
                                id: previewWrap
                                x: 12
                                y: 12
                                width: parent.width - 24
                                markdown: root.markdownText
                                sanitize: root.sanitizeEnabled
                                dialect: root.dialect
                            }
                        }
                    }
                }
            }
        }
    }
}
