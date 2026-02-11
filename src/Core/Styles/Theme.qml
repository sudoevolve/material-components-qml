/*
 * Copyright (C) 2024-2026 sudoevolve (Aino) <sudoevolve@gmail.com>
 * https://github.com/sudoevolve
 * This file is part of the MD3 library.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 */

pragma Singleton
import QtQuick
import md3.Core

QtObject {
    id: theme

    // Material Design 3 Color Schemes
    property QtObject schemes: QtObject {
        property var light: StyleManager.lightScheme
        property var dark: StyleManager.darkScheme
    }

    // Default / Fallback Scheme
    property var defaultScheme: {
        "primary": "#6750A4",
        "onPrimaryColor": "#FFFFFF",
        "primaryContainer": "#EADDFF",
        "onPrimaryContainerColor": "#21005D",
        "secondary": "#625B71",
        "onSecondaryColor": "#FFFFFF",
        "secondaryContainer": "#E8DEF8",
        "onSecondaryContainerColor": "#1D192B",
        "tertiary": "#7D5260",
        "onTertiaryColor": "#FFFFFF",
        "tertiaryContainer": "#FFD8E4",
        "onTertiaryContainerColor": "#31111D",
        "error": "#B3261E",
        "onErrorColor": "#FFFFFF",
        "errorContainer": "#F9DEDC",
        "onErrorContainerColor": "#410E0B",
        "background": "#FFFBFE",
        "onBackgroundColor": "#1C1B1F",
        "surface": "#FFFBFE",
        "onSurfaceColor": "#1C1B1F",
        "surfaceVariant": "#E7E0EC",
        "onSurfaceVariantColor": "#49454F",
        "outline": "#79747E",
        "outlineVariant": "#CAC4D0",
        "shadow": "#000000",
        "scrim": "#000000",
        "inverseSurface": "#313033",
        "inverseOnSurface": "#F4EFF4",
        "inversePrimary": "#D0BCFF",
        "surfaceDim": "#DED8E1",
        "surfaceBright": "#FEF7FF",
        "surfaceContainerLowest": "#FFFFFF",
        "surfaceContainerLow": "#F7F2FA",
        "surfaceContainer": "#F3EDF7",
        "surfaceContainerHigh": "#ECE6F0",
        "surfaceContainerHighest": "#E6E0E9"
    }

    // Active Color Scheme
    property var color: (StyleManager && StyleManager.currentScheme && Object.keys(StyleManager.currentScheme).length > 0) 
                        ? StyleManager.currentScheme 
                        : defaultScheme

    // Icon Font
    property FontLoader iconFont: FontLoader {
        source: "assets/MaterialIconsRound-Regular.otf"
    }

    // Typography
    property QtObject typography: QtObject {
        property QtObject displayLarge: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 57
            property real lineHeight: 64
            property real tracking: -0.25
        }
        property QtObject displayMedium: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 45
            property real lineHeight: 52
            property real tracking: 0
        }
        property QtObject displaySmall: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 36
            property real lineHeight: 44
            property real tracking: 0
        }
        property QtObject headlineLarge: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 32
            property real lineHeight: 40
            property real tracking: 0
        }
        property QtObject headlineMedium: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 28
            property real lineHeight: 36
            property real tracking: 0
        }
        property QtObject headlineSmall: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 24
            property real lineHeight: 32
            property real tracking: 0
        }
        property QtObject titleLarge: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 22
            property real lineHeight: 28
            property real tracking: 0
        }
        property QtObject titleMedium: QtObject {
            property string family: "Roboto"
            property int weight: Font.Medium
            property int size: 16
            property real lineHeight: 24
            property real tracking: 0.15
        }
        property QtObject titleSmall: QtObject {
            property string family: "Roboto"
            property int weight: Font.Medium
            property int size: 14
            property real lineHeight: 20
            property real tracking: 0.1
        }
        property QtObject labelLarge: QtObject {
            property string family: "Roboto"
            property int weight: Font.Medium
            property int size: 14
            property real lineHeight: 20
            property real tracking: 0.1
        }
        property QtObject labelMedium: QtObject {
            property string family: "Roboto"
            property int weight: Font.Medium
            property int size: 12
            property real lineHeight: 16
            property real tracking: 0.5
        }
        property QtObject labelSmall: QtObject {
            property string family: "Roboto"
            property int weight: Font.Medium
            property int size: 11
            property real lineHeight: 16
            property real tracking: 0.5
        }
        property QtObject bodyLarge: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 16
            property real lineHeight: 24
            property real tracking: 0.5
        }
        property QtObject bodyMedium: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 14
            property real lineHeight: 20
            property real tracking: 0.25
        }
        property QtObject bodySmall: QtObject {
            property string family: "Roboto"
            property int weight: Font.Normal
            property int size: 12
            property real lineHeight: 16
            property real tracking: 0.4
        }
    }

    // Shapes
    property QtObject shape: QtObject {
        property int cornerNone: 0
        property int cornerExtraSmall: 4
        property int cornerSmall: 8
        property int cornerMedium: 12
        property int cornerLarge: 16
        property int cornerExtraLarge: 28
        property int cornerFull: 1000 // Effectively circular/pill
    }

    // Elevations
    property QtObject elevation: QtObject {
        property int level0: 0
        property int level1: 1
        property int level2: 3
        property int level3: 6
        property int level4: 8
        property int level5: 12
    }

    // State Opacities
    property QtObject state: QtObject {
        property real draggedStateLayerOpacity: 0.16
        property real focusStateLayerOpacity: 0.12
        property real hoverStateLayerOpacity: 0.08
        property real pressedStateLayerOpacity: 0.12
    }
}
