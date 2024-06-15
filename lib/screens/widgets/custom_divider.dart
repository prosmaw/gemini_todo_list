import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
            child: Divider(
          color: Colors.grey,
          thickness: 1,
        )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "Or",
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        Expanded(
            child: Divider(
          color: Colors.grey,
          thickness: 1,
        )),
      ],
    );
  }
}
