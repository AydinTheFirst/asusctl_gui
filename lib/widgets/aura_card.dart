import 'package:asusctl_gui/utils/aura.dart';
import 'package:asusctl_gui/utils/leds.dart';
import 'package:asusctl_gui/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuraCard extends ConsumerWidget {
  const AuraCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auraStateAsync = ref.watch(auraNotifierProvider);
    final ledsAsync = ref.watch(ledsNotifierProvider.select((value) => value));

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.palette_outlined, size: 24),
              const SizedBox(width: 8),
              Text(
                "Aura & LEDs",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Aura Mode
          auraStateAsync.when(
            data: (state) => DropdownButtonFormField<Aura>(
              initialValue: state.mode,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).hoverColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: Aura.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  ref.read(auraNotifierProvider.notifier).setAura(val);
                }
              },
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text("Error: $e"),
          ),
          const SizedBox(height: 16),
          // Color Picker
          auraStateAsync.when(
            data: (state) {
              Color currentColor = Color(int.parse("0xFF${state.color}"));
              return Row(
                children: [
                  Text(
                    "Aura Color",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showColorPicker(context, ref, currentColor);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: currentColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: currentColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(),
            error: (err, stack) => const SizedBox(),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          // LEDs Level
          Text(
            "Keyboard Brightness",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          ledsAsync.when(
            data: (level) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: LedsLevel.values.map((l) {
                final isSelected = l == level;
                return ChoiceChip(
                  label: Text(l.name.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(ledsNotifierProvider.notifier).setLedsLevel(l);
                    }
                  },
                );
              }).toList(),
            ),
            loading: () => const SizedBox(),
            error: (e, _) => Text("$e"),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(
    BuildContext context,
    WidgetRef ref,
    Color currentColor,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        Color pickedColor = currentColor;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                pickedColor = color;
              },
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hueWheel,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                final hex = pickedColor
                    .toARGB32()
                    .toRadixString(16)
                    .substring(2);
                ref.read(auraNotifierProvider.notifier).setColor(hex);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
