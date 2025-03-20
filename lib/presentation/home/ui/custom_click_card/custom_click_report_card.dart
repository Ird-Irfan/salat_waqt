import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class CUstomClickReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgIconPath;
  final ThemeData theme;
  final VoidCallback onTap;
  const CUstomClickReportCard({
    super.key,
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.svgIconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            SvgIcon(
              svgPath: AppConstant.icSupport,
              width: 28.px,
              height: 21.px,
            ),
            SizedBox(width: 16.px),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.px,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTextStyles.inter,
                    color: context.color.cardTitleColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.px,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppTextStyles.inter,
                    color: context.color.cardSubtitleColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
