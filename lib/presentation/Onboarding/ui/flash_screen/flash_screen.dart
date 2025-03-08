import 'package:flutter/material.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/presentation/Onboarding/widgets/reusable_flash_screen.dart';

class FlashScreen extends StatelessWidget {
  const FlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableFlashScreen(
      backgroundImagePath: AppConstant.bgflashScreen,
      logoImagePath: AppConstant.flashScreenlogo,
      title: 'Muslim Prayer Time',
      subtitle: 'IRD Foundation',
    );
  }
}
