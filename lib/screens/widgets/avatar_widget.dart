import 'package:flutter/material.dart';
import 'package:todo_list/utils/base_colors.dart';
import 'dart:math' as math;
import 'package:flutter_svg/svg.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget(
      {super.key,
      required this.leftPosition,
      required this.image,
      required this.isMore,
      required this.firstLetter,
      required this.remain});
  final double leftPosition;
  final String image, firstLetter;
  final bool isMore;
  final String remain;

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  Color? bgColor;
  @override
  void initState() {
    super.initState();
    bgColor =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.leftPosition,
      child: CircleAvatar(
        backgroundColor: widget.isMore ? BaseColors.primaryColor : bgColor,
        radius: 28,
        child: widget.isMore
            ? Text(
                widget.remain,
                style: const TextStyle(color: Colors.white),
              )
            : widget.image.isEmpty
                ? Text(
                    widget.firstLetter,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : SvgPicture.asset(widget.image),
      ),
    );
  }
}
