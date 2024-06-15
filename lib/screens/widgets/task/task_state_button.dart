import 'package:flutter/material.dart';

import 'package:todo_list/utils/base_colors.dart';

class TaskStateButton extends StatelessWidget {
  const TaskStateButton({
    super.key,
    required this.name,
    required this.isSelected,
  });
  final String name;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color:
                  isSelected ? Colors.transparent : BaseColors.secondaryColor),
          color: isSelected ? BaseColors.secondaryColor : Colors.transparent),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
              color: isSelected ? BaseColors.primaryColor : Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
