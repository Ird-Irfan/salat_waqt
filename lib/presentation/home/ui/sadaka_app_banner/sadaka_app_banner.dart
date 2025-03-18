import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';

class SadaqaAdsBanner extends StatelessWidget {
  final ThemeData theme;
  final HomePresenter presenter;
  const SadaqaAdsBanner({
    super.key,
    required this.presenter,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => presenter.launchUrls(
            'https://play.google.com/store/apps/details?id=com.barakah.app',
          ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 88.px,
              width: 88.px,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.70, -0.71),
                  end: Alignment(-0.7, 0.71),
                  colors: [
                    context.color.donutRingGradientStartColor,
                    context.color.donutRingGradientEndColor,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(1),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(
                  color: context.color.donutRingGradientStartColor,
                  width: 1.px,
                ),
              ),
              child: Center(
                child: Text(
                  'সাদাকা',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.px,
                    fontFamily: AppTextStyles.alinurProttyoee,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.px),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Looking "Need a trusted spot for your sadaqa?"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.color.cardSubtitleColor,
                      fontSize: 14.px,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppTextStyles.inter,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Explore Sadaqa App',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 17.px,
                          fontWeight: FontWeight.w600,
                          color: context.color.cardTitleColor,
                        ),
                      ),
                      SizedBox(width: 8.px),
                      SvgPicture.asset(
                        AppConstant.icRightArrowForward,
                        width: 24.px,
                        height: 24.px,
                        colorFilter: ColorFilter.mode(
                          context.color.cardTitleColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
