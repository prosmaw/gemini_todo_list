import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/screens/widgets/background_clip.dart';
import 'package:todo_list/screens/widgets/show_assignees.dart';

import 'package:todo_list/utils/base_colors.dart';

class Taskdetails extends StatefulWidget {
  const Taskdetails({
    super.key,
  });
  @override
  State<Taskdetails> createState() => _TaskdetailsState();
}

class _TaskdetailsState extends State<Taskdetails> {
  double checkLeft = 5;
  double checkRight = 0;
  bool isDone = false;
  AppAuthController appAuthController = Get.find();
  TaskController taskController = Get.find();
  Task task = Get.arguments as Task;
  bool anim = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        anim = true;
      });
    });
    if (!task.active) {
      setState(() {
        checkLeft = Get.size.width - 105;
        isDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<AppAuthController>(builder: (_) {
      String creatorName =
          "${taskController.currentTaskCreator?.firstName} ${taskController.currentTaskCreator?.lastName}";
      return Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: ClipPath(
              clipper: BackgroundClip(screenHeight: height),
              child: AnimatedContainer(
                curve: Curves.bounceIn,
                duration: Durations.long1,
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      task.taskColor!['a'],
                      task.taskColor!['r'],
                      task.taskColor!['g'],
                      task.taskColor!['b']),
                ),
                height: anim ? height : 0,
                width: anim ? width : 0,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              title: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const CircleAvatar(
                  backgroundColor: BaseColors.primaryColor,
                  radius: 28,
                  child: Icon(
                    Icons.expand_more,
                    weight: 600,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: const [
                CircleAvatar(
                  backgroundColor: BaseColors.primaryColor,
                  radius: 28,
                  child: Icon(
                    Icons.more_horiz,
                    weight: 600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            body: Container(
              height: height,
              width: width,
              margin: const EdgeInsets.only(left: 15, right: 15, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 120,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: BaseColors.primaryColor)),
                    child: Center(
                      child: Text(
                        task.boardName,
                        style: const TextStyle(
                            color: BaseColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(task.name,
                      style: const TextStyle(
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                          height: 1)),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time left',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Assignee",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.getDueTime(task.dueDate),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormat.yMMMMd().format(task.dueDate),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      ShowAssignees(height: height, assignees: task.assignees)
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'Additional description',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    task.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Created',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${DateFormat.yMMMMd().format(task.dateCreated)} by $creatorName",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            floatingActionButton: SizedBox(
              width: width - 30,
              height: 80,
              child: Stack(
                children: [
                  Container(
                    width: width - 30,
                    height: 80,
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        color: BaseColors.primaryColor,
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                      child: Text(
                        isDone ? "Not done" : "Set as Done",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  Positioned(
                    left: checkLeft,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        if (details.localPosition.dx > 0 &&
                            details.localPosition.dx < width - 30) {
                          setState(() {
                            checkLeft = details.localPosition.dx;
                          });
                        }
                      },
                      onHorizontalDragEnd: (details) async {
                        if (checkLeft <= (width - 30) / 2) {
                          setState(() {
                            checkLeft = 5;
                            isDone = false;
                          });
                          taskController.updateTaskState(
                              task.taskId.toString(), true);
                        } else if (checkLeft >= (width - 30) / 2) {
                          setState(() {
                            checkLeft = width - 105;
                            isDone = true;
                          });
                          taskController.updateTaskState(
                              task.taskId.toString(), false);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 35,
                        child: Icon(
                          isDone ? Icons.close : Icons.check,
                          size: 30,
                          color: BaseColors.primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ],
      );
    });
  }
}
