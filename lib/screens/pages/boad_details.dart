import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/model/board.dart';
import 'package:todo_list/screens/widgets/task/task_widget.dart';

class BoardDetails extends StatelessWidget {
  BoardDetails({super.key});
  final Board board = Get.arguments as Board;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "${board.name} Board",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: board.boardTasks.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 20),
                child: ListView.builder(
                  itemBuilder: (context, index) => TaskWidget(
                      width: width,
                      height: height,
                      task: board.boardTasks[index],
                      done: board.boardTasks[index].active),
                  itemCount: board.boardTasks.length,
                ),
              )
            : Column(
                //case task list is empty
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: (width) / 3,
                      width: (width) / 3,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image:
                                  AssetImage("assets/images/clipboard.png"))),
                    ),
                  ),
                  const Text(
                    "No Task avalaible",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ));
  }
}
