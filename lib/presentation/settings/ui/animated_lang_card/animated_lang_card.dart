import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class AnimatedLangCard extends StatelessWidget {
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

  const AnimatedLangCard({
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
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
        child: ClipRect(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header section
              InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashColor: Colors.transparent,
                onTap: onCardTap,
                child: Padding(
                  padding: EdgeInsets.all(18.px),
                  child: Row(
                    children: [
                      SvgIcon(
                        svgPath: svgIconPath,
                        width: 28.px,
                        height: 28.px,
                      ),
                      SizedBox(width: 16.px),
                      Column(
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
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.all(12.px),
                        child: SvgIcon(
                          svgPath:
                              isExpanded
                                  ? AppConstant.icArrowUp
                                  : AppConstant.icArrowDown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded section
              if (isExpanded) ...[
                InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () => onTextSelect(selectedTextOne ?? ""),
                  child: _buildSelectableText(
                    text: selectedTextOne ?? "Text One",
                    selectedText: selectedText,
                    context: context,
                    svgPath: AppConstant.icEnglish,
                  ),
                ),
                InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () => onTextSelect(selectedTextTwo ?? ""),
                  child: _buildSelectableText(
                    text: selectedTextTwo ?? "Text Two",
                    selectedText: selectedText,
                    context: context,
                    svgPath: AppConstant.icBangla,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableText({
    required String text,
    required String? selectedText,
    required BuildContext context,
    required String svgPath,
  }) {
    final bool isSelected = selectedText == text;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 8.px),
      height: 60.px,
      decoration:
          isSelected
              ? ShapeDecoration(
                gradient: RadialGradient(
                  center: Alignment(1.20, 0.93),
                  radius: 10,
                  colors: [
                    context.color.siblingCardActiveGradientStart,
                    context.color.siblingCardActiveGradientEnd,
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.px),
                ),
              )
              : null,
      child: Row(
        children: [
          SvgIcon(svgPath: svgPath, width: 24.px, height: 24.px),
          SizedBox(width: 16.px),
          Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.px,
              fontWeight: FontWeight.w500,
              fontFamily: AppTextStyles.inter,
              color: context.color.cardTitleColor,
            ),
          ),
          Spacer(),
          if (isSelected)
            Icon(Icons.check, color: context.color.cardSubtitleColor),
        ],
      ),
    );
  }
}
