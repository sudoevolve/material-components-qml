import QtQuick
import QtQuick.Layouts
import md3.Core

Item {
    id: root
    anchors.fill: parent
    property var appFeatures: (typeof AppFeatures !== "undefined" && AppFeatures) ? AppFeatures : ({})
    property bool hasPerformance: !!appFeatures.performance
    property bool canHotReload: !!appFeatures.hotReload && HotReloadEnabled && ProjectSourceDir

    property var currentItem: navItems[0]

    function playPageEnter(targetItem) {
        if (!targetItem) return
        enterAnim.stop()
        animOpacity.target = targetItem
        animY.target = targetItem
        targetItem.opacity = 0
        targetItem.y = 50
        enterAnim.start()
    }

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
                    id: pageHost
                    anchors.fill: parent
                    sourceComponent: root.canHotReload ? devPageLoader : prodPageLoader
                }

                Component {
                    id: prodPageLoader
                    Loader {
                        id: pageLoader
                        anchors.fill: parent
                        source: root.currentItem ? root.currentItem.page : ""

                        onLoaded: {
                            root.playPageEnter(item)
                        }
                    }
                }

                Component {
                    id: devPageLoader
                    Loader {
                        id: devHotReloadLoader
                        anchors.fill: parent
                        source: "qrc:/qt/qml/md3/Extras/HotReload/HotReloadLoader.qml"
                        onLoaded: {
                            if (!item) return
                            item.sourcePath = Qt.binding(function() {
                                return ProjectSourceDir + "/src/App/" + (root.currentItem ? root.currentItem.page : "")
                            })
                            item.reloadOnAnyChange = true
                        }

                        Connections {
                            target: devHotReloadLoader.item
                            ignoreUnknownSignals: true
                            function onLoaded() {
                                var hotLoader = devHotReloadLoader.item
                                if (!hotLoader || !hotLoader.hasOwnProperty("item")) return
                                root.playPageEnter(hotLoader["item"])
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

    Loader {
        id: globalPerfMonitorLoader
        active: root.hasPerformance
        source: "qrc:/qt/qml/md3/Extras/Performance/PerformanceMonitor.qml"
        onLoaded: {
            if (!item) return
            item.objectName = "GlobalPerformanceMonitor"
            item.floatingAlignment = Qt.AlignTop | Qt.AlignLeft
            item.visible = false
            item.z = 1000000
        }
    }
}
