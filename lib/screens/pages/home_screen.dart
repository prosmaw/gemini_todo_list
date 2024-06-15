import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/controllers/gemini_controller.dart';
import 'package:todo_list/controllers/invitation_controller.dart';
import 'package:todo_list/controllers/notification_controller.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/screens/pages/new_task_page.dart';
import 'package:todo_list/screens/widgets/board/board_creation_widget.dart';
import 'package:todo_list/screens/widgets/board/board_tab.dart';
import 'package:todo_list/screens/widgets/custom_tab.dart';
import 'package:todo_list/screens/widgets/date_done_row.dart';
import 'package:todo_list/screens/widgets/gen_input_widget.dart';
import 'package:todo_list/screens/widgets/task/task_tab.dart';
import 'package:todo_list/utils/app_routes.dart';
import 'package:todo_list/utils/base_colors.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  NotificationController notifController = NotificationController();
  final String datePresent = DateFormat.yMMMMd().format(DateTime.now());
  final String presentDay = DateFormat('EEEE', 'en_US').format(DateTime.now());
  late final TabController tabController =
      TabController(length: 2, vsync: this);
  bool taskSelected = true;
  bool boardSelected = false;
  AppAuthController appAuthController = Get.find();
  TaskController taskController = Get.put(TaskController());
  GeminiControler geminiControler = Get.put(GeminiControler());
  InvitationController invitationController = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String greeting = '';
  Color? profileBgColor;

  @override
  void initState() {
    super.initState();
    profileBgColor =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    appAuthController.getUserInfo();
    notifController.requestPermission();
    notifController.manageForegroundNotif();
    notifController.setupInteractedMessage();
    invitationController.getInvitations();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final time = TimeOfDay.now();

    return GetBuilder<TaskController>(builder: (_) {
      return GetBuilder<InvitationController>(builder: (_) {
        return GetBuilder<GeminiControler>(builder: (_) {
          if (appAuthController.currentUser != null) {
            if (time.period == DayPeriod.am) {
              greeting = "Good Morning";
            } else if (time.period == DayPeriod.pm) {
              greeting = "Hello ${appAuthController.currentUser!.firstName}";
            }
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              toolbarHeight: 80,
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              leading: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: profileBgColor,
                    child: appAuthController.currentUser != null
                        ? Text(
                            appAuthController
                                .currentUser!.email.characters.first,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : const SizedBox(),
                  )),
              actions: <Widget>[
                Badge(
                  label: invitationController.newNotifNumber != 0
                      ? Text(' ${invitationController.newNotifNumber} ')
                      : null,
                  isLabelVisible: invitationController.invitations.isNotEmpty,
                  offset: const Offset(10, 15),
                  alignment: Alignment.bottomLeft,
                  smallSize: 24,
                  largeSize: 24,
                  textStyle: const TextStyle(fontSize: 16),
                  backgroundColor: BaseColors.secondaryColor,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(255, 23, 39, 65),
                    child: IconButton(
                        onPressed: () {
                          Get.toNamed(Routes.notifPage);
                        },
                        icon: const Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.white,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color.fromARGB(255, 23, 39, 65),
                  child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: BaseColors.primaryColor,
                            showDragHandle: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return GenInputWidget(
                                sendingRequest: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                              BaseColors.primaryColor,
                                          duration: const Duration(seconds: 5),
                                          content: Text(
                                            geminiControler.message.value,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )));
                                },
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              //color: Colors.white,
              onRefresh: () async {
                await taskController.updateBoards();
              },
              child: SingleChildScrollView(
                child: Container(
                  height: height,
                  margin: const EdgeInsets.only(top: 60),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(greeting,
                          style: const TextStyle(
                              height: 1,
                              color: BaseColors.secondaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 70)),
                      const SizedBox(
                        height: 30,
                      ),
                      //Date and done percentage
                      DateDoneRow(
                          jourPresent: presentDay, datePresent: datePresent),
                      const SizedBox(
                        height: 30,
                      ),
                      //TabBar
                      TabBar(
                        controller: tabController,
                        indicatorColor: Colors.white,
                        indicatorWeight: 2,
                        dividerHeight: 2,
                        dividerColor: const Color.fromARGB(255, 143, 157, 177),
                        padding: const EdgeInsets.only(bottom: 20),
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (value) {
                          if (value == 0) {
                            setState(() {
                              taskSelected = true;
                              boardSelected = false;
                            });
                          } else if (value == 1) {
                            setState(() {
                              taskSelected = false;
                              boardSelected = true;
                            });
                          }
                        },
                        tabs: [
                          Tab(
                            height: 60,
                            child: Customtab(
                              number: taskController.activeTasks.length,
                              tabName: 'Tasks',
                              width: width,
                              isSelected: taskSelected,
                            ),
                          ),
                          Tab(
                              height: 60,
                              child: Customtab(
                                number: taskController.boards.length,
                                tabName: 'Boards',
                                width: width,
                                isSelected: boardSelected,
                              ))
                        ],
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: tabController,
                        children: [const TaskTab(), BoardTab()],
                      ))
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: GestureDetector(
              onTap: () {
                if (taskSelected) {
                  Get.to(
                    () => const NewTask(),
                    transition: Transition.downToUp,
                  );
                } else if (boardSelected) {
                  showModalBottomSheet(
                      backgroundColor: BaseColors.primaryColor,
                      showDragHandle: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return const BoardCreationWidget();
                      });
                }
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                    color: BaseColors.secondaryColor, shape: BoxShape.circle),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        });
      });
    });
  }
}
