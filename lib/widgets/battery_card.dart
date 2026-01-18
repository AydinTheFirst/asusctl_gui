import 'package:asusctl_gui/utils/battery_limit.dart';
import 'package:asusctl_gui/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatteryCard extends ConsumerWidget {
  const BatteryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batteryLimitAsync = ref.watch(batteryLimitNotifierProvider);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.battery_charging_full_rounded, size: 24),
              const SizedBox(width: 8),
              Text(
                "Battery Limit",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              batteryLimitAsync.when(
                data: (limit) => Text(
                  "$limit%",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                loading: () => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (err, stack) => const Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          batteryLimitAsync.when(
            data: (limit) {
              return SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 16,
                  ),
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  thumbColor: Theme.of(context).colorScheme.primary,
                ),
                child: Slider(
                  value: limit.toDouble(),
                  min: 40,
                  max: 100,
                  divisions: 6, // 40, 50, 60, 70, 80, 90, 100
                  label: limit.toString(),
                  onChanged: (value) {
                    ref
                        .read(batteryLimitNotifierProvider.notifier)
                        .setBatteryLimit(value.toInt());
                  },
                ),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, stack) => Text(
              "Error: $err",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Limit charging to prolong battery lifespan.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
