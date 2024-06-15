import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/controllers/task_creation_controller.dart';
import 'package:todo_list/model/board.dart';
import 'package:todo_list/model/user_model.dart';
import 'package:todo_list/screens/widgets/avatar_widget.dart';
import 'package:todo_list/utils/base_colors.dart';
import 'dart:math' as math;

class AssigneesWidget extends StatefulWidget {
  const AssigneesWidget(
      {super.key, required this.height, this.boardSelected, this.assignees});

  final double height;
  final Board? boardSelected;
  final List<String>? assignees;

  @override
  State<AssigneesWidget> createState() => _AssigneesWidgetState();
}

class _AssigneesWidgetState extends State<AssigneesWidget> {
  TaskCreationController taskCreationController = Get.find();
  TaskController taskController = Get.find();
  @override
  Widget build(BuildContext context) {
    int assigneesLength = taskCreationController.assignees.length >= 3
        ? 3
        : taskCreationController.assignees.length;
    int remain = taskCreationController.assignees.length - assigneesLength;
    double width = assigneesLength > 1 ? 120 : 56;
    return GestureDetector(
      onTap: () async {
        if (taskCreationController.requiredBoard == null ||
            taskCreationController.requiredBoard == true) {
          taskCreationController.requireBoard(true);
        } else if (taskCreationController.requiredBoard == false) {
          await taskController.getUsersNames(widget.boardSelected!.members);
          // ignore: use_build_context_synchronously
          selectAssignees(context);
        }
      },
      child: taskCreationController.assignees.isEmpty
          ? const CircleAvatar(
              backgroundColor: BaseColors.primaryColor,
              radius: 28,
              child: Icon(
                Icons.person_add,
                weight: 600,
                color: Colors.white,
              ),
            )
          : SizedBox(
              height: 56,
              width: width,
              child: Stack(
                  children: List.generate(assigneesLength, (index) {
                double leftPosition = index * 40;
                bool isMore = false;
                if (index == 2) {
                  setState(() {
                    isMore = true;
                  });
                }
                return AvatarWidget(
                  leftPosition: leftPosition,
                  image: "",
                  isMore: isMore,
                  firstLetter:
                      taskCreationController.assignees[index].characters.first,
                  remain: '$remain',
                );
              })),
            ),
    );
  }

  Future<dynamic> selectAssignees(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: BaseColors.primaryColor,
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: widget.height / 2,
            child: ListView.builder(
                itemCount: widget.boardSelected?.members.length,
                itemBuilder: (context, index) {
                  String email = widget.boardSelected!.members[index];
                  //current function was used only to retrieve current board
                  //members name
                  UserModel member = taskController.currentTaskAssignees[index];
                  String name = "${member.firstName} ${member.lastName}";
                  return AssigneeInfo(
                    name: name,
                    firstLetter: email.characters.first,
                    email: email,
                  );
                }),
          );
        });
  }
}

class AssigneeInfo extends StatefulWidget {
  const AssigneeInfo(
      {super.key,
      required this.name,
      required this.firstLetter,
      required this.email});

  final String name;
  final String firstLetter;
  final String email;

  @override
  State<AssigneeInfo> createState() => _AssigneeInfoState();
}

class _AssigneeInfoState extends State<AssigneeInfo> {
  TaskCreationController taskCreationController = Get.find();
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    if (taskCreationController.assignees.contains(widget.email)) {
      isSelected = true;
    }
    return GestureDetector(
      onTap: () {
        if (!taskCreationController.assignees.contains(widget.email)) {
          taskCreationController.assignees.add(widget.email);
          taskCreationController.update();
          setState(() {
            isSelected = true;
          });
        } else {
          taskCreationController.assignees
              .removeWhere((element) => element == widget.email);
          taskCreationController.update();
          setState(() {
            isSelected = false;
          });
        }
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor:
              Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
          child: Text(
            widget.firstLetter,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: isSelected
            ? CircleAvatar(
                radius: 28,
                backgroundColor: BaseColors.primaryColor.withOpacity(0.7),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              )
            : const SizedBox(),
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
