import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class AnimatedCard extends StatefulWidget {
  final ThemeData theme;
  final String title;
  final String subtitle;
  final String svgIconPath;
  const AnimatedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgIconPath,
    required this.theme,
  });

  @override
  AnimatedCardState createState() => AnimatedCardState();
}

class AnimatedCardState extends State<AnimatedCard> {
  bool _isExpanded = false;
  // Store single selected item
  String? selectedText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        width: double.infinity,
        height: _isExpanded ? 265.px : 95.px,
        decoration: ShapeDecoration(
          gradient: RadialGradient(
            center: Alignment(0.93, 1.20),
            radius: 0.72,
            colors: [
              context.color.bgCardGradient1,
              context.color.bgCardGradient2,
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.px),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20.px),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppConstant.icWeat,
                    width: 28.px,
                    height: 28.px,
                  ),
                  SizedBox(width: 16.px),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: widget.theme.textTheme.titleMedium?.copyWith(
                            fontSize: 18.px,
                            fontWeight: FontWeight.w500,
                            color: context.color.cardTitleColor,
                            fontFamily: AppTextStyles.inter,
                          ),
                        ),
                        SizedBox(height: 8.px),
                        Text(
                          widget.subtitle,
                          style: widget.theme.textTheme.labelMedium?.copyWith(
                            fontSize: 14.px,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTextStyles.inter,
                            color: context.color.cardSubtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  _isExpanded
                      ? SvgIcon(svgPath: AppConstant.icArrowUp)
                      : SvgIcon(svgPath: AppConstant.icArrowDown),
                ],
              ),
            ),
            if (_isExpanded)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    buildSelectableText("Hanafi"),
                    buildSelectableText("SHafi,Maliki,Hambli"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectableText(String text) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          // Toggle selection: Select new item or deselect if already selected
          if (selectedText == text) {
            selectedText = null;
          } else {
            selectedText = text;
          }
        });
      },
      child: Container(
        // color: selectedText == text ? Colors.grey[300] : null,
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: 16)),
            if (selectedText == text) Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
