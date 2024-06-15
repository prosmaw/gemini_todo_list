import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/screens/pages/home_screen.dart';
import 'package:todo_list/utils/base_colors.dart';
import '../widgets/custom_divider.dart';
import '../widgets/custom_sign_in_button.dart';
import '../widgets/log_input_area.dart';
import '../widgets/registration_option.dart';

//simple sign in page, no exceptions or error management
class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SingInState();
}

class _SingInState extends State<SignInPage> {
  // text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  AppAuthController appAuthController = Get.find();
  final _formKey = GlobalKey<FormState>();
  bool errorLogin = false;

  @override
  Widget build(BuildContext context) {
    //String authMessage = "";
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      backgroundColor: BaseColors.primaryColor,
      body: GetBuilder<AppAuthController>(builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 40),
              height: height,
              width: width,
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //email input
                      InputArea(
                        inputName: 'Email address',
                        controller: emailController,
                        hinttext: 'example@gmail.com',
                        ispassword: false,
                        isEmail: true,
                      ),
                      //password input
                      InputArea(
                        inputName: 'Password',
                        controller: passwordController,
                        hinttext: 'password',
                        ispassword: true,
                        isEmail: false,
                      ),
                      errorLogin
                          ? const Text(
                              "Email or password incorrect",
                              style: TextStyle(color: Colors.red, fontSize: 17),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 30,
                      ),
                      //Sign in button
                      CustomSignInButton(
                        buttonColor: BaseColors.secondaryColor,
                        hasIcon: false,
                        icon: '',
                        textButton: 'Login',
                        isLoading: appAuthController.isLoading.value,
                        onclick:
                            !appAuthController.isLoading.value ? login : null,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      const CustomDivider(),
                      const SizedBox(
                        height: 20,
                      ),
                      //Google signin button
                      const CustomSignInButton(
                        buttonColor: Colors.white,
                        hasIcon: true,
                        icon: 'assets/icons/google_logo.svg',
                        textButton: 'Login with Google',
                        isLoading: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const RegisterOption(
                        text1: 'No account?',
                        text2: " Signup",
                        hasAccount: false,
                      )
                    ]),
              ),
            ),
          ),
        );
      }),
    );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      await appAuthController.loginUser(
          emailController.text, passwordController.text);
      if (appAuthController.islogging) {
        Get.off(() => const HomeScreen());
      } else {
        setState(() {
          errorLogin = true;
        });
      }
    }
  }
}
