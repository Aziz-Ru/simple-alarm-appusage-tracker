import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediationapp/feature/model/app_usage_ifo_model.dart';

final appUsageStatsProvider = StateNotifierProvider<AppUsageStats, bool>((ref) {
  return AppUsageStats();
});

final getUsageStatsProvider = FutureProvider<List<AppUsageInfo>>((ref) async {
  final appUsageStats = ref.watch(appUsageStatsProvider.notifier);
  final isGranted = await appUsageStats.isUsageStatesGranted();
  if (isGranted) {
    return await appUsageStats.getUsageStats();
  }

  return [];
});

class AppUsageStats extends StateNotifier<bool> {
  AppUsageStats() : super(false);
  static const _channel =
      MethodChannel('com.example.mediationapp/usage_permission');

  Future<bool> isUsageStatesGranted() async {
    if (Platform.isAndroid) {
      try {
        final result =
            await _channel.invokeMethod('isUsageAccessGranted') ?? false;

        return result;
      } catch (e) {
        // log(e.toString());
        return false;
      }
    }
    return false;
  }

  Future<List<AppUsageInfo>> getUsageStats() async {
    try {
      // log('Fetching usage stats  in dart');
      final response = await _channel.invokeMethod('getUsageStats');
      List<AppUsageInfo> appUsageInfo = [];
      for (final item in response) {
        appUsageInfo.add(AppUsageInfo(
          lastTimeUsed: item['lastTimeUsed'],
          packageName: item['packageName'],
          totalTimeInForeground: item['totalTimeInForeground'],
        ));
      }
      appUsageInfo.sort(
          (a, b) => b.totalTimeInForeground.compareTo(a.totalTimeInForeground));
      return appUsageInfo;
    } catch (e) {
      log('Error fetching usage stats dart: $e');
      return [];
    }
  }
}
