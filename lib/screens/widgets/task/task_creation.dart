import 'package:flutter/material.dart';
import 'package:todo_list/utils/base_colors.dart';

class TaskCreation extends StatelessWidget {
  const TaskCreation({super.key, required this.width, required this.onPressed});

  final double width;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
          fixedSize: WidgetStatePropertyAll<Size>(Size(width - 30, 80)),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
          backgroundColor: const WidgetStatePropertyAll<Color>(
            BaseColors.primaryColor,
          )),
      child: const Center(
        child: Text(
          "Create",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
