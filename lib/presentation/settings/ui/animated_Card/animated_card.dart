import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class AnimatedCard extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String subtitle;
  final String svgIconPath;
  final String? selectedTextOne;
  final String? selectedTextTwo;
  final bool isExpanded;
  final VoidCallback onCardTap;
  final Function(String) onTextSelect;
  final String? selectedText;

  const AnimatedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgIconPath,
    required this.theme,
    required this.isExpanded,
    required this.onCardTap,
    required this.onTextSelect,
    required this.selectedText,
    this.selectedTextOne,
    this.selectedTextTwo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashColor: Colors.transparent,
      onTap: onCardTap,
      child: Container(
        width: double.infinity,
        height: isExpanded ? 220.px : 90.px,
        decoration: ShapeDecoration(
          gradient: RadialGradient(
            center: Alignment(0.93, 1.20),
            radius: 0.72,
            colors: [
              context.color.cardGradientStart,
              context.color.cardGradientEnd,
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.px),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(18.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgIcon(svgPath: svgIconPath, width: 28.px, height: 28.px),
                  SizedBox(width: 16.px),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 18.px,
                            fontWeight: FontWeight.w500,
                            color: context.color.cardTitleColor,
                            fontFamily: AppTextStyles.inter,
                          ),
                        ),
                        SizedBox(height: 8.px),
                        Text(
                          subtitle,
                          style: theme.textTheme.labelMedium?.copyWith(
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
                  Padding(
                    padding: EdgeInsets.all(12.px),
                    child:
                        isExpanded
                            ? SvgIcon(svgPath: AppConstant.icArrowUp)
                            : SvgIcon(svgPath: AppConstant.icArrowDown),
                  ),
                ],
              ),
              if (isExpanded)
                Expanded(
                  child: Column(
                    children: [
                      _buildSelectableText(
                        selectedTextOne ?? "Text One",
                        selectedText,
                      ),
                      _buildSelectableText(
                        selectedTextTwo ?? "Text Two",
                        selectedText,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableText(String text, String? selectedText) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashColor: Colors.transparent,
      onTap: () => onTextSelect(text),
      child: Container(
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
