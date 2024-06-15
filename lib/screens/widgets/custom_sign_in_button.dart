import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSignInButton extends StatefulWidget {
  final String textButton;
  final String icon;
  final Color buttonColor;
  final bool hasIcon;
  final bool isLoading;
  final Function()? onclick;
  const CustomSignInButton({
    super.key,
    required this.textButton,
    required this.icon,
    required this.buttonColor,
    required this.hasIcon,
    this.onclick,
    required this.isLoading,
  });

  @override
  State<CustomSignInButton> createState() => _CustomSignInButtonState();
}

class _CustomSignInButtonState extends State<CustomSignInButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: widget.buttonColor),
      child: ElevatedButton(
          onPressed: widget.onclick,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.buttonColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.hasIcon
                  ? SvgPicture.asset(
                      widget.icon,
                      height: 30,
                    )
                  : const SizedBox(),
              const SizedBox(
                width: 10,
              ),
              Text(widget.textButton,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: !widget.hasIcon ? Colors.white : Colors.grey)),
              widget.isLoading
                  ? Expanded(
                      child: Container(
                          color: Colors.transparent,
                          child: const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))),
                    )
                  : const SizedBox()
            ],
          )),
    );
  }
}
