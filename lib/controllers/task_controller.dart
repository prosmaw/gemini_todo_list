import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/controllers/invitation_controller.dart';
import 'package:todo_list/model/board.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/model/user_model.dart';

class TaskController extends GetxController {
  var dayTasks = List.generate(7, (_) => <Task>[]).obs;
  List<Task> _tasksDone = [];
  List<Board> _boards = [];
  List<Task> _activeTasks = [];
  List<UserModel> currentTaskAssignees = [];
  UserModel? currentTaskCreator;
  int rateDone = 0;
  var isloaded = false.obs;
  AppAuthController appAuthController = Get.find();
  InvitationController invitationController = Get.find();
  List<Task> get activeTasks => _activeTasks;
  List<Task> get tasksDone => _tasksDone;
  List<Board> get boards => _boards;

  @override
  void onInit() async {
    super.onInit();
    await retrieveBoards();
    if (_boards.isNotEmpty) {
      await retrieveTasks();
      await retrieveDayTasks();
    }
  }

  void updateTasks() async {
    await retrieveTasks();
    await retrieveDayTasks();
    update();
  }

  Future<void> updateBoards() async {
    await retrieveBoards();
    if (_boards.isNotEmpty) {
      await retrieveTasks();
      await retrieveDayTasks();
    }
    update();
  }

  void getDoneRate() {
    if (tasksDone.isNotEmpty) {
      rateDone =
          ((tasksDone.length * 100) / (tasksDone.length + activeTasks.length))
              .floor();
    } else {
      rateDone = 0;
    }
    //update();
  }

  Future<void> addtask(Task task) async {
    if (!appAuthController.islogging) {
      throw Exception();
    }
    await FirebaseFirestore.instance
        .collection('tasks')
        .add(task.toFirestore());
  }

  Future<void> updateTask(String taskId, Task task) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update(task.toFirestore());
    updateTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    updateTasks();
  }

  Future<void> updateTaskState(String taskId, bool state) async {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({"active": state});
    updateTasks();
  }

  Future<void> retrieveDayTasks() async {
    isloaded.value = false;
    update();
    if (_activeTasks.isNotEmpty) {
      for (int i = 0; i < dayTasks.length; i++) {
        dayTasks[i] = [];
        for (Task task in _activeTasks) {
          if (task.dueDate.weekday == i + 1) {
            dayTasks[i].add(task);
          }
        }
      }
    }
    getDoneRate();
    isloaded.value = true;
    update();
  }

  Future<void> retrieveTasks() async {
    if (appAuthController.islogging) {
      _activeTasks = [];
      _tasksDone = [];
      for (Board board in _boards) {
        board.activeTasks = 0;
        final colRef = FirebaseFirestore.instance.collection('tasks');
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await colRef.where('boardId', isEqualTo: board.boardDocId).get();
        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            Task task = Task.fromFirestore(doc);
            task.taskId = doc.id;
            task.taskColor = board.color;
            if (task.active) {
              board.activeTasks += 1;
              _activeTasks.add(task);
            } else {
              _tasksDone.add(task);
            }
            board.boardTasks.add(task);
          }
        }
      }
    }
  }

  //board
  Future<void> addBoard(Board board, List<String> invitees) async {
    if (!appAuthController.islogging) {
      throw Exception();
    }
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('boards')
        .add(board.toFirestore());
    if (invitees.isNotEmpty) {
      await invitationController.createInvitation(
          invitees, board.name, docRef.id);
    }
    updateBoards();
  }

  Future<void> retrieveBoards() async {
    if (appAuthController.islogging) {
      final colRef = FirebaseFirestore.instance.collection('boards');
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await colRef
          .where('members',
              arrayContains: FirebaseAuth.instance.currentUser!.email)
          .get();
      _boards = [];
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Board board = Board.fromFirestore(doc);
          _boards.add(board);
        }
      }
    }
  }

  Future<void> updateBoard(
      String boardId, Board board, List<String> invitees) async {
    FirebaseFirestore.instance
        .collection('boards')
        .doc(boardId)
        .update(board.toFirestore());
    if (invitees.isNotEmpty) {
      await invitationController.createInvitation(
          invitees, board.name, boardId);
    }
    updateBoards();
  }

  Board? getBoard(String name) {
    Board? returnBoard;
    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].name == name) {
        returnBoard = _boards[i];
      } else {
        returnBoard = null;
      }
    }
    return returnBoard;
  }

  Future<void> updateBoardMembers(String boardId, String newMember) async {
    FirebaseFirestore.instance.collection('boards').doc(boardId).update({
      'members': FieldValue.arrayUnion([newMember])
    });
  }

  Future<void> deleteBoard(String boardId) async {
    isloaded.value = true;
    for (int i = 0; i < tasksDone.length; i++) {
      if (tasksDone[i].boardid == boardId) {
        FirebaseFirestore.instance
            .collection("tasks")
            .doc(tasksDone[i].taskId)
            .delete();
      }
    }
    for (int i = 0; i < activeTasks.length; i++) {
      if (activeTasks[i].boardid == boardId) {
        FirebaseFirestore.instance
            .collection("tasks")
            .doc(activeTasks[i].taskId)
            .delete();
      }
    }
    FirebaseFirestore.instance.collection('boards').doc(boardId).delete();
    updateBoards();
    updateTasks();
    isloaded.value = true;
  }

  Future<void> getUsersNames(List<String> emails) async {
    currentTaskAssignees = [];
    for (int i = 0; i < emails.length; i++) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: emails[i])
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        UserModel user = UserModel.fromFirestore(querySnapshot.docs.single);
        currentTaskAssignees.add(user);
      }
    }
    update();
  }

  Future<void> getAUser(String email) async {
    currentTaskCreator = null;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      UserModel user = UserModel.fromFirestore(querySnapshot.docs.single);
      currentTaskCreator = user;
    }
    update();
  }
}
