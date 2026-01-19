import 'package:asusctl_gui/widgets/about_card.dart';
import 'package:asusctl_gui/widgets/aura_card.dart';
import 'package:asusctl_gui/widgets/battery_card.dart';
import 'package:asusctl_gui/widgets/info_card.dart';
import 'package:asusctl_gui/widgets/profile_card.dart';
import 'package:asusctl_gui/widgets/theme_toggler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControlCenterPage extends ConsumerWidget {
  const ControlCenterPage({super.key});

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
            actions: [const ThemeToggler(), const SizedBox(width: 16)],
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
