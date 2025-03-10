import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';

class DateDisplay extends StatelessWidget {
  final HomePresenter presenter;
  final ThemeData theme;
  const DateDisplay({
    super.key,
    required this.presenter,
    required this.theme,
    required String englishDate,
    required String arabicDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.px,
      height: 110.px,
      padding: EdgeInsets.all(30.px),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.93, 1.20),
          radius: 0.72,
          colors: [
            context.color.bgCardGradient1,
            context.color.bgCardGradient2,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              presenter.previousDate();
            },
            child: SvgIcon(
              svgPath: AppConstant.icArrowLeft,
              width: 24.px,
              height: 24.px,
              color: context.color.cardTitleColor,
            ),
          ),
          Column(
            children: [
              Text(
                presenter.currentUiState.arabicDate ?? '',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.color.cardTitleColor,
                  fontSize: 18.px,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTextStyles.inter,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  presenter.currentUiState.englishDate ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.color.cardSubtitleColor,
                    fontSize: 14.px,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppTextStyles.inter,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              presenter.nextDate();
            },
            child: SvgIcon(
              svgPath: AppConstant.icArrowRight,
              width: 24.px,
              height: 24.px,
              color: context.color.cardTitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
