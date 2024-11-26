import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediationapp/core/themes/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PomodoMeter extends ConsumerStatefulWidget {
  const PomodoMeter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PomodoMeterState();
}

class _PomodoMeterState extends ConsumerState<PomodoMeter> {
  double percent = 0.0;
  int timeInMinutes = 25;
  int timeInSeconds = 1500;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (timeInSeconds > 0) {
          timeInSeconds--;
          percent =
              timeInSeconds / 1500; // Calculate percentage based on time left
        } else {
          timer.cancel(); // Stop the timer when time is up
        }
      });
    });
  }

  // Function to reset the timer
  void resetTimer() {
    setState(() {
      timer?.cancel();
      timeInSeconds = 1500;
      percent = 1.0; // Reset to 100%
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel(); // Clean up the timer when the widget is disposed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Timer',
          style: TextStyle(
              color: AppColors.textIcons,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 10.0,
              percent: percent,
              progressColor: AppColors.primary,
              center: Text(
                '${(percent * timeInMinutes).toInt()} min',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (timer == null || !timer!.isActive) {
                      startTimer(); // Start the timer if it's not running
                    }
                  },
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: resetTimer,
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
