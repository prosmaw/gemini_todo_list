import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/controllers/invitation_controller.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/model/invitation.dart';
import 'package:todo_list/screens/pages/home_screen.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});
  final InvitationController invitationController = Get.find();
  final TaskController taskController = Get.find();
  final AppAuthController appAuthController = Get.find();

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    invitationController.getInvitations();
    return GetBuilder<InvitationController>(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Get.to(() => const HomeScreen());
              },
            ),
            title: const Text(
              "Notifications",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: !invitationController.loaded
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : invitationController.invitations.isNotEmpty
                  ? ListView.builder(
                      itemCount: invitationController.invitations.length,
                      itemBuilder: (context, index) {
                        Invitation invitation =
                            invitationController.invitations[index];
                        return InvitationWidget(
                            invitation: invitation,
                            onAccept: () {
                              invitationController.updateInvitation(
                                  invitation.invitationId ?? '', "Accepted");
                              taskController.updateBoardMembers(
                                  invitation.boardId,
                                  appAuthController.currentUser!.email);
                              invitationController.getInvitations();
                            },
                            onDecline: () {
                              invitationController.updateInvitation(
                                  invitation.invitationId ?? '', "Declined");
                              invitationController.getInvitations();
                            });
                      })
                  : const Center(
                      child: Text(
                        "No notification available",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ));
    });
  }
}

class InvitationWidget extends StatelessWidget {
  const InvitationWidget(
      {super.key,
      required this.invitation,
      required this.onAccept,
      required this.onDecline});
  final Invitation invitation;
  final Function() onAccept;
  final Function() onDecline;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      title: const Text(
        "New invitation",
        style: TextStyle(color: Colors.white),
      ),
      subtitle:
          Text("You have been invited to the board ${invitation.boardName}"),
      shape: const Border(bottom: BorderSide(color: Colors.grey)),
      trailing: Visibility(
        visible: !invitation.responded,
        child: SizedBox(
          width: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onAccept,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.check),
                ),
              ),
              GestureDetector(
                onTap: onDecline,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
