import 'package:flutter/material.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/ui/appber/custom_switch.dart';

class IconTextRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgIconPath;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;
  final bool hasSwitch;

  const IconTextRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgIconPath,
    this.hasSwitch = true,
    this.switchValue,
    this.onSwitchChanged,
  }) : assert(
          hasSwitch == false || (switchValue != null && onSwitchChanged != null),
          'If hasSwitch is true, switchValue and onSwitchChanged must not be null',
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Content er size onujayi adjust hobe
        children: [
          SvgIcon(svgPath: svgIconPath),
          SizedBox(width: 10), // Space between icon and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Content er size onujayi adjust hobe
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
          Spacer(), // Row er baki space niye nibe
          if (hasSwitch)
            CustomSwitch(
              switchValue: switchValue!,
              onSwitchChanged: onSwitchChanged!,
            ),
        ],
      ),
    );
  }
}
