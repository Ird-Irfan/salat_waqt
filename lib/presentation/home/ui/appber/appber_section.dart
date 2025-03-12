import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/settings/ui/settings_page.dart';

class AppBarSection extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onLocationTap;
  final ThemeData theme;
  final String location;
  const AppBarSection({super.key, required this.location, required this.theme, this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.px,
        right: 16.px,
        top: 8.px,
        bottom: 8.px,
      ),
      child: AppBar(
        elevation: 0,
        title: InkWell(
          onTap: onLocationTap,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.px)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgIcon(
                  svgPath: AppConstant.icGps,
                  width: 24.px,
                  height: 24.px,
                  color: context.color.cardTitleColor,
                ),
                SizedBox(width: 10.px),
                Text(
                  location,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: context.color.cardTitleColor,
                    fontSize: 14.px,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 4.px),
                SvgIcon(
                  svgPath: AppConstant.icArrowDown,
                  width: 16.px,
                  height: 16.px,
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Switch(value: true, onChanged: (value) {}),
          Padding(
            padding: EdgeInsets.only(right: 16.px),
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
