import 'package:todo_list/model/board.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/screens/pages/boad_details.dart';
import 'package:todo_list/screens/pages/home_screen.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/pages/insight_page.dart';
import 'package:todo_list/screens/pages/new_task_page.dart';
import 'package:todo_list/screens/pages/notification_page.dart';
import 'package:todo_list/screens/pages/sign_up_page.dart';
import 'package:todo_list/screens/pages/task_details.dart';

import '../screens/pages/sign_in_page.dart';

class Routes {
  //static String authGate = "/";
  static String signInPage = "/";
  static String signUpPage = "/signup";
  static String home = "/home";
  static String taskDetails = "/taskDetails";
  static String newTaskPage = "/newTaskPage";
  static String notifPage = "/notifPage";
  static String insightPage = "/insightPage";
  static String boardDetails = "/boardDetails";
}

final getPages = [
  //GetPage(name: Routes.authGate, page: () => const AuthGate()),
  GetPage(name: Routes.signInPage, page: () => const SignInPage()),
  GetPage(name: Routes.signUpPage, page: () => const SignUpPage()),
  GetPage(name: Routes.home, page: () => const HomeScreen()),
  GetPage(
      name: Routes.taskDetails,
      page: () => const Taskdetails(),
      arguments: Task),
  GetPage(name: Routes.newTaskPage, page: () => const NewTask()),
  GetPage(name: Routes.notifPage, page: () => NotificationPage()),
  GetPage(name: Routes.insightPage, page: () => const InsightPage()),
  GetPage(
      name: Routes.boardDetails, page: () => BoardDetails(), arguments: Board)
];
