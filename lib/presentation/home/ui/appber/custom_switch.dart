import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool switchValue;
  final Function(bool) onSwitchChanged;

  const CustomSwitch({
    super.key,
    required this.switchValue,
    required this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: switchValue,
      onChanged: onSwitchChanged,
      activeColor: Colors.black, // When switch is ON, thumb color
      activeTrackColor: Colors.white, // When switch is ON, track color
      inactiveThumbColor: Colors.white, // When switch is OFF, thumb color
      inactiveTrackColor: Colors.black, // When switch is OFF, track color
    );
  }
}
