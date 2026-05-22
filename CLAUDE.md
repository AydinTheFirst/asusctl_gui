# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AsusCtl GUI is a Flutter-based Linux desktop application that provides a modern graphical interface for [asusctl](https://gitlab.com/asus-linux/asusctl), a control utility for ASUS ROG laptops. The app manages power profiles, RGB lighting (Aura), battery limits, fan curves, and real-time sensor monitoring.

**Target Platform:** Linux desktop only (uses native shell commands)
**Runtime Dependency:** Requires `asusctl` and `asusd` service running on the system

## Development Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Generate app icons
flutter pub run icons_launcher:create
```

### Running
```bash
# Development mode
flutter run -d linux

# Run with specific device
flutter run -d linux --debug
```

### Building
```bash
# Debug build
flutter build linux

# Release build (output: build/linux/x64/release/bundle/)
flutter build linux --release

# The release bundle can be packaged with:
cd build/linux/x64/release/bundle
tar -czf asusctl_gui-linux-x64.tar.gz *
```

### Testing & Linting
```bash
# Analyze code
flutter analyze

# Check specific file
flutter analyze lib/path/to/file.dart

# Run tests (if any exist)
flutter test
```

### Version Management
Update version in `pubspec.yaml`:
```yaml
version: 1.0.4  # Format: major.minor.patch
```

## Architecture

### Shell Command Pattern
The app executes `asusctl` CLI commands via a platform-specific shell abstraction:

- **`lib/services/shell.dart`** - Conditional export (stub/io/web)
- **`lib/services/shell_io.dart`** - Native implementation using `dart:io Process.run()`
- **`lib/services/shell_stub.dart`** - Stub for non-IO platforms
- **`lib/services/shell_web.dart`** - Web fallback (no-op)

Import pattern:
```dart
import 'package:asusctl_gui/services/shell.dart';

final result = await shell.run('asusctl', ['profile', 'get']);
```

All system interactions go through this layer. Error handling expects `exitCode != 0` for failures.

### State Management: Riverpod Pattern
The app uses **flutter_riverpod** with `AsyncNotifier` for all hardware state:

**Notifier Structure:**
```dart
class ProfileNotifier extends AsyncNotifier<Profile> {
  @override
  Future<Profile> build() async {
    // 1. Read from GetStorage cache (fast)
    // 2. Fetch from asusctl (slow)
    // 3. Return current state
  }
  
  Future<void> setState(...) async {
    // 1. Execute shell command
    // 2. Update GetStorage cache
    // 3. Update state: state = AsyncValue.data(...)
  }
}
```

**Providers in `lib/utils/`:**
- `profiles.dart` → `profileNotifierProvider` - Power profiles (Performance/Balanced/Quiet)
- `battery_limit.dart` → `batteryLimitProvider` - Charge limit (0-100%)
- `aura.dart` → `auraNotifierProvider` - RGB modes and colors
- `leds.dart` → `ledNotifierProvider` - Keyboard LED brightness
- `sensors.dart` → `sensorsProvider` - Real-time fan/temp monitoring (StreamNotifier)
- `fan_curve.dart` → Fan curve configuration
- `info.dart` → System information display

### Sensor Monitoring (Fedora-Compatible)
`lib/utils/sensors.dart` implements a dual-path sensor reading strategy:

1. **Primary:** Direct sysfs reading (works without `lm-sensors` package)
   - Fans: `/sys/class/hwmon/hwmonX/fan{1,2}_input` (ASUS hwmon device)
   - CPU temp: coretemp hwmon `temp1_input` (millicelsius / 1000)
   - GPU temp: `nvidia-smi --query-gpu=temperature.gpu` for NVIDIA cards

2. **Fallback:** Parse `sensors` command output (if lm-sensors installed)

The implementation dynamically finds hwmon devices by name (`asus`, `coretemp`) to handle varying hwmon numbering across boots.

### UI Structure
**Single-page app** with vertical scrolling card layout:

- **`lib/pages/control_center_page.dart`** - Main page (SliverAppBar + card list)
- **`lib/widgets/*_card.dart`** - Self-contained feature cards:
  - `sensors_card.dart` - Real-time gauges (CPU/GPU RPM + temp)
  - `profile_card.dart` - Power profile selector
  - `battery_card.dart` - Charge limit slider
  - `aura_card.dart` - RGB mode/color picker
  - `info_card.dart` - System info display
  - `about_card.dart` - App metadata and links

Each card is a `ConsumerWidget` that watches its corresponding Riverpod provider.

### Theme System
- **`lib/theme/app_theme.dart`** - Light/dark theme definitions
- **`lib/theme/theme_provider.dart`** - Theme toggle state (persisted via GetStorage)
- UI uses **glassmorphism** design (`glass_card.dart` wrapper)

### Data Persistence
**GetStorage** for lightweight key-value caching:
- Last selected profile, aura mode, battery limit, etc.
- Avoids redundant shell calls on app restart
- Always verify cache against actual hardware state in `build()` methods

## Coding Patterns

### Adding a New Hardware Feature
1. Create `lib/utils/feature_name.dart` with:
   - State model (class or enum)
   - `AsyncNotifier` subclass with `build()` and setter methods
   - Provider export
2. Create `lib/widgets/feature_name_card.dart` as a `ConsumerWidget`
3. Add card to `control_center_page.dart` card list
4. Use `shell.run('asusctl', [...])` for all hardware interactions
5. Cache state in GetStorage with key `"feature-name"`

### Regex Parsing Pattern
All `asusctl` command outputs are parsed with RegExp:
```dart
final output = result.stdout.toString();
final regex = RegExp(r'Field:\s+(\S+)');
final match = regex.firstMatch(output);
if (match != null) {
  final value = match.group(1)!;
}
```

Test regex against actual command output before implementation.

### Error States
All providers handle three states via Riverpod's `AsyncValue`:
- **Loading:** `CircularProgressIndicator()`
- **Data:** Render actual UI
- **Error:** Display error message or fallback

Use `.when()` method in widgets:
```dart
ref.watch(provider).when(
  data: (value) => Widget(...),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text("Error: $err"),
);
```

## Release Process

1. Update version in `pubspec.yaml`
2. Commit changes: `git commit -m "chore: Bump version to X.Y.Z"`
3. Tag release: `git tag vX.Y.Z`
4. Build release: `flutter build linux --release`
5. Package: `cd build/linux/x64/release/bundle && tar -czf asusctl_gui-X.Y.Z-linux-x64.tar.gz *`
6. Create GitHub release with tarball
7. Users install via: `curl -sSL https://raw.githubusercontent.com/awaiden/asusctl_gui/main/install.sh | bash`

The `install.sh` script:
- Fetches latest release tarball from GitHub
- Extracts to `/opt/asusctl_gui`
- Creates symlink in `/usr/bin/`
- Installs `.desktop` file for app menu integration

## Testing on Hardware

Since this app directly controls laptop hardware:
- **Power profiles** affect CPU behavior immediately
- **Battery limit** persists across reboots (firmware setting)
- **RGB changes** apply instantly but don't persist without asusd
- **Fan curves** are advanced and disabled by default (not all laptops support it)

Always test changes on actual ASUS hardware or in an environment with `asusctl` installed. The app gracefully shows "asusctl not found" page if the service is unavailable.

## Important Notes

- Never mock shell commands in production code - use conditional imports instead
- All `asusctl` commands require the `asusd` systemd service to be running
- RGB mode names must match `asusctl aura` subcommands exactly (kebab-case)
- Fan curve feature is commented out in UI - not all laptops support custom curves
- Sensor polling runs every 2 seconds - don't increase frequency (excessive CPU usage)
