import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

        return Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.px),
            ),
            gradient: RadialGradient(
              center: Alignment(0.97, -1.20),
              radius: 1,
              colors: [
                context.color.cardGradientEnd,
                context.color.cardGradientStart,
              ],
            ),
          ),
          child: ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              // curve: Curves.easeInOut,
              curve: Curves.linear,
              // curve: Curves.ease,
              // curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
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
                    child: Padding(
                      padding: EdgeInsets.all(20.px),
                      child: Row(
                        children: [
                          SvgIcon(
                            svgPath:
                                isDarkMode
                                    ? AppConstant.icThemeDark
                                    : AppConstant.icThemeLight,
                            width: 28.px,
                            height: 28.px,
                          ),
                          SizedBox(width: 16.px),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Theme',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontFamily: AppTextStyles.inter,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.px,
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
                                  fontSize: 14.px,
                                  color: context.color.cardSubtitleColor,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            isExpanded
                                ? AppConstant.icArrowUp
                                : AppConstant.icArrowDown,
                            width: 24.px,
                            height: 24.px,
                            color: context.color.cardTitleColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded options
                  if (isExpanded) ...[
                    Divider(
                      color: context.color.cardSiblingBottomBorderColor
                          .withOpacityInt(0.05),
                      height: 1.px,
                    ),
                    // Day Mode Option
                    InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (isDarkMode) {
                          presenter.changeTheme(false);
                          onThemeChanged(false);
                        }
                      },
                      child: _themeMode(
                        'Day Mode',
                        AppConstant.icDuhur,
                        isDarkMode,
                        theme,
                        context,
                      ),
                    ),
                    // Night Mode Option
                    InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (!isDarkMode) {
                          presenter.changeTheme(true);
                          onThemeChanged(true);
                        }
                      },
                      child: _themeMode(
                        'Night Mode',
                        AppConstant.icIsha,
                        isDarkMode,
                        theme,
                        context,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _themeMode(
    String title,
    String svgPath,
    bool isDarkMode,
    ThemeData theme,
    BuildContext context,
  ) {
    bool isSelected =
        (title == 'Night Mode' && isDarkMode) ||
        (title == 'Day Mode' && !isDarkMode);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 8.px),
      height: 60.px,
      decoration:
          isSelected
              ? BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.97, 0.00),
                  radius: 2.57,
                  colors: [
                    context.color.siblingCardActiveGradientStart.withOpacity(
                      0.5,
                    ),
                    context.color.siblingCardActiveGradientEnd.withOpacity(0.5),
                  ],
                ),
              )
              : null,
      child: Row(
        children: [
          SvgIcon(svgPath: svgPath, width: 24.px, height: 24.px),
          SizedBox(width: 14.px),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.px,
              fontWeight: FontWeight.w500,
              fontFamily: AppTextStyles.inter,
              color: context.color.cardTitleColor,
            ),
          ),
          const Spacer(),
          if (isSelected)
            SvgIcon(svgPath: AppConstant.icSelect, width: 24.px, height: 24.px),
        ],
      ),
    );
  }
}
