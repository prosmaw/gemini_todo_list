import 'package:flutter/material.dart';

class BackgroundClip extends CustomClipper<Path> {
  double screenHeight;
  BackgroundClip({required this.screenHeight});

  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double radius = width;
    if (height >= screenHeight) {
      radius = height;
    }
    Path path = Path();
    path.arcTo(Rect.fromCircle(center: Offset(0, height / 2), radius: radius),
        -3.14 / 2, 3.14, false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
