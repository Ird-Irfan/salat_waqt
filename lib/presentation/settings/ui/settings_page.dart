import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/presentation/settings/ui/animated_expansion/animated_expansion.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Preferences'),
      ),

      body: Column(
        children: [
          AnimatedExpansion(
            theme: theme,
            isDarkMode: Get.isDarkMode,
            onThemeChanged: (isDark) {
              // Change the app theme based on the selected mode
              Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
    );
  }
}
