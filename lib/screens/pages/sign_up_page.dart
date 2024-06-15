import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/screens/pages/home_screen.dart';
import 'package:todo_list/utils/base_colors.dart';
import '../widgets/custom_divider.dart';
import '../widgets/custom_sign_in_button.dart';
import '../widgets/log_input_area.dart';
import '../widgets/registration_option.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();

  final passConfirmationController = TextEditingController();
  AppAuthController authController = Get.find();
  final _formKey = GlobalKey<FormState>();

  bool errorLogup = false;

  bool isSame = true;

  signUpUser(AppAuthController authController) async {
    Map<String, dynamic> parameters = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };
    if (passConfirmationController.text != passwordController.text) {
      setState(() {
        isSame = false;
      });
    } else {
      await authController.signUpUser(parameters);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<AppAuthController>(builder: (_) {
      return Scaffold(
        extendBody: true,
        backgroundColor: BaseColors.primaryColor,
        appBar: AppBar(
          backgroundColor: BaseColors.primaryColor,
          title: const Text(
            "Sign up",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            //margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            height: height,
            width: width,
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //firstname textfield
                    InputArea(
                      inputName: 'First Name',
                      controller: firstNameController,
                      hinttext: 'First name',
                      ispassword: false,
                      isEmail: false,
                    ),
                    //lastname textfield
                    InputArea(
                      inputName: 'Last Name',
                      controller: lastNameController,
                      hinttext: 'Last Name',
                      ispassword: false,
                      isEmail: false,
                    ),
                    //email input
                    InputArea(
                      inputName: 'E-mail',
                      controller: emailController,
                      hinttext: 'example@gmail.com',
                      ispassword: false,
                      isEmail: true,
                    ),

                    //password input zone
                    InputArea(
                      inputName: 'Password',
                      controller: passwordController,
                      hinttext: 'Password',
                      ispassword: true,
                      isEmail: false,
                    ),
                    InputArea(
                      inputName: 'Confirm password',
                      controller: passConfirmationController,
                      hinttext: 'Confirm password',
                      ispassword: true,
                      isEmail: false,
                    ),
                    isSame
                        ? const SizedBox()
                        : const Text(
                            "Confirmation password incorrect",
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    errorLogup
                        ? const Text(
                            "Email or password incorrect",
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          )
                        : const SizedBox(),
                    //Sign in button
                    CustomSignInButton(
                      buttonColor: BaseColors.secondaryColor,
                      hasIcon: false,
                      icon: '',
                      textButton: 'Sign Up',
                      isLoading: authController.isLoading.value,
                      onclick: () async {
                        if (_formKey.currentState!.validate()) {
                          await signUpUser(authController);
                          if (authController.islogging) {
                            Get.off(const HomeScreen());
                          } else {
                            setState(() {
                              errorLogup = true;
                            });
                          }
                        }
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    const CustomDivider(),
                    const SizedBox(
                      height: 20,
                    ),
                    //Google sing up button
                    const CustomSignInButton(
                      buttonColor: Colors.white,
                      hasIcon: true,
                      icon: 'assets/icons/google_logo.svg',
                      textButton: 'Sign in with Google',
                      isLoading: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const RegisterOption(
                      text1: 'Already have an account?',
                      text2: ' Sign in',
                      hasAccount: true,
                    )
                  ]),
            ),
          ),
        ),
      );
    });
  }
}
