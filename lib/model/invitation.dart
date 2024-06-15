import 'package:cloud_firestore/cloud_firestore.dart';

class Invitation {
  String? invitationId;
  String boardId, boardName, hostName;
  String status;
  bool responded;

  Invitation(
      {required this.boardId,
      required this.boardName,
      required this.hostName,
      required this.status,
      required this.responded});

  factory Invitation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Invitation(
        responded: data?['responded'],
        boardId: data?['boardId'],
        boardName: data?['boardName'],
        hostName: data?['hostName'],
        status: data?['status']);
  }
}
