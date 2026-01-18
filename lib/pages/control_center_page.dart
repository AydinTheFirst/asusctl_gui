import 'package:asusctl_gui/providers/theme_provider.dart';
import 'package:asusctl_gui/widgets/about_card.dart';
import 'package:asusctl_gui/widgets/aura_card.dart';
import 'package:asusctl_gui/widgets/battery_card.dart';
import 'package:asusctl_gui/widgets/fan_curve_card.dart';
import 'package:asusctl_gui/widgets/info_card.dart';
import 'package:asusctl_gui/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControlCenterPage extends ConsumerWidget {
  const ControlCenterPage({super.key});

  void _showThemeSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final themeMode = ref.watch(themeProvider);

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Theme Settings",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text("Mode", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text("System"),
                    icon: Icon(Icons.brightness_auto),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text("Light"),
                    icon: Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text("Dark"),
                    icon: Icon(Icons.dark_mode),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (Set<ThemeMode> newSelection) {
                  ref
                      .read(themeProvider.notifier)
                      .setThemeMode(newSelection.first);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              "Control Center",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () => _showThemeSettings(context, ref),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const ProfileCard(),
                const SizedBox(height: 16),
                const BatteryCard(),
                const SizedBox(height: 16),
                const AuraCard(),
                const SizedBox(height: 16),
                const FanCurveCard(),
                const SizedBox(height: 16),
                const InfoCard(),
                const SizedBox(height: 16),
                const AboutCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
