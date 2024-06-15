import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/pages/sign_in_page.dart';
import 'package:todo_list/screens/pages/sign_up_page.dart';

class RegisterOption extends StatelessWidget {
  final String text1;
  final String text2;
  final bool hasAccount;
  const RegisterOption({
    super.key,
    required this.text1,
    required this.text2,
    required this.hasAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text1,
          style: const TextStyle(color: Colors.grey),
        ),
        InkWell(
          onTap: () {
            hasAccount
                ? Get.to(() => const SignInPage())
                : Get.to(() => const SignUpPage());
          },
          child: Text(
            text2,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
