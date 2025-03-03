import 'package:flutter/material.dart';

class AppBarSection extends StatelessWidget {
  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2234),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Dhaka, Bangladesh',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2234),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none_outlined,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}
