import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediationapp/feature/model/app_usage_ifo_model.dart';

class AppItem extends StatelessWidget {
  final AppUsageInfo appUsageInfo;
  const AppItem({super.key, required this.appUsageInfo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: Image.asset('assets/android.jpeg').image,
      ),
      title: Text(
        getAppName(appUsageInfo.packageName),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
          '${(appUsageInfo.totalTimeInForeground / (60 * 60 * 1000)).toStringAsFixed(2)} hours'),
      trailing: Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(
          DateTime.fromMillisecondsSinceEpoch(appUsageInfo.lastTimeUsed))),
    );
  }

  Image base64ToImage(String base64String) {
    final Uint8List list = base64Decode(base64String);
    return Image.memory(list);
  }

  String getAppName(String packageName) {
    final appName = packageName.split('.').last;
    return appName[0].toUpperCase() + appName.substring(1);
  }
}
