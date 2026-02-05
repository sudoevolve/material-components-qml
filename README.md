# Material Design 3 for Qt Quick (QML)

<p align="center">
  <img src="preview/app_icon.svg" width="128" height="128" alt="Material Design 3 Icon">
</p>

This project implements **Material Design 3 (Material You)** components using Qt Quick (QML) and C++. It aims to provide a comprehensive set of UI components that follow the latest Google Material Design guidelines, complete with dynamic color support, adaptive layouts, and a desktop widget system.

## Preview

<table align="center">
  <tr>
    <td><img src="preview/0.png" width="300"/></td>
    <td><img src="preview/1.png" width="300"/></td>
  </tr>
  <tr>
    <td><img src="preview/2.png" width="300"/></td>
    <td><img src="preview/3.png" width="300"/></td>
  </tr>
  <tr>
    <td><img src="preview/4.png" width="300"/></td>
    <td><img src="preview/5.png" width="300"/></td>
  </tr>
</table>

## Features

- **Material Design 3 Components**: A comprehensive library of reusable QML components styled according to MD3 specifications.
- **Dynamic Color System**: Integrated with Google's `material-color-utilities` (C++) to support dynamic color generation from seed colors (Wallpaper-based theming simulation).
- **Desktop Widgets**: A framework for creating and managing standalone desktop widgets (similar to Windows Gadgets or Rainmeter).
- **Theming**: Centralized `Theme` singleton for easy customization of typography, colors, and shapes.
- **Cross-Platform**: Built with Qt 6, supporting Windows, macOS, and Linux.

## Available Components

### Actions & Inputs
- **Buttons**: `Button`, `IconButton`, `FAB`, `SegmentedButton`
- **Selection**: `Checkbox`, `RadioButton`, `Switch`, `Slider`, `ComboBox`
- **Text**: `TextField`
- **Pickers**: `DatePicker`, `TimePicker`, `ColorPicker`

### Navigation
- **Structure**: `NavigationDrawer`, `NavigationBar`, `TopAppBar`, `SideSheet`
- **Wayfinding**: `Tabs`, `Breadcrumb`
- **Menus**: `Menu`

### Display & Feedback
- **Containers**: `Card`, `Carousel`, `Dialog`, `Chip`
- **Status**: `CircularProgress`, `LinearProgress`, `LoadingIndicator`, `ToolTip`
- **Visuals**: `Ripple`

## Project Structure

- `src/`: The core library code (Material Design 3 components and C++ backend).
- `examples/`: An example application demonstrating how to use the components and widgets.

## Build & Run

### Prerequisites

- **Qt 6.8** or higher (Required for latest QML features)
- **CMake** 3.16+
- **C++ Compiler** (supporting C++17 or higher)

### Build the Project

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/material-components-qml.git
    cd material-components-qml/md3
    ```

2.  **Configure with CMake**:
    ```bash
    mkdir build
    cd build
    cmake ..
    ```

3.  **Build**:
    ```bash
    cmake --build .
    ```

4.  **Run Example**:
    - On Windows: `.\examples\appmd3.exe` (or inside Debug/Release folders depending on generator)
    - On Linux/macOS: `./examples/appmd3`

## Usage in Your Project

You can use this library in your own projects in two ways:

### Option 1: Source Integration (Recommended for development)

Simply copy the `src` directory into your project (e.g., as a git submodule) and add it to your `CMakeLists.txt`:

```cmake
# Add the library subdirectory
add_subdirectory(path/to/md3/src)

# Link your application against the library
target_link_libraries(your_app PRIVATE md3::md3)
```

### Option 2: Installed Library

Build and install the library to your system or a local directory:

```bash
# Build and Install
cmake -B build
cmake --build build
cmake --install build --prefix "C:/MyLibs/md3"  # Change path as needed
```

Then in your project's `CMakeLists.txt`:

```cmake
# Find the installed package
find_package(md3 REQUIRED)

# Link your application
target_link_libraries(your_app PRIVATE md3::md3)
```

### QML Usage

In your QML files, import the module:

```qml
import QtQuick
import md3

ApplicationWindow {
    visible: true
    width: 800
    height: 600

    // Use MD3 Components
    Button {
        text: "Hello MD3"
        onClicked: console.log("Clicked!")
        anchors.centerIn: parent
    }

    // Access Theme
    Rectangle {
        color: Theme.primary
        // ...
    }
}
```

## Desktop Widgets

The project includes a desktop widget manager that allows you to run QML components as independent, frameless desktop windows.

- **Manage**: Create, pin, and organize widgets on your desktop.

## Project Scaffold

A PowerShell scaffold script is provided to quickly generate new projects based on this library.

**Usage:**

1. Open PowerShell in the `md3` root directory.
2. Run the scaffold script:
   ```powershell
   ./scaffold/scaffold.ps1
   ```
3. Follow the prompts to create a new project with your desired name and template.
