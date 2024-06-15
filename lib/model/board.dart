import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/model/task.dart';

class Board {
  String? boardDocId;
  String name;
  String creatorEmail;
  List<String> members;
  int activeTasks = 0;
  List<Task> boardTasks = [];
  Map<String, dynamic> color = {"a": 0, 'r': 0, 'g': 0, 'b': 0};
  Board({
    this.boardDocId,
    required this.members,
    required this.name,
    required this.creatorEmail,
    required this.color,
  });

  factory Board.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    //assign data to a new board object
    Board board = Board(
      boardDocId: snapshot.id,
      members: List.from(data?['members']),
      name: data?['name'],
      creatorEmail: data?['creatorEmail'],
      color: data?['color'],
    );
    //add tasks to board if exist
    // if (data!.containsKey('tasks')) {
    //   for (var task in data['tasks']) {
    //     Timestamp dateCreated = task['dateCreated'];
    //     Timestamp due = task['dueDate'];
    //     if (task['active'] == true) {
    //       board.activeTasks += 1;
    //     }
    //     tasks.add(Task(
    //         name: task['name'],
    //         taskColor: data['color'] as Map<String, int>,
    //         dueDate: due.toDate(),
    //         active: task['active'],
    //         boardName: data['name'],
    //         description: task['description'],
    //         dateCreated: dateCreated.toDate()));
    //   }
    //   board.boardTasks = tasks;
    // }
    return board;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'color': color,
      'creatorEmail': creatorEmail,
      'members': [creatorEmail]
    };
  }
}
