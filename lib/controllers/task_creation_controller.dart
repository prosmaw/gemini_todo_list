import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/utils/themes.dart';

class TaskCreationController extends GetxController {
  DateTime? taskDate;
  String dateStart = DateFormat.yMMMMd().format(DateTime.now());
  TimeOfDay? taskTime;
  Themes appThemes = Themes();
  List<String> assignees = [];
  bool sending = false;
  bool? requiredBoard;

  void requireBoard(bool require) {
    requiredBoard = require;
    update();
  }

  DateTime dueDate() {
    taskDate ??= DateTime.now();
    taskTime ??= TimeOfDay.now();
    return DateTime(taskDate!.year, taskDate!.month, taskDate!.day,
        taskTime!.hour, taskTime!.minute);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return appThemes.dateTimeTheme(context, child);
      },
    );
    if (datePicked != null && datePicked != DateTime.now()) {
      taskDate = datePicked;
      dateStart = DateFormat.yMMMMd().format(datePicked);
      update();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return appThemes.dateTimeTheme(context, child);
      },
    );
    if (timePicked != null && timePicked != TimeOfDay.now()) {
      taskTime = timePicked;
      update();
    }
  }
}
