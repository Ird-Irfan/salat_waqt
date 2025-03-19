import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/config/themes.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/presentation/Onboarding/ui/flash_screen/flash_screen.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';

class SalatWaqt extends StatefulWidget {
  const SalatWaqt({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get globalContext =>
      navigatorKey.currentContext ?? Get.context!;

  @override
  State<SalatWaqt> createState() => _SalatWaqtState();
}

class _SalatWaqtState extends State<SalatWaqt> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    // Get initial theme mode from settings
    final settingsPresenter = locator<SettingsPresenter>();
    _themeMode =
        settingsPresenter.currentUiState.isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light;

    // Listen for theme changes
    ever(settingsPresenter.uiState, (state) {
      setState(() {
        _themeMode = state.isDarkMode ? ThemeMode.dark : ThemeMode.light;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          navigatorKey: SalatWaqt.navigatorKey,
          builder: (context, child) {
            return Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) {
                    SalatWaqtScreen.setUp(context);
                    // Wrap the Container in a Builder
                    return Theme(
                      //add this.
                      data: Theme.of(context),
                      child: Builder(
                        builder: (innerContext) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  Theme.of(innerContext).brightness ==
                                          Brightness.dark
                                      ? AppConstant.appBgPngDark
                                      : AppConstant.appBgPngLight,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: child!,
                          ); // Add the Builder here
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
          onInit: () => SalatWaqtScreen.setUp(context),
          onReady: () => SalatWaqtScreen.setUp(context),
          debugShowCheckedModeBanner: false,
          title: 'Salat Waqt',
          theme: SalatTheme.getTheme('Light', AppTextStyles.inter, 14),
          darkTheme: SalatTheme.getTheme('Dark', AppTextStyles.inter, 14),
          themeMode: _themeMode,
          home: const FlashScreen(),
        );
      },
    );
  }
}
