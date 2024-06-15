import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/model/board.dart';
import 'package:todo_list/screens/pages/boad_details.dart';
import 'package:todo_list/screens/widgets/avatar_widget.dart';
import 'package:todo_list/screens/widgets/board/board_creation_widget.dart';
import 'package:todo_list/utils/base_colors.dart';

enum Options { delete, edit }

class BoardWidget extends StatelessWidget {
  BoardWidget({super.key, required this.board});
  final Board board;
  final TaskController taskController = Get.find();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int membersLength = board.members.length >= 4 ? 4 : board.members.length;
    int remain = board.members.length - membersLength;
    return GestureDetector(
      onTap: () {
        Get.to(() => BoardDetails(), arguments: board);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 10),
        width: width - 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color.fromARGB(board.color['a'], board.color['r'],
                board.color['g'], board.color['b'])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent.withOpacity(0.1),
                      radius: 28,
                      child: const Icon(
                        Icons.add,
                        weight: 600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 216,
                      height: 56,
                      child: Stack(
                          children: List.generate(membersLength, (index) {
                        double leftPosition = index * 40;
                        bool isMore = index == 3 ? true : false;
                        return AvatarWidget(
                          leftPosition: leftPosition,
                          image: "",
                          isMore: isMore,
                          firstLetter: board.members[index].characters.first
                              .toUpperCase(),
                          remain: '$remain',
                        );
                      })),
                    ),
                  ],
                ),
                PopupMenuButton<Options>(
                  itemBuilder: (context) => <PopupMenuEntry<Options>>[
                    PopupMenuItem<Options>(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: BaseColors.primaryColor,
                              showDragHandle: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return BoardCreationWidget(
                                  board: board,
                                );
                              });
                        },
                        value: Options.edit,
                        child: const ListTile(
                          title: Text("Edit"),
                          leading: Icon(Icons.edit),
                        )),
                    PopupMenuItem<Options>(
                        onTap: () {
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    content: SingleChildScrollView(
                                      child: Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    ),
                                  ));
                          taskController
                              .deleteBoard(board.boardDocId.toString());
                          Get.back();
                        },
                        value: Options.delete,
                        child: const ListTile(
                          title: Text("Delete"),
                          leading: Icon(Icons.delete),
                        )),
                  ],
                  icon: const Icon(
                    Icons.more_horiz,
                    weight: 600,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${board.activeTasks} Active Tasks",
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              board.name,
              style: const TextStyle(color: Colors.black, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
