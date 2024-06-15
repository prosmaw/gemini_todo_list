import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/screens/pages/task_details.dart';
import 'package:todo_list/screens/widgets/avatar_widget.dart';

class TaskWidget extends StatelessWidget {
  TaskWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.task,
      required this.done});

  final double width;
  final double height;
  final Task task;
  final bool done;
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    int assigneesLength = task.assignees.length > 3 ? 3 : task.assignees.length;
    int remain = task.assignees.length - assigneesLength;
    return GestureDetector(
      onTap: () async {
        await taskController.getAUser(task.creator);
        Get.to(() => const Taskdetails(),
            arguments: task, transition: Transition.downToUp);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 10),
        width: width - 30,
        //height: height * 0.19,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color.fromARGB(
                task.taskColor?['a'] ?? 255,
                task.taskColor?['r'] ?? 255,
                task.taskColor?['g'] ?? 255,
                task.taskColor?['b'] ?? 255)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  height: 56,
                  child: Stack(
                      children: List.generate(assigneesLength, (index) {
                    double leftPosition = index * 40;
                    bool isMore = index == 2 ? true : false;
                    return AvatarWidget(
                      leftPosition: leftPosition,
                      image: "",
                      isMore: isMore,
                      firstLetter:
                          task.assignees[index].characters.first.toUpperCase(),
                      remain: '$remain',
                    );
                  })),
                ),
                Row(
                  children: [
                    !done
                        ? Column(
                            children: [
                              Text(
                                task.getDueTime(task.dueDate),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  DateFormat('EEE MMMM d').format(task.dueDate),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        !done
                            ? taskController.updateTaskState(
                                task.taskId.toString(), false)
                            : taskController.deleteTask(task.taskId.toString());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent.withOpacity(0.1),
                        radius: 28,
                        child: Icon(
                          !done ? Icons.check : Icons.close,
                          weight: 600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              task.boardName,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              maxLines: 1,
              overflow: TextOverflow.fade,
              task.name,
              style: const TextStyle(color: Colors.black, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
