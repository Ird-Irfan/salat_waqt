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
        SizedBox(width: 12),
        Expanded(
          child: TimeInfoCard(
            theme: theme,
            title: 'IFTAAR LAST TIME',
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
    return Container(
      padding: EdgeInsets.all(20.px),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.93, 1.20),
          radius: 0.72,
          colors: [
            context.color.bgCardGradient1,
            context.color.bgCardGradient2,
          ],
        ),
        borderRadius: BorderRadius.circular(16.px),
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
    );
  }
}
