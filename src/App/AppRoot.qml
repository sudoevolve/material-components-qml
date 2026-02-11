import QtQuick
import QtQuick.Layouts
import md3.Core

Item {
    id: root
    anchors.fill: parent

    property int currentNavIndex: 0

    ListModel {
        id: navModel
        ListElement { name: "Home"; page: "pages/HomePage.qml"; iconName: "home" }
        ListElement { name: "Components"; page: "pages/ComponentsPage.qml"; iconName: "smart_button" }
        ListElement { name: "Widgets"; page: "pages/WidgetsPage.qml"; iconName: "widgets" }
        ListElement { name: "Navigation"; page: "pages/NavigationPage.qml"; iconName: "menu" }
        ListElement { name: "Color"; page: "pages/ColorPage.qml"; iconName: "palette" }
        ListElement { name: "Typography"; page: "pages/TypographyPage.qml"; iconName: "text_fields" }
        ListElement { name: "Icons"; page: "pages/IconPage.qml"; iconName: "mood" }
        ListElement { name: "Settings"; page: "pages/SettingsPage.qml"; iconName: "settings" }
        ListElement { name: "About"; page: "pages/AboutPage.qml"; iconName: "info" }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        NavigationDrawer {
            id: navDrawer
            modal: false
            drawerWidth: 260
            title: "Material Design"

            ListView {
                anchors.fill: parent
                anchors.margins: 12
                model: navModel
                spacing: 4
                clip: true

                delegate: Rectangle {
                    width: parent.width
                    height: 56
                    radius: Theme.shape.cornerFull
                    color: root.currentNavIndex === index ? Theme.color.secondaryContainer : "transparent"

                    Ripple {
                        anchors.fill: parent
                        rippleColor: Theme.color.onSecondaryContainerColor
                        clipRadius: parent.radius
                        onClicked: {
                            if (root.currentNavIndex !== index) {
                                root.currentNavIndex = index
                            }
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 24
                        spacing: 12

                        Text {
                            text: iconName
                            font.family: Theme.iconFont.name
                            font.pixelSize: 24
                            Layout.alignment: Qt.AlignVCenter
                            verticalAlignment: Text.AlignVCenter
                            color: root.currentNavIndex === index ? Theme.color.onSecondaryContainerColor : Theme.color.onSurfaceVariantColor
                        }

                        Text {
                            text: name
                            font.family: Theme.typography.labelLarge.family
                            font.pixelSize: Theme.typography.labelLarge.size
                            font.weight: Theme.typography.labelLarge.weight
                            Layout.alignment: Qt.AlignVCenter
                            verticalAlignment: Text.AlignVCenter
                            color: root.currentNavIndex === index ? Theme.color.onSecondaryContainerColor : Theme.color.onSurfaceVariantColor
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

            Item {
                anchors.fill: parent

                Loader {
                    id: pageLoader
                    anchors.fill: parent
                    source: navModel.get(root.currentNavIndex).page

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
            }

            ParallelAnimation {
                id: enterAnim
                NumberAnimation { id: animOpacity; property: "opacity"; to: 1; duration: 300; easing.type: Easing.OutCubic }
                NumberAnimation { id: animY; property: "y"; to: 0; duration: 300; easing.type: Easing.OutCubic }
            }
        }
    }
}
