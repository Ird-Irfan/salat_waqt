import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Preferences',
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: 16.px,
          fontFamily: AppTextStyles.inter,
          fontWeight: FontWeight.w500,
          color: context.color.cardTitleColor,
        ),
      ),
      flexibleSpace: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.00, -1.00),
              end: const Alignment(0, 1),
              colors: [
                context.color.appBarBgColor.withOpacityInt(0.01),
                Colors.transparent,
              ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacityInt(0.1)),
          ),
        ),
      ),
    );
  }
}
