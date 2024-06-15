import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/model/invitation.dart';
import 'package:todo_list/model/request_response.dart';

class InvitationController extends GetxController {
  AppAuthController appAuthController = Get.find();
  List<Invitation> _invitations = [];
  List<Invitation> get invitations => _invitations;
  int newNotifNumber = 0;
  bool _loaded = false;
  bool get loaded => _loaded;
  Future<void> createInvitation(
      List<String> invitees, String boardName, String boardId) async {
    for (String invitee in invitees) {
      FirebaseFirestore.instance.collection("invitations").add({
        'invitee': invitee,
        'responded': false,
        'boardOwner': FirebaseAuth.instance.currentUser?.email,
        'hostName': appAuthController.currentUser?.lastName,
        'boardId': boardId,
        'boardName': boardName,
        'status': 'pending',
      });
    }
  }

  Future<void> getInvitations() async {
    newNotifNumber = 0;
    _loaded = false;
    _invitations = [];
    final colRef = FirebaseFirestore.instance.collection("invitations");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await colRef
        .where('invitee', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Invitation invitation = Invitation.fromFirestore(doc);
        invitation.invitationId = doc.id;
        _invitations.add(invitation);
        if (!invitation.responded) {
          newNotifNumber += 1;
        }
      }
    }
    _loaded = true;
    update();
  }

  Future<RequestResponse> updateInvitation(
      String documentId, String status) async {
    RequestResponse requestResponse =
        RequestResponse(success: false, message: "");
    try {
      FirebaseFirestore.instance
          .collection("invitations")
          .doc(documentId)
          .update({'status': status, 'responded': true}).then(
              (value) => requestResponse = RequestResponse(
                  success: true,
                  message: "You have successfully joined a new board"),
              onError: (e) => requestResponse = RequestResponse(
                  success: false, message: "An error occur! Try again"));
    } catch (e) {
      requestResponse =
          RequestResponse(success: false, message: "An error occur! Try again");
    }
    return requestResponse;
  }
}
