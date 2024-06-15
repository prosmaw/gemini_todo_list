import 'package:flutter/material.dart';
import 'package:todo_list/utils/base_colors.dart';

class Themes {
  Theme dateTimeTheme(BuildContext context, Widget? child) {
    return Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              surface: BaseColors.primaryColor,
              primary: BaseColors.secondaryColor,
            ),
            textTheme:
                const TextTheme(titleSmall: TextStyle(color: Colors.white)),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: BaseColors.secondaryColor))),
        child: child!);
  }
}
