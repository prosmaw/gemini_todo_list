import 'package:flutter/material.dart';
import 'package:todo_list/utils/base_colors.dart';

class Customtab extends StatelessWidget {
  const Customtab({
    super.key,
    required this.number,
    required this.tabName,
    required this.width,
    required this.isSelected,
  });

  final int number;
  final String tabName;
  final double width;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Container(
        //   height: 24,
        //   width: 24,
        //   decoration: BoxDecoration(
        //       color: isSelected ? Colors.white : Colors.transparent,
        //       border: Border.all(
        //         color: isSelected
        //             ? Colors.white
        //             : const Color.fromARGB(255, 143, 157, 177),
        //       ),
        //       shape: BoxShape.circle),
        //   child: Text(
        //     number.toString(),
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: isSelected
        //           ? BaseColors.primaryColor
        //           : const Color.fromARGB(255, 143, 157, 177),
        //       fontSize: 16,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        //use of badge to make the container grow in width
        //when the the digit increases
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : const Color.fromARGB(255, 143, 157, 177),
            ),
          ),
          child: Badge(
            label: Text(
              ' $number ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            largeSize: 24,
            // textStyle:
            //     const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textColor: isSelected
                ? BaseColors.primaryColor
                : const Color.fromARGB(255, 143, 157, 177),
            backgroundColor: isSelected ? Colors.white : Colors.transparent,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          tabName,
          style: TextStyle(
            fontSize: 28,
            color: isSelected
                ? const Color.fromARGB(255, 114, 144, 213)
                : const Color.fromARGB(255, 143, 157, 177),
          ),
        )
      ],
    );
  }
}
