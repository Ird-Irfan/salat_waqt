import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';

class AnimatedExpansion extends StatelessWidget {
  final ThemeData theme;
  final Function(bool) onThemeChanged;

  const AnimatedExpansion({
    super.key,
    required this.onThemeChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final SettingsPresenter presenter = locator<SettingsPresenter>();
    
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final bool isExpanded = presenter.currentUiState.isExpanded;
        final bool isDarkMode = presenter.currentUiState.isDarkMode;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: isExpanded ? null : 88,
          constraints: BoxConstraints(
            minHeight: 88,
            maxHeight: isExpanded ? 220 : 88,
          ),
          decoration: ShapeDecoration(
            gradient: RadialGradient(
              center: Alignment(0.93, 1.20),
              radius: 0.72,
              colors: [
                context.color.cardGradientStart,
                context.color.cardGradientEnd,
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.px),
            ),
          ),
          child: ClipRect(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header (always visible)
                  InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    splashColor: Colors.transparent,
                    onTap: () {
                      presenter.toggleExpansion();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0.px),
                        child: Row(
                          children: [
                            SvgIcon(
                              svgPath: AppConstant.icTheme,
                              width: 32.px,
                              height: 32.px,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Theme',
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(
                                        fontFamily: AppTextStyles.inter,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.px,
                                        color: context.color.cardTitleColor,
                                      ),
                                ),
                                SizedBox(height: 8.px),
                                Text(
                                  isDarkMode
                                      ? 'Night Mode Selected'
                                      : 'Day Mode Selected',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontFamily: AppTextStyles.inter,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.px,
                                    color: context.color.cardSubtitleColor,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expanded options
                  if (isExpanded) ...[
                    // Day Mode Option
                    InkWell(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (isDarkMode) {
                          presenter.changeTheme(false);
                          onThemeChanged(false);
                        }
                      },
                      child: _themeMode('Day Mode', AppConstant.icDuhur, isDarkMode, theme),
                    ),
                    // Night Mode Option
                    InkWell(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (!isDarkMode) {
                          presenter.changeTheme(true);
                          onThemeChanged(true);
                        }
                      },
                      child: _themeMode('Night Mode', AppConstant.icIsha, isDarkMode, theme),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _themeMode(String title, String svgPath, bool isDarkMode, ThemeData theme) {
    bool isSelected =
        (title == 'Night Mode' && isDarkMode) ||
        (title == 'Day Mode' && !isDarkMode);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 60,
      child: Row(
        children: [
          SvgIcon(svgPath: svgPath, width: 28.px, height: 28.px),
          const SizedBox(width: 12),
          Text(title, style: theme.textTheme.titleMedium),
          const Spacer(),
          if (isSelected) const Icon(Icons.check),
        ],
      ),
    );
  }
}