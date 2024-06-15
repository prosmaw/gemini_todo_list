import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/task_controller.dart';

class DateDoneRow extends StatelessWidget {
  DateDoneRow({
    super.key,
    required this.jourPresent,
    required this.datePresent,
  });

  final String jourPresent;
  final String datePresent;
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (_) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //column de la date
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's $jourPresent",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                datePresent,
                style: const TextStyle(
                  color: Color.fromARGB(255, 99, 112, 134),
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          //column d'accomplissement de task
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${taskController.rateDone}% Done",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Completed Tasks",
                style: TextStyle(
                  color: Color.fromARGB(255, 99, 112, 134),
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ],
      );
    });
  }
}
