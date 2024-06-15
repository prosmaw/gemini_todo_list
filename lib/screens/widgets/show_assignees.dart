import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/screens/widgets/avatar_widget.dart';
import 'package:todo_list/utils/base_colors.dart';
import 'dart:math' as math;

class ShowAssignees extends StatelessWidget {
  ShowAssignees({super.key, required this.height, required this.assignees});
  final TaskController taskController = Get.find();
  final double height;
  final List<String> assignees;
  @override
  Widget build(BuildContext context) {
    int assigneesLength = assignees.length >= 3 ? 3 : assignees.length;
    int remain = assignees.length - assigneesLength;
    double width = assigneesLength > 1 ? 120 : 56;
    return GetBuilder<TaskController>(builder: (_) {
      return GestureDetector(
        onTap: () async {
          await taskController.getUsersNames(assignees);
          // ignore: use_build_context_synchronously
          selectAssignees(context);
        },
        child: SizedBox(
          height: 56,
          width: width,
          child: Stack(
              children: List.generate(assigneesLength, (index) {
            double leftPosition = index * 40;
            bool isMore = index == 2 ? true : false;

            return AvatarWidget(
              leftPosition: leftPosition,
              image: "",
              isMore: isMore,
              firstLetter: assignees[index].characters.first,
              remain: '$remain',
            );
          })),
        ),
      );
    });
  }

  Future<dynamic> selectAssignees(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: BaseColors.primaryColor,
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: height / 2,
            child: ListView.builder(
                itemCount: assignees.length,
                itemBuilder: (context, index) {
                  String name =
                      "${taskController.currentTaskAssignees[index].firstName} ${taskController.currentTaskAssignees[index].lastName}";
                  String email = assignees[index];
                  return AssigneeInfo(
                    name: name,
                    firstLetter: email.characters.first,
                  );
                }),
          );
        });
  }
}

class AssigneeInfo extends StatefulWidget {
  const AssigneeInfo({
    super.key,
    required this.name,
    required this.firstLetter,
  });

  final String name;
  final String firstLetter;

  @override
  State<AssigneeInfo> createState() => _AssigneeInfoState();
}

class _AssigneeInfoState extends State<AssigneeInfo> {
  Color? profilebgColor;
  @override
  void initState() {
    super.initState();
    profilebgColor =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: profilebgColor,
        child: Text(
          widget.firstLetter,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        widget.name,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
