import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mediationapp/core/themes/colors.dart';
import 'package:mediationapp/core/utils/show_snackbar.dart';
import 'package:mediationapp/feature/alarm/alarm_repo.dart';
import 'package:mediationapp/feature/alarm/time_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmScreen extends ConsumerStatefulWidget {
  const AlarmScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends ConsumerState<AlarmScreen> {
  String? dateTime;
  bool repeat = false;
  DateTime? notificationtime;
  SharedPreferences? prefs;
  String alarmKey = 'alarm';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addAlarm() async {
    if (dateTime != null &&
        titleController.text.isNotEmpty &&
        notificationtime != null &&
        descriptionController.text.isNotEmpty) {
      final notRef = ref.watch(notificationRepositoryProvider);
      notRef.setAlarm(
          id: 0,
          title: titleController.text.trim(),
          body: descriptionController.text.trim(),
          scheduledTime: notificationtime!);
      showSnackBar(context, "Reminder set successfully");
    } else {
      showSnackBar(context, "Please fill all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final times = ref.watch(notificationRepositoryProvider).getAllTimeModels();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Reminder',
          style: TextStyle(
              color: AppColors.textIcons,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CupertinoDatePicker(
                    showDayOfWeek: true,
                    minimumDate: DateTime.now(),
                    maximumDate: DateTime.now().add(const Duration(days: 15)),
                    dateOrder: DatePickerDateOrder.dmy,
                    onDateTimeChanged: (va) {
                      notificationtime = va;
                      dateTime = notificationtime.toString();
                      setState(() {});
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Title",
                  label: Text("Title"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 50,
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  label: Text("Description"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    onPressed: addAlarm,
                    child: const Text(
                      "Set Reminder",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (times.isNotEmpty)
              Column(
                children: [
                  ...times.map((e) {
                    return ListTile(
                      title: Text(e.title),
                      subtitle: Text(DateFormat('dd-MM-yyyy hh:mm a')
                          .format(e.scheduledTime)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ref
                              .read(notificationRepositoryProvider)
                              .cancelAlarm(e.id);
                          setState(() {});
                        },
                      ),
                    );
                  }),
                ],
              )
          ],
        ),
      ),
    );
  }

  List<TimeModel> _getAllTimeModels() {
    final jsonString = prefs?.getString(alarmKey);

    if (jsonString != null) {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((e) => TimeModel.fromJson(e)).toList();
    }
    return [];
  }
}
