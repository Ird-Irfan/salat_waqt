import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({super.key});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _switchValue = true; // Start with the switch in the "on" position (yellow knob to the right)

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _switchValue,
      onChanged: (value) {
        setState(() {
          _switchValue = value;
        });
      },
      materialTapTargetSize: MaterialTapTargetSize.padded, // Adjusts the tap area
      activeColor: Colors.yellow, // Yellow knob when on
      inactiveThumbColor: Colors.grey, // Grey knob when off (if needed)
      activeTrackColor: Colors.blue[900]!, // Dark blue track when on
      inactiveTrackColor: Colors.blue[900]!, // Dark blue track when off
    );
  }
}