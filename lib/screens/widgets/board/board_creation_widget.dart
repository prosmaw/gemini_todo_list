import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/model/board.dart';
import 'package:todo_list/screens/widgets/custom_text_field.dart';
import 'package:todo_list/utils/base_colors.dart';

class BoardCreationWidget extends StatefulWidget {
  const BoardCreationWidget({super.key, this.board});
  final Board? board;

  @override
  State<BoardCreationWidget> createState() => _BoardCreationWidgetState();
}

class _BoardCreationWidgetState extends State<BoardCreationWidget> {
  TextEditingController boardNameController = TextEditingController();
  TextEditingController memberController = TextEditingController();
  List<String> invitees = [];
  final _memberformKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  TaskController taskController = Get.find();
  AppAuthController appAuthController = Get.find();
  Color? boardColor;
  bool checking = false;
  int? selectedColorId;
  bool requiredColor = false;
  bool creatingBoard = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (widget.board != null) {
      boardNameController.text = widget.board!.name;
    }
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please Choose a board color",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 65,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    Color selectedColor = selectedColorId == index
                        ? BaseColors.secondaryColor
                        : Colors.grey;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColorId = index;
                          boardColor = taskColors[index];
                        });
                      },
                      child: ColorBox(
                        backgroungColor: taskColors[index],
                        selectedColor: selectedColor,
                      ),
                    );
                  },
                  itemCount: taskColors.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Visibility(
                  visible: requiredColor,
                  child: const Text(
                    "A board color is required",
                    style: TextStyle(color: Colors.red),
                  )),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: boardNameController,
                hint: "Enter board name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "A board name is required";
                  } else {
                    return null;
                  }
                },
                readOnly: checking,
              ),
              Wrap(
                children: List.generate(
                    invitees.length,
                    (index) => Chip(
                          label: Text(
                            invitees[index],
                          ),
                          onDeleted: () {
                            setState(() {
                              invitees.removeAt(index);
                            });
                          },
                          deleteIcon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        )),
              ),
              Form(
                key: _memberformKey,
                child: Row(
                  children: [
                    SizedBox(
                      width: width - 80,
                      child: CustomTextField(
                        controller: memberController,
                        hint: 'Add member email',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.isEmail) {
                            return "Enter a valid email address";
                          } else {
                            return null;
                          }
                        },
                        readOnly: checking,
                      ),
                    ),
                    IconButton(
                        color: Colors.white,
                        onPressed: !checking ? addInvitee : null,
                        icon: !checking
                            ? const Icon(
                                Icons.add,
                              )
                            : const CircularProgressIndicator.adaptive())
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: !checking
                      ? (widget.board == null ? createBoard : updateBoard)
                      : null,
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: BaseColors.secondaryColor),
                  child: !creatingBoard
                      ? Text(
                          widget.board == null
                              ? "Create Board"
                              : "Update Board",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        )
                      : const CircularProgressIndicator()),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  void createBoard() async {
    if (_formKey.currentState!.validate() && (selectedColorId != null)) {
      setState(() {
        checking = true;
        creatingBoard = true;
      });
      Map<String, dynamic> color = {
        "a": boardColor?.alpha,
        'r': boardColor?.red,
        'g': boardColor?.green,
        'b': boardColor?.blue
      };
      Board board = Board(
          members: [appAuthController.currentUser!.email],
          name: boardNameController.text,
          creatorEmail: appAuthController.currentUser!.email,
          color: color);
      await taskController.addBoard(board, invitees);
      Get.back();
    } else if (selectedColorId == null && widget.board == null) {
      setState(() {
        requiredColor = true;
      });
    }
  }

  void updateBoard() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> color = (boardColor != null)
          ? {
              "a": boardColor?.alpha,
              'r': boardColor?.red,
              'g': boardColor?.green,
              'b': boardColor?.blue
            }
          : widget.board!.color;
      Board board = Board(
          members: widget.board!.members,
          name: boardNameController.text,
          creatorEmail: widget.board!.creatorEmail,
          color: color);
      await taskController.updateBoard(
          widget.board!.boardDocId.toString(), board, invitees);
      Get.back();
    }
  }

  void addInvitee() async {
    if (_memberformKey.currentState!.validate()) {
      setState(() {
        checking = true;
      });
      bool emailExist =
          await appAuthController.checkEmail(memberController.text);
      if (emailExist == true) {
        setState(() {
          invitees.add(memberController.text);
          memberController.clear();
          checking = false;
        });
      } else {
        setState(() {
          checking = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email address does not exist")));
      }
    }
  }
}

class ColorBox extends StatelessWidget {
  const ColorBox(
      {super.key, required this.backgroungColor, required this.selectedColor});
  final Color backgroungColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: selectedColor)),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: backgroungColor,
      ),
    );
  }
}
