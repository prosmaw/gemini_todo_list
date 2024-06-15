import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputArea extends StatefulWidget {
  final String inputName;

  final TextEditingController controller;
  final String hinttext;
  final bool ispassword;
  final bool isEmail;
  // final String? Function(String?) validator;
  const InputArea({
    super.key,
    required this.inputName,
    required this.controller,
    required this.hinttext,
    required this.isEmail,
    // required this.validator,
    required this.ispassword,
  });

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.inputName,
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (value) {
            String? response;
            if (widget.isEmail) {
              response = emailValidator(value);
            } else {
              response = otherInputValidator(value, widget.inputName);
            }
            return response;
          },
          controller: widget.controller,
          keyboardType: widget.ispassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          obscureText: widget.ispassword ? (isVisible ? false : true) : false,
          decoration: InputDecoration(
              suffixIcon: widget.ispassword
                  ? (isVisible
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = false;
                            });
                          },
                          icon: const Icon(Icons.visibility_off))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = true;
                            });
                          },
                          icon: const Icon(Icons.visibility)))
                  : null,
              filled: true,
              //border: InputBorder.none,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 88, 88, 88),
                  )),
              hintText: widget.hinttext,
              hintStyle: const TextStyle(
                color: Colors.grey,
              )),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty || !value.isEmail) {
      return "Enter a valid email address";
    } else {
      return null;
    }
  }

  String? otherInputValidator(String? value, String inputName) {
    if (value == null || value.isEmpty) {
      return "A $inputName is required";
    } else {
      return null;
    }
  }
}
