import 'package:asusctl_gui/utils/profiles.dart';
import 'package:asusctl_gui/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);

    final profileAsync = ref.watch(profileNotifierProvider);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.speed_rounded, size: 24),
              const SizedBox(width: 8),
              Text(
                "Power Profile",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          profileAsync.when(
            data: (currentProfile) {
              return SizedBox(
                width: double.infinity,
                child: SegmentedButton<Profile>(
                  segments: const [
                    ButtonSegment(
                      value: Profile.quiet,
                      label: Text('Quiet'),
                      icon: Icon(Icons.nightlight_round, size: 16),
                    ),
                    ButtonSegment(
                      value: Profile.balanced,
                      label: Text('Balanced'),
                      icon: Icon(Icons.balance, size: 16),
                    ),
                    ButtonSegment(
                      value: Profile.performance,
                      label: Text('Perf.'),
                      icon: Icon(Icons.bolt, size: 16),
                    ),
                  ],
                  selected: {currentProfile},
                  onSelectionChanged: (Set<Profile> newSelection) {
                    ref
                        .read(profileNotifierProvider.notifier)
                        .setProfile(newSelection.first);
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    visualDensity: VisualDensity.compact,
                    side: WidgetStateProperty.all(
                      BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text("Error: $err"),
          ),
        ],
      ),
    );
  }
}
