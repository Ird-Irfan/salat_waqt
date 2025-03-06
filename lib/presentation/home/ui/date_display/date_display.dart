import 'package:flutter/material.dart';
import 'package:salat_waqt/core/constant/salat_color.dart';
import 'package:salat_waqt/presentation/home/ui/date_display/model.dart';

class DateDisplay extends StatefulWidget {
  const DateDisplay({super.key});

  @override
  State<DateDisplay> createState() => _DateDisplayState();
}

class _DateDisplayState extends State<DateDisplay> {
  int currentIndex = 0;
  final dates = DateModel.getDates();

  void _onPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _onNext() {
    if (currentIndex < dates.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

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
          colors: SalatColor.dateDisplayGradient,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _onPrevious,
          ),
          Column(
            children: [
              Text(
                dates[currentIndex].arabicDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  dates[currentIndex].englishDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: _onNext),
        ],
      ),
    );
  }
}
