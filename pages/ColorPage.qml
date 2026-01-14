import QtQuick
import QtQuick.Layouts
import md3
import "../components" as Md3

Item {
    anchors.fill: parent

    // Data definition for color groups to avoid repetition
    property var colorGroups: [
        {
            title: "Primary",
            roles: ["primary", "onPrimaryColor", "primaryContainer", "onPrimaryContainerColor", "inversePrimary"]
        },
        {
            title: "Secondary",
            roles: ["secondary", "onSecondaryColor", "secondaryContainer", "onSecondaryContainerColor"]
        },
        {
            title: "Tertiary",
            roles: ["tertiary", "onTertiaryColor", "tertiaryContainer", "onTertiaryContainerColor"]
        },
        {
            title: "Error",
            roles: ["error", "onErrorColor", "errorContainer", "onErrorContainerColor"]
        },
        {
            title: "Surface",
            roles: ["surface", "onSurfaceColor", "surfaceVariant", "onSurfaceVariantColor", "inverseSurface", "inverseOnSurface"]
        },
        {
            title: "Surface Container",
            roles: ["surfaceContainerLowest", "surfaceContainerLow", "surfaceContainer", "surfaceContainerHigh", "surfaceContainerHighest", "surfaceDim", "surfaceBright"]
        },
        {
            title: "Background",
            roles: ["background", "onBackgroundColor"]
        },
        {
            title: "Outline",
            roles: ["outline", "outlineVariant"]
        }
    ]

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: mainLayout.implicitHeight + 48
        clip: true


    // Component to render a single color strip
    component ColorStrip: Rectangle {
        property string roleName
        property string roleValue
        property string onRoleName // Simple heuristic for text color if not provided
        property color roleColor
        property color onColor
        
        width: parent.width
        height: 56
        color: roleColor
        
        TextEdit {
            id: clipboardHelper
            visible: false
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                clipboardHelper.text = roleValue
                clipboardHelper.selectAll()
                clipboardHelper.copy()
                copyToast.text = "Copied: " + roleValue
                copyToast.open()
            }
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            
            Text {
                text: roleName
                font.family: Theme.typography.bodyMedium.family
                font.pixelSize: Theme.typography.bodyMedium.size
                font.weight: Theme.typography.bodyMedium.weight
                color: onColor
            }
            
            Item { Layout.fillWidth: true }
            
            Text {
                text: roleValue
                font.family: Theme.typography.bodySmall.family
                font.pixelSize: Theme.typography.bodySmall.size
                font.weight: Theme.typography.bodySmall.weight
                color: onColor
                opacity: 0.8
            }
        }
    }

    // Component to render a full column for a scheme (Light or Dark)
    component SchemeColumn: ColumnLayout {
        property string title
        property var scheme
        
        spacing: 24
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        
        Text {
            text: title
            font.family: Theme.typography.headlineSmall.family
            font.pixelSize: Theme.typography.headlineSmall.size
            font.weight: Theme.typography.headlineSmall.weight
            color: Theme.color.onSurfaceColor
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 24
        }

        Repeater {
            model: colorGroups
            
            ColumnLayout {
                property var groupData: modelData
                Layout.fillWidth: true
                spacing: 8
                
                Text {
                    text: groupData.title
                    font.family: Theme.typography.titleMedium.family
                    font.pixelSize: Theme.typography.titleMedium.size
                    font.weight: Theme.typography.titleMedium.weight
                    color: Theme.color.onSurfaceColor
                    Layout.leftMargin: 4
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: stripColumn.height
                    radius: Theme.shape.cornerMedium
                    color: "transparent"
                    clip: true
                    
                    Column {
                        id: stripColumn
                        width: parent.width
                        
                        Repeater {
                            model: groupData.roles
                            
                            ColorStrip {
                                property string role: modelData
                                roleName: role
                                roleColor: scheme[role]
                                roleValue: roleColor.toString()
                                
                                // Determine text color (onColor) logic
                                onColor: {
                                    // Map background roles to their 'on' counterparts
                                    if (role === "primary") return scheme.onPrimaryColor
                                    if (role === "primaryContainer") return scheme.onPrimaryContainerColor
                                    if (role === "secondary") return scheme.onSecondaryColor
                                    if (role === "secondaryContainer") return scheme.onSecondaryContainerColor
                                    if (role === "tertiary") return scheme.onTertiaryColor
                                    if (role === "tertiaryContainer") return scheme.onTertiaryContainerColor
                                    if (role === "error") return scheme.onErrorColor
                                    if (role === "errorContainer") return scheme.onErrorContainerColor
                                    if (role === "background") return scheme.onBackgroundColor
                                    if (role === "surface") return scheme.onSurfaceColor
                                    if (role === "surfaceVariant") return scheme.onSurfaceVariantColor
                                    if (role === "inverseSurface") return scheme.inverseOnSurface
                                    if (role === "inversePrimary") return scheme.primaryContainer // Approx
                                    if (role === "outline") return scheme.surface
                                    if (role === "outlineVariant") return scheme.onSurfaceVariantColor
                                    
                                    // 'On' colors usually sit on the main color, so text on them should be the main color
                                    if (role.startsWith("on")) {
                                        let baseRole = role.substring(2)
                                        if (baseRole.endsWith("Color")) baseRole = baseRole.substring(0, baseRole.length - 5) // Handle legacy naming if any
                                        // e.g. onPrimary -> primary
                                        // e.g. onPrimaryContainer -> primaryContainer
                                        
                                        // Special case adjustment for simple string matching
                                        let firstChar = baseRole.charAt(0).toLowerCase()
                                        let rest = baseRole.substring(1)
                                        let target = firstChar + rest
                                        
                                        if (scheme[target]) return scheme[target]
                                        return scheme.primary // Fallback
                                    }
                                    
                                    // Surface containers
                                    if (role.startsWith("surfaceContainer") || role === "surfaceDim" || role === "surfaceBright") {
                                        return scheme.onSurfaceColor
                                    }
                                    
                                    return scheme.onSurfaceColor // Fallback
                                }
                            }
                        }
                    }
                }
            }
        }
        
        Item { height: 24 }
    }

    RowLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.margins: 24
            spacing: 24
            
            // Left: Light Scheme
            SchemeColumn {
                title: "Light Scheme"
                scheme: Theme.schemes.light
            }
            
            // Right: Dark Scheme
            SchemeColumn {
                title: "Dark Scheme"
                scheme: Theme.schemes.dark
            }
        }
    }

    // Global ToolTip Overlay
    Md3.ToolTip {
        id: copyToast
    }
}
