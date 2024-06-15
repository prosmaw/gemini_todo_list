import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/controllers/invitation_controller.dart';
import 'package:todo_list/utils/app_routes.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    debugPrint("Handling a background message: ${message.messageId}");
  }
}

ThemeData _defaultTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 17, 28, 47),
    scaffoldBackgroundColor: const Color.fromARGB(255, 17, 28, 47),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 17, 28, 47),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AppAuthController());
    Get.put(InvitationController());
    AppAuthController appAuthController = Get.find();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: _defaultTheme,
      initialRoute:
          appAuthController.islogging ? Routes.home : Routes.signInPage,
      getPages: getPages,
    );
  }
}
