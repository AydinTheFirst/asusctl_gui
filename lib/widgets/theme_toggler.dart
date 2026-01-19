import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asusctl_gui/theme/theme_provider.dart';

class ThemeToggler extends ConsumerWidget {
  const ThemeToggler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return SegmentedButton<ThemeMode>(
      style: SegmentedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        visualDensity: VisualDensity.compact,
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        selectedBackgroundColor: Theme.of(context).colorScheme.primary,
        selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      segments: const <ButtonSegment<ThemeMode>>[
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          tooltip: 'Light Mode',
          icon: Icon(Icons.light_mode_outlined, size: 18),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          tooltip: 'System Default',
          icon: Icon(Icons.brightness_auto_outlined, size: 18),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          tooltip: 'Dark Mode',
          icon: Icon(Icons.dark_mode_outlined, size: 18),
        ),
      ],
      selected: {themeMode},
      onSelectionChanged: (Set<ThemeMode> newSelection) {
        ref.read(themeProvider.notifier).setTheme(newSelection.first);
      },
    );
  }
}
