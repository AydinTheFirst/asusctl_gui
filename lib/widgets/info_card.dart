import 'package:asusctl_gui/utils/info.dart';
import 'package:asusctl_gui/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoCard extends ConsumerWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(asusctlInfoNotifierProvider);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 24),
              const SizedBox(width: 8),
              Text(
                "System Info",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          infoAsync.when(
            data: (info) {
              return Column(
                children: [
                  _buildInfoRow(context, "Version", info.version),
                  const Divider(height: 16, thickness: 0.5),
                  _buildInfoRow(
                    context,
                    "Software Version",
                    info.softwareVersion,
                  ),
                  const Divider(height: 16, thickness: 0.5),
                  _buildInfoRow(context, "Product Family", info.productFamily),
                  const Divider(height: 16, thickness: 0.5),
                  _buildInfoRow(context, "Board Name", info.boardName),
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (err, stack) => Center(
              child: Text(
                "Error loading info: $err",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
