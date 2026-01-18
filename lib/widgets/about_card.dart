import 'package:asusctl_gui/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "About",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData ? "v${snapshot.data!.version}" : "v...",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildLinkRow(
            context,
            icon: Icons.person_outline,
            label: "Developer",
            value: "@AydinTheFirst",
            url: "https://github.com/AydinTheFirst",
          ),
          const SizedBox(height: 12),
          _buildLinkRow(
            context,
            icon: Icons.description_outlined,
            label: "License",
            value: "MIT License",
            url:
                "https://github.com/AydinTheFirst/asusctl_gui/blob/main/LICENSE",
          ),
          const SizedBox(height: 12),
          _buildLinkRow(
            context,
            icon: Icons.star_border,
            label: "Repository",
            value: "Star on GitHub",
            url: "https://github.com/AydinTheFirst/asusctl_gui",
            isHighlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String url,
    bool isHighlight = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHighlight
              ? primaryColor.withValues(alpha: isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlight
                ? primaryColor.withValues(alpha: 0.5)
                : Theme.of(context).dividerColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isHighlight
                  ? primaryColor
                  : primaryColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: primaryColor.withValues(alpha: 0.7),
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_outward,
              size: 14,
              color: primaryColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
