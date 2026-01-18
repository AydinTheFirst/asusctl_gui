import 'package:asusctl_gui/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AsusctlNotFoundPage extends StatelessWidget {
  const AsusctlNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 24),
                Text(
                  "asusctl not found",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "The asusctl utility was not found on your system. Please install it to use this application.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () {
                    launchUrl(
                      Uri.parse("https://asus-linux.org/"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text("Installation Instructions"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
