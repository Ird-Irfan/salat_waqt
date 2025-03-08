import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_color.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/ui/date_display/model.dart';

class DateDisplay extends StatefulWidget {
  final ThemeData theme;
  const DateDisplay({super.key, required this.theme});

  @override
  State<DateDisplay> createState() => _DateDisplayState();
}

class _DateDisplayState extends State<DateDisplay> {
  int currentIndex = 0;
  final dates = DateModel.getDates();

  void _onPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _onNext() {
    if (currentIndex < dates.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.px),
      child: Container(
        width: 350.px,
        height: 88.px,
        padding: EdgeInsets.all(20.px),
        decoration: ShapeDecoration(
          gradient: RadialGradient(
            center: Alignment(0.93, 1.20),
            radius: 0.72,
            colors: SalatColor.dateDisplayGradientDark,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFF253142)),
            borderRadius: BorderRadius.circular(16.px),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: _onPrevious,
              child: SvgIcon(
                svgPath: AppConstant.icArrowLeft,
                color: context.color.primaryColor300,
                height: 24,
                width: 24,
              ),
            ),
            Column(
              children: [
                Text(
                  dates[currentIndex].arabicDate,
                  style: widget.theme.textTheme.labelMedium?.copyWith(
                    fontSize: 18.px,
                    color: context.color.primaryColor300,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppTextStyles.inter,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    dates[currentIndex].englishDate,
                    style: widget.theme.textTheme.labelMedium?.copyWith(
                      fontSize: 14.px,
                      color: context.color.primaryColorDarkSubtitle,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppTextStyles.inter,
                    ),
                    // style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: _onNext,
              child: SvgIcon(
                svgPath: AppConstant.icArrowRight,
                color: context.color.primaryColor300,
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
