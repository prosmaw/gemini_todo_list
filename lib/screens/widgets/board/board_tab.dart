import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/screens/widgets/board/board_widget.dart';

class BoardTab extends StatelessWidget {
  BoardTab({super.key});
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<TaskController>(builder: (_) {
      // taskController.retrieveBoards();
      return taskController.boards.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, int index) {
                return BoardWidget(
                  board: taskController.boards[index],
                );
              },
              itemCount: taskController.boards.length,
            )
          : SizedBox(
              height: height * 0.01,
              width: width * 0.3,
              child: Image.asset(
                "assets/images/clipboard.png",
                height: height * 0.01,
                width: width * 0.3,
              ));
    });
  }
}
