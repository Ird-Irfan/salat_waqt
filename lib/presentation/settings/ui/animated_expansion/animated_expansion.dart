import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class AnimatedExpansion extends StatefulWidget {
  final ThemeData theme;
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const AnimatedExpansion({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
    required this.theme,
  });

  @override
  AnimatedExpansionState createState() => AnimatedExpansionState();
}

class AnimatedExpansionState extends State<AnimatedExpansion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: _isExpanded ? null : 88,
      constraints: BoxConstraints(
        minHeight: 88,
        maxHeight: _isExpanded ? 220 : 88,
      ),
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
      child: ClipRect(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header (always visible)
              InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  // height: 80.px,
                  child: Padding(
                    padding: EdgeInsets.all(8.0.px),
                    child: Row(
                      children: [
                        SvgIcon(
                          svgPath: AppConstant.icTheme,
                          width: 32.px,
                          height: 32.px,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Theme',
                              style: widget.theme.textTheme.titleMedium
                                  ?.copyWith(
                                    fontFamily: AppTextStyles.inter,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.px,
                                    color: context.color.cardTitleColor,
                                  ),
                            ),
                            SizedBox(height: 8.px),
                            Text(
                              widget.isDarkMode
                                  ? 'Night Mode Selected'
                                  : 'Day Mode Selected',
                              style: widget.theme.textTheme.bodySmall?.copyWith(
                                fontFamily: AppTextStyles.inter,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.px,
                                color: context.color.cardSubtitleColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Expanded options
              if (_isExpanded) ...[
                // Day Mode Option
                InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashColor: Colors.transparent,
                  onTap: () {
                    if (widget.isDarkMode) {
                      widget.onThemeChanged(false);
                    }
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: _themeMode('Day Mode', AppConstant.icDuhur),
                ),
                // Night Mode Option
                InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashColor: Colors.transparent,
                  onTap: () {
                    if (!widget.isDarkMode) {
                      widget.onThemeChanged(true);
                    }
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: _themeMode('Night Mode', AppConstant.icIsha),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeMode(String title, String svgPath) {
    bool isSelected =
        (title == 'Night Mode' && widget.isDarkMode) ||
        (title == 'Day Mode' && !widget.isDarkMode);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 60,
      child: Row(
        children: [
          SvgIcon(svgPath: svgPath, width: 28.px, height: 28.px),
          const SizedBox(width: 12),
          Text(title, style: widget.theme.textTheme.titleMedium),
          const Spacer(),
          if (isSelected) const Icon(Icons.check),
        ],
      ),
    );
  }
}
