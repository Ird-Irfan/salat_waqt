import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class SahriIftarTimesSection extends StatelessWidget {
  final ThemeData theme;
  const SahriIftarTimesSection({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TimeInfoCard(
            theme: theme,
            title: 'SAHRI LAST TIME',
            time: '04:15 AM',
            svgPath: AppConstant.icSahri,
          ),
        ),
        SizedBox(width: 12.px),
        Expanded(
          child: TimeInfoCard(
            theme: theme,
            title: 'IFTAAR LAST TIME',
            time: '04:15 AM',
            svgPath: AppConstant.icIftaar,
          ),
        ),
      ],
    );
  }
}

class TimeInfoCard extends StatelessWidget {
  final String title;
  final String time;
  final String svgPath;
  final ThemeData theme;

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
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgIcon(height: 36.43.px, width: 34.43.px, svgPath: svgPath),
          SizedBox(height: 26.px),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 14.px,
              color: Colors.white,
              fontFamily: AppTextStyles.inter,
            ),
          ),
          SizedBox(height: 8.px),
          Text(
            time,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 18.px,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: AppTextStyles.inter,
            ),
          ),
        ],
      ),
    );
  }
}
