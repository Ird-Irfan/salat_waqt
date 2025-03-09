import 'package:flutter/material.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class SahriIftarTimesSection extends StatelessWidget {
  final String sahriTime;
  final String iftarTime;
  const SahriIftarTimesSection({
    super.key,
    required this.sahriTime,
    required this.iftarTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TimeInfoCard(
            title: 'SAHRI LAST TIME',
            time: sahriTime,
            svgPath: AppConstant.icSahri,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TimeInfoCard(
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
  final String title;
  final String time;
  final String svgPath;

  const TimeInfoCard({
    super.key,
    required this.title,
    required this.time,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgIcon(svgPath: svgPath),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
