import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/config/salat_custom_theme.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class AppBarSection extends StatelessWidget implements PreferredSizeWidget {
  final String location;
  const AppBarSection({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 24.px, top: 8.px),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          // padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.px)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgIcon(svgPath: AppConstant.icGps, width: 24.px, height: 24.px),
              SizedBox(width: 10.px),
              Text(
                location,
                style: AppTextStyles.title.copyWith(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w400,
                  color:
                      Theme.of(
                        context,
                      ).extension<SalatCustomTheme>()?.primaryColor100,
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
        actions: [
          // Switch(value: true, onChanged: (value) {}),
          SvgIcon(svgPath: AppConstant.icCategory, width: 24.px, height: 24.px),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
