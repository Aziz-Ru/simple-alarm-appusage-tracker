import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediationapp/feature/alarm/time_model.dart';
import 'package:mediationapp/feature/alarm/utitls.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());

final notificationRepositoryProvider = Provider<NotifictionRepository>((ref) {
  // Wait for SharedPreferences to load
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;

  if (prefs == null) {
    throw Exception('SharedPreferences not loaded');
  }

  // Create NotifictionRepository after SharedPreferences is loaded
  return NotifictionRepository(prefs: prefs);
});

final getAllTimeModelsProvider = FutureProvider<List<TimeModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getAllTimeModels();
});

class NotifictionRepository {
  SharedPreferences prefs;
  static const String alarmKey = 'alarm';
  NotifictionRepository({required this.prefs});

  Future<void> setAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    TimeModel timeModel = TimeModel(
      id: id,
      title: title,
      description: body,
      scheduledTime: scheduledTime,
    );
    List<TimeModel> timeModels = _getAllTimeModels();
    timeModels.add(timeModel);
    await prefs.setString(alarmKey, jsonEncode(timeModels));
    await NotificationService.setAlarm(timeModel: timeModel);
  }

  Future<void> cancelAlarm(int id) async {
    List<TimeModel> timeModels = _getAllTimeModels();
    timeModels.removeWhere((element) => element.id == id);
    await prefs.setString(alarmKey, jsonEncode(timeModels));
    await NotificationService.cancelNotification(id);
  }

  List<TimeModel> getAllTimeModels() {
    return _getAllTimeModels();
  }

  List<TimeModel> _getAllTimeModels() {
    final jsonString = prefs.getString(alarmKey);
    if (jsonString != null) {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((e) => TimeModel.fromJson(e)).toList();
    }
    return [];
  }
}
