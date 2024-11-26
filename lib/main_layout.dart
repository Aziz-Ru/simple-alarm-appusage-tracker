import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mediationapp/core/constants/constants.dart';
import 'package:mediationapp/core/themes/colors.dart';
import 'package:mediationapp/feature/alarm/alarm_screen.dart';
import 'package:mediationapp/feature/home/home_screen.dart';
import 'package:mediationapp/feature/pomodometer/pomo_screen.dart';
import 'package:mediationapp/feature/quotes/quotes_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final List<Widget> screens = const [
    HomeScreen(),
    AlarmScreen(),
    PomodoMeter(),
    QuotesScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          index: _currentIndex,
          backgroundColor: AppColors.primaryLight,
          color: AppColors.primary,
          items: Constants.items),
    );
  }
}
