import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class SahriIftarTimesSection extends StatelessWidget {
  final ThemeData theme;
  final String sahriTime;
  final String iftarTime;
  const SahriIftarTimesSection({
    super.key,
    required this.sahriTime,
    required this.iftarTime,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TimeInfoCard(
            theme: theme,
            title: 'SAHRI LAST TIME',
            time: sahriTime,
            svgPath: AppConstant.icSahri,
          ),
        ),
        SizedBox(width: 16.px),
        Expanded(
          child: TimeInfoCard(
            theme: theme,
            title: 'IFTAAR TIME',
            time: iftarTime,
            svgPath: AppConstant.icIftaar,
          ),
        ),
      ],
    );
  }
}

class TimeInfoCard extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String time;
  final String svgPath;

  const TimeInfoCard({
    super.key,
    required this.title,
    required this.time,
    required this.svgPath,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(svgPath, width: 40.px, height: 34.px),
              SizedBox(height: 24.px),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.color.cardSubtitleColor,
                  fontFamily: AppTextStyles.inter,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.px,
                ),
              ),
              SizedBox(height: 8.px),
              Text(
                time,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: context.color.cardTitleColor,
                  fontFamily: AppTextStyles.inter,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.px,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
