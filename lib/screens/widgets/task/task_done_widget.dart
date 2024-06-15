import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/screens/widgets/task/task_widget.dart';

class TaskDoneWidget extends StatelessWidget {
  TaskDoneWidget({super.key});
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<TaskController>(builder: (_) {
      return taskController.tasksDone.isNotEmpty
          ? ListView.builder(
              itemCount: taskController.tasksDone.length,
              itemBuilder: (context, index) {
                return TaskWidget(
                  width: width,
                  height: height,
                  task: taskController.tasksDone[index],
                  done: true,
                );
              })
          : Column(
              //case task list is empty
              children: [
                Container(
                  height: (width) / 3,
                  width: (width) / 3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage("assets/images/clipboard.png"))),
                ),
                const Text(
                  "No Task avalaible",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            );
    });
  }
}
