// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../utils.dart';

class HelpButton extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  IconData? icon;
  double? width;
  double height;
  bool? isIcon;

  HelpButton(
      {Key? key,
      required this.textColor,
      required this.backgroundColor,
      this.width,
      required this.height,
      required this.borderColor,
      required this.text,
      this.isIcon = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Center(
            child: (isIcon == false
                ? Text(
                    text,
                    style: SafeGoogleFont(
                      'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                      color: const Color(0xffffffff),
                    ),
                  )
                : Icon(
                    icon,
                    color: textColor,
                    size: 20,
                  )),
          ),
        ),
        const SizedBox(height: 3),
      ],
    );
  }
}
