import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.validator,
    required this.readOnly,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
        validator: validator,
        maxLines: null,
        minLines: 1,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }
}
