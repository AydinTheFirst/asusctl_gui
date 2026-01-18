import 'package:asusctl_gui/pages/control_center_page.dart';
import 'package:asusctl_gui/pages/not_found_page.dart';
import 'package:asusctl_gui/providers/theme_provider.dart';
import 'package:asusctl_gui/theme/app_theme.dart';
import 'package:asusctl_gui/utils/availability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();
GetStorage storage = GetStorage();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final availabilityAsync = ref.watch(asusctlAvailabilityProvider);

    return GetMaterialApp(
      title: 'AsusCtl GUI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: availabilityAsync.when(
        data: (isAvailable) {
          if (isAvailable) {
            return const ControlCenterPage();
          } else {
            return const AsusctlNotFoundPage();
          }
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => const AsusctlNotFoundPage(),
      ),
    );
  }
}
