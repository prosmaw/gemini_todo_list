import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/controllers/task_creation_controller.dart';
import 'package:todo_list/model/board.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/screens/widgets/assignees_widget.dart';
import 'package:todo_list/screens/widgets/background_clip.dart';
import 'package:todo_list/screens/widgets/task/task_creation.dart';
import 'package:todo_list/utils/base_colors.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController nameController =
      TextEditingController(text: "Task Name");
  TextEditingController descriptionController =
      TextEditingController(text: "Add task description");
  String startTimeText = DateFormat.jm().format(DateTime.now());
  TaskController taskController = Get.find();
  AppAuthController appAuthController = Get.find();
  TaskCreationController taskCreationController =
      Get.put(TaskCreationController());
  Color pageColor = Colors.white;
  bool assigneeRequired = false;

  Board? boardSelected;
  bool anim = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        anim = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GetBuilder<TaskCreationController>(builder: (_) {
      return GetBuilder<TaskController>(builder: (_) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: ClipPath(
                clipper: BackgroundClip(screenHeight: height),
                child: AnimatedContainer(
                  curve: Curves.bounceIn,
                  duration: Durations.long4,
                  decoration: BoxDecoration(color: pageColor),
                  height: anim ? height : 0,
                  width: anim ? width : 0,
                ),
              ),
            ),
            Scaffold(
              resizeToAvoidBottomInset: true,
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
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                padding: const EdgeInsets.only(bottom: 90),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 40,
                        width: 120,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: BaseColors.primaryColor)),
                        child: Center(
                          child: DropdownButton<Board>(
                              hint: const Text("Board"),
                              value: boardSelected,
                              style: const TextStyle(
                                  color: BaseColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              underline: const SizedBox(),
                              dropdownColor: pageColor,
                              items: taskController.boards
                                  .map<DropdownMenuItem<Board>>((e) =>
                                      DropdownMenuItem<Board>(
                                          value: e, child: Text(e.name)))
                                  .toList(),
                              onChanged: (Board? value) {
                                taskCreationController.requireBoard(false);
                                setState(() {
                                  boardSelected = value!;
                                  pageColor = Color.fromARGB(
                                      value.color['a'],
                                      value.color['r'],
                                      value.color['g'],
                                      value.color['b']);
                                });
                              }),
                        ),
                      ),
                      Visibility(
                          visible:
                              taskCreationController.requiredBoard ?? false,
                          child: const Text(
                            "Please choose a board",
                            style: TextStyle(color: Colors.red),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      EditableText(
                        style: const TextStyle(
                            fontSize: 65,
                            fontWeight: FontWeight.bold,
                            height: 1,
                            color: BaseColors.primaryColor),
                        maxLines: 2,
                        controller: nameController,
                        focusNode: FocusNode(),
                        cursorColor: BaseColors.primaryColor,
                        backgroundCursorColor: BaseColors.primaryColor,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Due date',
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
                              GestureDetector(
                                onTap: () {
                                  taskCreationController.selectDate(context);
                                },
                                child: Text(
                                  taskCreationController.dateStart,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  taskCreationController.selectTime(context);
                                },
                                child: Text(
                                  taskCreationController.taskTime == null
                                      ? startTimeText
                                      : taskCreationController.taskTime!
                                          .format(context),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          AssigneesWidget(
                              height: height, boardSelected: boardSelected)
                        ],
                      ),
                      Visibility(
                          visible: assigneeRequired,
                          child: const Text(
                            "Please choose assignees",
                            style: TextStyle(color: Colors.red),
                          )),
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
                      EditableText(
                          controller: descriptionController,
                          maxLines: 20,
                          focusNode: FocusNode(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: BaseColors.primaryColor),
                          cursorColor: BaseColors.primaryColor,
                          backgroundCursorColor: BaseColors.primaryColor),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: GestureDetector(
                  child: TaskCreation(
                width: width,
                onPressed: createTask,
              )),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          ],
        );
      });
    });
  }

  createTask() async {
    if (taskCreationController.assignees.isNotEmpty) {
      Task task = Task(
          boardid: boardSelected!.boardDocId.toString(),
          name: nameController.text,
          dueDate: taskCreationController.dueDate(),
          creator: appAuthController.currentUser!.email,
          boardName: boardSelected!.name,
          description: descriptionController.text,
          active: true,
          assignees: taskCreationController.assignees,
          dateCreated: DateTime.now());
      await taskController.addtask(task);
      taskController.updateTasks();
      Get.back();
    } else {
      setState(() {
        assigneeRequired = true;
      });
    }
  }
}
