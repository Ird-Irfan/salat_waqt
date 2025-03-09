import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';
import 'package:salat_waqt/presentation/settings/ui/animated_expansion/animated_expansion.dart';
import 'package:salat_waqt/presentation/settings/ui/icon_text_row/icon_text_row.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsPresenter presenter = locator();
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Preferences'),
      ),

      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          return Column(
            children: [
              AnimatedExpansion(
                theme: theme,
                isDarkMode: Get.isDarkMode,
                onThemeChanged: (isDark) {
                  // Change the app theme based on the selected mode
                  Get.changeThemeMode(
                    isDark ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),

              IconTextRow(
                switchValue: presenter.currentUiState.doNotDisturbEnabled,
                onSwitchChanged: (bool) {
                  presenter.toggleDoNotDisturb();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
