import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediationapp/core/themes/colors.dart';
import 'package:mediationapp/core/utils/error_text.dart';
import 'package:mediationapp/feature/home/get_usage_states.dart';
import 'package:mediationapp/core/utils/loader.dart';
import 'package:mediationapp/feature/quotes/controller.dart';
import 'package:mediationapp/widgets/app_item.dart';
import 'package:mediationapp/widgets/quotes_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Productivity App',
          style: TextStyle(
              color: AppColors.textIcons,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 250,
                child: AnalogClock(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.grey),
                      color: AppColors.cardBackgroundColor,
                      shape: BoxShape.circle),
                  width: 150.0,
                  isLive: true,
                  hourHandColor: Colors.pink,
                  minuteHandColor: Colors.white,
                  showSecondHand: false,
                  numberColor: Colors.white,
                  showNumbers: true,
                  showAllNumbers: true,
                  textScaleFactor: 1.4,
                  showTicks: true,
                  showDigitalClock: true,
                  digitalClockColor: Colors.white,
                  datetime: DateTime.now(),
                ),
              ),
              const SizedBox(height: 20),
              ref.watch(getTodayQuoteProvider).when(
                    data: (data) {
                      return QuoteWidget(quote: data);
                    },
                    error: (error, stack) => ErrorText(text: error.toString()),
                    loading: () => const Loader(),
                  ),
              const SizedBox(height: 20),
              const Text("Your Used Apps",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ref.watch(getUsageStatsProvider).when(
                    data: (data) {
                      if (data.isEmpty) {
                        return const Text("Please grant usage access");
                      }
                      return Column(
                        children: [
                          ...data.map((info) {
                            return AppItem(appUsageInfo: info);
                          })
                        ],
                      );
                    },
                    error: (error, stack) => ErrorText(text: error.toString()),
                    loading: () => const Loader(),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
