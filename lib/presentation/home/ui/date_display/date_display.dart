import 'package:flutter/material.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';

class DateDisplay extends StatelessWidget {
  final HomePresenter presenter;
  const DateDisplay({super.key, required this.presenter});

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
          colors: [Color(0xFF1A2234), Color(0xFF1A2234).withOpacityInt(0.8)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              presenter.previousDate();
            },
          ),
          Column(
            children: [
              Text(
                presenter.currentUiState.arabicDate ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  presenter.currentUiState.englishDate ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () {
              presenter.nextDate();
            },
          ),
        ],
      ),
    );
  }
}
