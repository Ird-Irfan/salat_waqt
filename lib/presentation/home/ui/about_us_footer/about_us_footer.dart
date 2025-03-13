import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class AboutUsFooter extends StatelessWidget {
  final ThemeData theme;
  const AboutUsFooter({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.93, 1.20),
          radius: 0.72,
          colors: [
            context.color.cardGradientStart,
            context.color.cardGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(16.px),
      ),
      child: Row(
        children: [
          SvgIcon(svgPath: AppConstant.icSupport, width: 28.px, height: 21.px),
          SizedBox(width: 16.px),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support Us',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTextStyles.inter,
                  color: context.color.cardTitleColor,
                ),
              ),
              SizedBox(height: 4.px),
              Text(
                'Be a Part of Sadaqah Jariyah',
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
    );
  }
}
