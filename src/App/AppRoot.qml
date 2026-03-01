import QtQuick
import QtQuick.Layouts
import md3.Core

Item {
    id: root
    anchors.fill: parent

    property var currentItem: navItems[0]

    property var navItems: [
        { type: "item", text: "Home", icon: "home", page: "pages/HomePage.qml" },
        { 
            type: "group", 
            text: "Components", 
            icon: "widgets",
            children: [
                { type: "item", text: "Core", icon: "smart_button", page: "pages/ComponentsPage.qml" },
                { type: "item", text: "Widgets", icon: "widgets", page: "pages/WidgetsPage.qml" },
                { type: "item", text: "Pro", icon: "workspace_premium", page: "pages/ProPage.qml" }
            ]
        },
        { type: "divider" },
        { 
            type: "group", 
            text: "Design", 
            icon: "palette",
            children: [
                { type: "item", text: "Navigation", icon: "menu", page: "pages/NavigationPage.qml" },
                { type: "item", text: "Color", icon: "palette", page: "pages/ColorPage.qml" },
                { type: "item", text: "Typography", icon: "text_fields", page: "pages/TypographyPage.qml" },
                { type: "item", text: "Icons", icon: "mood", page: "pages/IconPage.qml" }
            ]
        },
        { type: "divider" },
        { type: "item", text: "Settings", icon: "settings", page: "pages/SettingsPage.qml" },
        { type: "item", text: "About", icon: "info", page: "pages/AboutPage.qml" }
    ]

    RowLayout {
        anchors.fill: parent
        spacing: 0

        NavigationDrawer {
            id: navDrawer
            modal: false
            drawerWidth: 260
            title: "Material Design"
            model: root.navItems
            currentItem: root.currentItem
            onItemClicked: (itemData) => root.currentItem = itemData
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.color.background
            clip: true

            Item {
                anchors.fill: parent

                Loader {
                    anchors.fill: parent
                    sourceComponent: prodPageLoader
                }

                Component {
                    id: prodPageLoader

                    Loader {
                        id: pageLoader
                        anchors.fill: parent
                        source: root.currentItem ? root.currentItem.page : ""

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

                Component {
                    id: devPageLoader

                    Loader {
                        id: pageLoader
                        anchors.fill: parent
                        source: ProjectSourceDir + "/src/App/" + (root.currentItem ? root.currentItem.page : "")

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
            }

            ParallelAnimation {
                id: enterAnim
                NumberAnimation { id: animOpacity; property: "opacity"; to: 1; duration: 300; easing.type: Easing.OutCubic }
                NumberAnimation { id: animY; property: "y"; to: 0; duration: 300; easing.type: Easing.OutCubic }
            }
        }
    }

}
