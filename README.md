# Easystroke - X11 Gesture Recognition Application

Easystroke is a gesture recognition application for X11. It enables you to perform actions using mouse gestures.

## Features

- Mouse gesture recognition
- Customizable actions per application
- Stroke visualization and feedback
- Tray icon integration
- Multi-language support

## Build Requirements

### Modern Dependencies (Recommended)

For modern Linux distributions (Ubuntu 22.04+, Fedora 36+, etc.):

- C++17 compatible compiler (GCC 9+ or Clang 9+)
- GTK 3.24+ development libraries
- gtkmm-3.0 development libraries
- boost-serialization development libraries
- X11 development libraries (libx11, libxext, libxi, libxfixes, libxtst)
- dbus-glib development libraries
- gettext tools (xgettext, msgfmt, msgmerge)

### Ubuntu/Debian

```bash
sudo apt install build-essential libgtkmm-3.0-dev libdbus-glib-1-dev \
    libboost-serialization-dev libx11-dev libxext-dev libxi-dev \
    libxfixes-dev libxtst-dev gettext
```

### Fedora/RHEL

```bash
sudo dnf install gcc-c++ gtkmm3-devel dbus-glib-devel \
    boost-devel libX11-devel libXext-devel libXi-devel \
    libXfixes-devel libXtst-devel gettext-devel
```

### Arch Linux

```bash
sudo pacman -S base-devel gtkmm3 dbus-glib boost libx11 libxext \
    libxi libxfixes libxtst gettext
```

## Building

```bash
make -j$(nproc)
```

## Installation

```bash
sudo make install
```

This will install:
- Binary to `/usr/local/bin/easystroke`
- Icon to `/usr/local/share/icons/hicolor/scalable/apps/`
- Desktop file to `/usr/local/share/applications/`
- Translations to `/usr/local/share/locale/`

## Running

Start easystroke from the application menu, or run:

```bash
easystroke
```

The application will run in the background with a system tray icon.

## Development

### Modernization Status

This codebase has been modernized with:

- ✅ C++17 standard compilation
- ✅ Modern gettext tools (replacing intltool)
- ✅ Fixed deprecated GDK functions
- ✅ Updated boost serialization compatibility
- ✅ Fixed sigc++ compatibility issues

### Building with GTK 4 (Experimental)

GTK 4 support is under development. To build with GTK 4:

1. Install GTK 4 development libraries
2. Modify Makefile to use `gtkmm-4.0` instead of `gtkmm-3.0`
3. Note: Some functionality may not work correctly with GTK 4 yet

### Translation

To update translations:

```bash
make translate           # Extract translatable strings
make update-translations # Update existing translations
make compile-translations # Compile .mo files
```

### Troubleshooting

**Build fails with missing headers:**
- Ensure all development packages are installed
- Check that pkg-config can find the required libraries

**Runtime issues:**
- Make sure X11 is running
- Check that required libraries are installed
- Verify permissions for X11 input access

**GTK warnings:**
- Some deprecated function warnings are expected on older systems
- These don't affect functionality

## License

See the LICENSE file for details.

## Contributing

Contributions are welcome! Please ensure:
- Code compiles with C++17
- No new deprecation warnings
- Tests pass (when available)
- Documentation is updated