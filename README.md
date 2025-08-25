# Easystroke - Gesture Recognition for X11

Easystroke is a gesture recognition application for X11 that allows you to perform actions using mouse gestures.

## Build Requirements

### Modernized for Latest Ubuntu (2024)

This version has been modernized to work with current Ubuntu releases and uses updated build tools and standards.

#### System Requirements
- **C++ Compiler**: GCC 9+ or Clang 10+ with C++17 support
- **C Compiler**: GCC 9+ or Clang 10+ with C17 support

#### Dependencies
- **GTK**: gtkmm-3.0 (>= 3.24)
- **Boost**: libboost-serialization (>= 1.60)
- **X11 Libraries**:
  - libX11-dev
  - libXext-dev
  - libXi-dev
  - libXfixes-dev
  - libXtst-dev
- **D-Bus**: libdbus-glib-1-dev
- **Build Tools**:
  - intltool (for internationalization)
  - help2man (for manual generation)
  - pkg-config

#### Ubuntu/Debian Installation
```bash
sudo apt update
sudo apt install -y \
    build-essential \
    libgtkmm-3.0-dev \
    libdbus-glib-1-dev \
    libboost-serialization-dev \
    libx11-dev \
    libxext-dev \
    libxi-dev \
    libxfixes-dev \
    libxtst-dev \
    xserver-xorg-dev \
    intltool \
    help2man \
    pkg-config
```

## Building

```bash
make
```

## Installation

```bash
sudo make install
```

## Changes from Original

This modernized version includes:
- **Updated C++ standard**: C++11 → C++17
- **Updated C standard**: C11 → C17
- **Fixed compatibility issues**: 
  - sigc++ 3.0+ compatibility
  - Removed deprecated Gtk::Stock usage
  - Fixed std::abs conflicts
  - Fixed Boost serialization template instantiation
- **Enhanced compiler flags**: Added -Wextra for better warnings
- **Documented dependencies**: Clear version requirements
- **Boost version requirements**: Requires >= 1.60

## Compatibility

- **Tested on**: Ubuntu 24.04 LTS
- **GTK version**: 3.24+
- **Boost version**: 1.83+
- **Compiler**: GCC 13+

## Legacy Support

For older systems, use the original easystroke with C++11/C11 standards.