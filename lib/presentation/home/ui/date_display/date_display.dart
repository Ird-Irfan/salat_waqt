import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_color.dart';

class DateDisplay extends StatelessWidget {
  final String englishDate;
  final String arabicDate;
  const DateDisplay({
    super.key,
    required this.englishDate,
    required this.arabicDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 80,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.93, 1.20),
          radius: 0.72,
          colors: [
            SalatColor.primaryColorDark300,
            SalatColor.primaryColorDark300,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
          Column(
            children: [
              Text(
                arabicDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  englishDate,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
        ],
      ),
    );
  }
}
