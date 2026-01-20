import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asusctl_gui/utils/sensors.dart';
import 'package:asusctl_gui/widgets/glass_card.dart';

class SensorsCard extends ConsumerWidget {
  const SensorsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorsAsync = ref.watch(sensorsProvider);

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.white70,
                  size: 24,
                ),
                const SizedBox(width: 10),
                const Text(
                  "System Monitor",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),
            sensorsAsync.when(
              data: (sensors) {
                return Row(
                  children: [
                    Expanded(
                      child: _AnimatedGauge(
                        label: "CPU",
                        rpmValue: sensors.cpuSpeed,
                        tempValue: sensors.cpuTemp,
                        maxRpm: 6000,
                        icon: Icons.memory,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _AnimatedGauge(
                        label: "GPU",
                        rpmValue: sensors.gpuSpeed,
                        tempValue: sensors.gpuTemp,
                        maxRpm: 6000,
                        icon: Icons.videogame_asset,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Text("Error: $err"),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedGauge extends StatelessWidget {
  final String label;
  final int rpmValue;
  final double tempValue;
  final int maxRpm;
  final IconData icon;
  final Color color;

  const _AnimatedGauge({
    required this.label,
    required this.rpmValue,
    required this.tempValue,
    required this.maxRpm,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = (rpmValue / (maxRpm == 0 ? 1 : maxRpm)).clamp(
      0.0,
      1.0,
    );

    return Column(
      children: [
        SizedBox(
          height: 110,
          width: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Arka plan halka
              SizedBox(
                height: 90,
                width: 90,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation(
                    color.withValues(alpha: 0.15),
                  ),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percentage),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, val, _) {
                  return SizedBox(
                    height: 90,
                    width: 90,
                    child: CircularProgressIndicator(
                      value: val,
                      strokeWidth: 8,
                      strokeCap: StrokeCap.round,
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  );
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: color.withValues(alpha: 0.8)),
                  const SizedBox(height: 2),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: rpmValue),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, val, _) => Text(
                      "$val",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  const Text("RPM", style: TextStyle(fontSize: 9)),
                ],
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.thermostat,
                size: 14,
                color: tempValue > 80 ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                "${tempValue.toStringAsFixed(1)}°C",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: tempValue > 80 ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
