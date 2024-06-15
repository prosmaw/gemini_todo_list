import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String name;
  Map<String, dynamic>? taskColor;
  String? taskId;
  DateTime dueDate;
  String boardName, creator;
  bool active;
  String description;
  DateTime dateCreated;
  String boardid;
  List<String> assignees;

  Task(
      {required this.boardid,
      required this.name,
      required this.dueDate,
      required this.creator,
      required this.boardName,
      required this.description,
      required this.active,
      required this.assignees,
      required this.dateCreated});

  String getDueTime(DateTime due) {
    final difference = due.difference(DateTime.now());
    if (!difference.isNegative) {
      if (difference.inDays > 0) {
        return "${difference.inDays}d";
      } else {
        int hours = difference.inHours;
        int minutes = difference.inMinutes.remainder(60);
        return "${hours}h ${minutes}m";
      }
    } else {
      if (difference.inDays.abs() > 0) {
        return "Late ${difference.inDays.abs()}d";
      } else {
        int hours = difference.inHours.abs();
        int minutes = difference.inMinutes.remainder(60).abs();
        return "Late ${hours}h ${minutes}m";
      }
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      "boardId": boardid,
      "boardName": boardName,
      "name": name,
      "dueDate": dueDate,
      "active": active,
      "assignees": assignees,
      'description': description,
      'creator': creator,
      'dateCreated': FieldValue.serverTimestamp()
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "boardName": boardName,
      "name": name,
      "dueDate": dueDate,
      "active": active,
      'description': description,
      'dateCreated': dateCreated
    };
  }

  factory Task.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    Timestamp dateCreated = data?['dateCreated'];
    Timestamp due = data?['dueDate'];
    return Task(
        name: data?['name'],
        dueDate: due.toDate(),
        active: data?['active'],
        boardid: data?['boardId'],
        boardName: data?['boardName'],
        description: data?['description'],
        dateCreated: dateCreated.toDate(),
        creator: data?['creator'],
        assignees: List.from(data?['assignees']));
  }
}
