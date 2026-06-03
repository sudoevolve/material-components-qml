import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import md3.Core

Window {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "{{PROJECT_NAME}}"
    color: Theme.color.background

    property int currentIndex: 0

    // ── Navigation model ───────────────────────────────────────────────
    // Extras page is only listed when its QML file exists on disk.
    // This way the template works with or without the Extras folder.
    readonly property bool hasExtras: {
        let r = Qt.createComponent("pages/ExtrasPage.qml");
        let ok = r.status === Component.Ready;
        r.destroy();
        return ok;
    }

    ListModel {
        id: navModel
        ListElement { name: "Home"; page: "pages/HomePage.qml"; iconName: "home" }
        ListElement { name: "Settings"; page: "pages/SettingsPage.qml"; iconName: "settings" }
    }

    Component.onCompleted: {
        if (window.hasExtras) {
            navModel.append({ name: "Extras", page: "pages/ExtrasPage.qml", iconName: "extension" });
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        NavigationDrawer {
            id: nav
            modal: false
            drawerWidth: 260
            title: "{{PROJECT_NAME}}"

            ListView {
                anchors.fill: parent
                anchors.margins: 12
                model: navModel
                spacing: 6
                clip: true

                delegate: Rectangle {
                    width: parent.width
                    height: 56
                    radius: Theme.shape.cornerFull
                    color: window.currentIndex === index ? Theme.color.secondaryContainer : "transparent"

                    Ripple {
                        anchors.fill: parent
                        rippleColor: Theme.color.onSecondaryContainerColor
                        clipRadius: parent.radius
                        onClicked: window.currentIndex = index
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12

                        Text {
                            text: iconName
                            font.family: Theme.iconFont.name
                            font.pixelSize: 22
                            color: window.currentIndex === index ? Theme.color.onSecondaryContainerColor : Theme.color.onSurfaceVariantColor
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: name
                            font: Theme.typography.labelLarge
                            color: window.currentIndex === index ? Theme.color.onSecondaryContainerColor : Theme.color.onSurfaceVariantColor
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.color.background
            clip: true

            Loader {
                id: pageLoader
                anchors.fill: parent
                source: navModel.get(window.currentIndex).page

                onLoaded: {
                    if (item) {
                        enterAnim.stop()
                        animOpacity.target = item
                        animY.target = item
                        item.opacity = 0
                        item.y = 50
                        enterAnim.start()
                    }
                }
            }

            ParallelAnimation {
                id: enterAnim
                NumberAnimation { id: animOpacity; property: "opacity"; to: 1; duration: 300; easing.type: Easing.OutCubic }
                NumberAnimation { id: animY; property: "y"; to: 0; duration: 300; easing.type: Easing.OutCubic }
            }
        }
    }
}
