import 'package:asusctl_gui/services/shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

enum Profile { performance, balanced, quiet }

class ProfileNotifier extends AsyncNotifier<Profile> {
  GetStorage box = GetStorage();

  @override
  Future<Profile> build() async {
    final storedProfile = box.read("profile");
    if (storedProfile != null) {
      return _findProfileByName(storedProfile);
    }

    final result = await shell.run("asusctl", [
      "profile",
      "get",
    ]); // Active profile: Performance

    if (result.exitCode != 0) {
      throw Exception("asusctl exited with code ${result.exitCode}");
    }

    final output = result.stdout;
    final regex = RegExp(r"Active profile:\s+(\w+)");
    final match = regex.firstMatch(output);

    if (match != null) {
      final profileStr = match.group(1)!.toLowerCase();
      return _findProfileByName(profileStr);
    }

    return Profile.balanced;
  }

  Future<void> setProfile(Profile profile) async {
    final result = await shell.run("asusctl", ["profile", "set", profile.name]);

    if (result.exitCode != 0) {
      throw Exception("Failed to set profile: ${result.stderr}");
    }

    box.write("profile", profile.name);

    state = AsyncValue.data(profile);
  }

  Profile _findProfileByName(String name) {
    switch (name) {
      case "performance":
        return Profile.performance;
      case "balanced":
        return Profile.balanced;
      case "quiet":
        return Profile.quiet;
      default:
        return Profile.balanced;
    }
  }
}

final profileNotifierProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(
  () => ProfileNotifier(),
);
