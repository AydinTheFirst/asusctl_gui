import 'package:asusctl_gui/services/shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsusctlInfo {
  final String version;
  final String softwareVersion;
  final String productFamily;
  final String boardName;

  AsusctlInfo({
    required this.version,
    required this.softwareVersion,
    required this.productFamily,
    required this.boardName,
  });
}

class AsusctlInfoNotifier extends AsyncNotifier<AsusctlInfo> {
  @override
  Future<AsusctlInfo> build() async {
    final result = await shell.run("asusctl", ["info"]);

    if (result.exitCode != 0) {
      throw Exception("asusctl exited with code ${result.exitCode}");
    }

    final output = result.stdout;

    final versionRegex = RegExp(r"asusctl v([\d.]+)");
    final softwareVersionRegex = RegExp(r"Software version: ([\d.]+)");
    final productFamilyRegex = RegExp(r"Product family: (.+)");
    final boardNameRegex = RegExp(r"Board name: (.+)");

    final versionMatch = versionRegex.firstMatch(output);
    final softwareVersionMatch = softwareVersionRegex.firstMatch(output);
    final productFamilyMatch = productFamilyRegex.firstMatch(output);
    final boardNameMatch = boardNameRegex.firstMatch(output);

    final version = versionMatch?.group(1) ?? "Unknown";
    final softwareVersion = softwareVersionMatch?.group(1) ?? "Unknown";
    final productFamily = productFamilyMatch?.group(1) ?? "Unknown";
    final boardName = boardNameMatch?.group(1) ?? "Unknown";

    return AsusctlInfo(
      version: version,
      softwareVersion: softwareVersion,
      productFamily: productFamily,
      boardName: boardName,
    );
  }
}

final asusctlInfoNotifierProvider =
    AsyncNotifierProvider<AsusctlInfoNotifier, AsusctlInfo>(() {
      return AsusctlInfoNotifier();
    });
