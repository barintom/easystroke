# Ubuntu Build Guide for Easystroke

## Tested Environment
- **Ubuntu Version**: 24.04.3 LTS (Noble Numbat)
- **Compiler**: GCC 13 with C++17 support
- **Build Status**: ✅ **SUCCESSFULLY TESTED**

## Quick Start

### 1. Install Dependencies

```bash
sudo apt update
sudo apt install -y build-essential libgtkmm-3.0-dev libdbus-glib-1-dev \
    libboost-serialization-dev libx11-dev libxext-dev libxi-dev \
    libxfixes-dev libxtst-dev gettext pkg-config xserver-xorg-dev
```

### 2. Build

```bash
make -j$(nproc)
```

### 3. Install (Optional)

```bash
sudo make install
```

### 4. Run

```bash
# If installed system-wide:
easystroke

# If running from build directory:
./easystroke
```

## Detailed Instructions

### System Requirements

- Ubuntu 20.04 LTS or newer
- C++17 compatible compiler (GCC 9+ or Clang 9+)
- GTK 3.20+ development libraries
- X11 development environment

### Dependencies Breakdown

| Package | Purpose |
|---------|---------|
| `build-essential` | Core build tools (gcc, g++, make) |
| `libgtkmm-3.0-dev` | GTK+ C++ bindings |
| `libdbus-glib-1-dev` | D-Bus GLib bindings |
| `libboost-serialization-dev` | Boost serialization library |
| `libx11-dev libxext-dev libxi-dev` | X11 core and extension libraries |
| `libxfixes-dev libxtst-dev` | X11 fixes and testing extensions |
| `gettext` | Internationalization tools |
| `pkg-config` | Library configuration tool |
| `xserver-xorg-dev` | X server development headers |

### Build Process

1. **Clean previous builds** (if any):
   ```bash
   make clean
   ```

2. **Compile with parallel jobs**:
   ```bash
   make -j$(nproc)
   ```

3. **Verify the build**:
   ```bash
   ./easystroke --help
   ./easystroke --version
   ```

### Installation Options

#### System-wide Installation
```bash
sudo make install
```

This installs:
- Binary: `/usr/local/bin/easystroke`
- Icon: `/usr/local/share/icons/hicolor/scalable/apps/`
- Desktop file: `/usr/local/share/applications/`
- Translations: `/usr/local/share/locale/`

#### Custom Installation Directory
```bash
sudo make install PREFIX=/usr
```

#### User-only Installation
```bash
make install PREFIX=$HOME/.local
```

### Running Easystroke

#### Background Mode (Normal Usage)
```bash
easystroke
```

The application runs in the background with a system tray icon.

#### Configuration Mode
```bash
easystroke show
```

#### Command Line Options
```bash
easystroke --help                # Show help
easystroke --version             # Show version
easystroke -v                    # Verbose mode
easystroke -c ~/.config/easystroke  # Custom config directory
```

## Troubleshooting

### Build Issues

**Missing headers error:**
```bash
fatal error: xorg/xserver-properties.h: No such file or directory
```
**Solution:** Install `xserver-xorg-dev` package

**GTK version errors:**
```bash
Package gtkmm-3.0 was not found
```
**Solution:** Install `libgtkmm-3.0-dev` package

**Boost serialization errors:**
```bash
undefined reference to boost::serialization
```
**Solution:** Install `libboost-serialization-dev` package

### Runtime Issues

**No system tray icon:**
- Ensure your desktop environment supports system tray
- Try starting with `easystroke show` to open configuration window

**Permission denied for gesture capture:**
- Make sure you're running in X11 (not Wayland)
- Check X11 permissions for input device access

**Segmentation fault:**
- Run with verbose mode: `easystroke -v`
- Check if all dependencies are properly installed

### Version Compatibility

#### Supported Ubuntu Versions
- ✅ Ubuntu 24.04 LTS (Noble) - **Fully Tested**
- ✅ Ubuntu 22.04 LTS (Jammy) - Should work
- ✅ Ubuntu 20.04 LTS (Focal) - Should work
- ⚠️ Ubuntu 18.04 LTS (Bionic) - May need older dependency versions

#### Other Debian-based Distributions
The same dependencies should work on:
- Debian 11+ (Bullseye)
- Linux Mint 20+
- Elementary OS 6+
- Pop!_OS 20.04+

## Build Verification

After building, run these tests:

```bash
# Test basic functionality
./easystroke --help
./easystroke --version

# Test GUI (requires X11 display)
./easystroke show

# Test configuration load
./easystroke -c /tmp/test_config show
```

## Advanced Options

### Debug Build
```bash
make DFLAGS="-g -DDEBUG"
```

### Verbose Build
```bash
make V=1
```

### Custom Compiler
```bash
make CXX=clang++
```

## Modernization Features

This version includes modern enhancements:
- C++17 standard compilation
- Modern gettext tools (no intltool dependency)
- Fixed deprecated GTK/GDK functions
- Enhanced boost serialization compatibility
- Improved sigc++ compatibility

## Getting Help

- **Documentation**: http://easystroke.wiki.sourceforge.net/Documentation
- **Issues**: Report build problems or bugs to the project maintainer
- **Configuration**: Use `easystroke show` to access the GUI configuration

---

**Build tested successfully on Ubuntu 24.04.3 LTS with GCC 13 and modern library versions.**