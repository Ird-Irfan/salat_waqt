import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class SadaqaAppBanner extends StatelessWidget {
  final ThemeData theme;
  const SadaqaAppBanner({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 88.px,
          width: 88.px,
          decoration: BoxDecoration(
            color: context.color.primaryColor500,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.px),
              bottomLeft: Radius.circular(25.px),
              bottomRight: Radius.circular(25.px),
              topRight: Radius.circular(1.px),
            ),
          ),
          child: Center(
            child: Text(
              'সাদাকা',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Looking "Need a trusted spot for your sadaqa?"',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 14.px,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Explore Sadaqa App',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 18.px,
                      fontWeight: FontWeight.w600,
                      color: context.color.primaryColor300,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 22.px,
                    color: context.color.primaryColor300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
