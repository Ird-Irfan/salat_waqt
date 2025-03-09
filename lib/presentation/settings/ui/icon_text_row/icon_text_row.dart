import 'package:flutter/material.dart';

class IconTextRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool switchValue;
  final Function(bool) onSwitchChanged;

  const IconTextRow({
    super.key,
    this.title = "User Name",
    this.subtitle = "user@example.com",
    this.icon = Icons.account_circle,
    required this.switchValue,
    required this.onSwitchChanged,
  });

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
          Icon(icon, size: 40, color: Colors.blue),
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
          Switch(
            value: switchValue,
            onChanged: onSwitchChanged,
            activeColor: Colors.black, // When switch is ON, thumb color
            activeTrackColor: Colors.white, // When switch is ON, track color
            inactiveThumbColor: Colors.white, // When switch is OFF, thumb color  
            inactiveTrackColor: Colors.black, // When switch is OFF, track color
          ),
        ],
      ),
    );
  }
}
