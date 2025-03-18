import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeData theme;
  const CustomAppBar({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          'Preferences',
          style: theme.textTheme.titleMedium?.copyWith(
            color: context.color.cardTitleColor,
            fontSize: 16.px,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgIcon(
            svgPath: AppConstant.icLeftArrowBack,
            width: 24.px,
            height: 24.px,
            color: context.color.cardTitleColor,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(88.px);
}
