import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';
import 'package:salat_waqt/presentation/settings/ui/settings_page.dart';

class AppBarSection extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onLocationTap;
  final ThemeData theme;
  const AppBarSection({
    super.key,
    required this.theme,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final HomePresenter presenter = locator<HomePresenter>();
    return AppBar(
      elevation: 0,
      title: InkWell(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        // splashColor: Colors.transparent,
        onTap: onLocationTap,
        child: PresentableWidgetBuilder(
          presenter: presenter,
          builder: () {
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.px)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgIcon(
                      svgPath: AppConstant.icGps,
                      width: 24.px,
                      height: 24.px,
                      color: context.color.cardTitleColor,
                    ),
                    SizedBox(width: 12.px),
                    Text(
                      presenter.currentUiState.currentAddress ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: context.color.cardTitleColor,
                        fontSize: 16.px,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6.px),
                    SvgIcon(
                      svgPath: AppConstant.icArrowDown,
                      width: 16.px,
                      height: 16.px,
                      color: context.color.cardTitleColor,
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
      actions: [
        // Switch(value: true, onChanged: (value) {}),
        Padding(
          padding: EdgeInsets.only(right: 20.px),
          child: SvgIcon(
            svgPath: AppConstant.icCategory,
            width: 24.px,
            height: 24.px,
            color: context.color.cardTitleColor,
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const SettingsPage(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(88.px);
}
