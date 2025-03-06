import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/config/salat_custom_theme.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/ui/appber/custom_switch.dart';

class AppBarSection extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2234),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIcon(svgPath: AppConstant.icGps, width: 24.px, height: 24.px),
            // const SizedBox(width: 4),
            Text(
              'Dhaka, Bangladesh',
              style: AppTextStyles.title.copyWith(
                fontSize: 14.px,
                fontWeight: FontWeight.w400,
                color:
                    Theme.of(
                      context,
                    ).extension<SalatCustomTheme>()?.primaryColor100,
              ),
            ),
            const SizedBox(width: 4),
            SvgIcon(
              svgPath: AppConstant.icArrowDown,
              width: 24.px,
              height: 24.px,
            ),
          ],
        ),
      ),
      actions: [
        // Switch(value: true, onChanged: (value) {}),
        CustomSwitch(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
