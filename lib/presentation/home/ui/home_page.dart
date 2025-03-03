import 'package:flutter/material.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Salat Waqt App', style: AppTextStyles.title)),
    );
  }
}
