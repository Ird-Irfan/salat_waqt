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
    return Container(
      width: double.infinity,
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
      child: ClipRect(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.linear,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
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
                      SvgIcon(
                        svgPath:
                            isExpanded
                                ? AppConstant.icArrowUp
                                : AppConstant.icArrowDown,
                        color: context.color.cardTitleColor,
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
                    selectedTextOne ?? "Text One",
                    selectedText,
                    context,
                  ),
                ),
                InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () => onTextSelect(selectedTextTwo ?? ""),
                  child: _buildSelectableText(
                    selectedTextTwo ?? "Text Two",
                    selectedText,
                    context,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableText(
    String text,
    String? selectedText,
    BuildContext context,
  ) {
    final bool isSelected = selectedText == text;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 8.px),
      height: 60.px,
      decoration:
          isSelected
              ? BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.97, 0.00),
                  radius: 2.57,
                  colors: [
                    context.color.siblingCardActiveGradientStart.withOpacity(
                      0.5,
                    ),
                    context.color.siblingCardActiveGradientEnd.withOpacity(0.5),
                  ],
                ),
              )
              : null,
      child: Row(
        children: [
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
            SvgIcon(svgPath: AppConstant.icSelect, width: 24.px, height: 24.px),
        ],
      ),
    );
  }
}
