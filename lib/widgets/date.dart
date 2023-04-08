// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../utils.dart';

class DateWidget extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final String text;

  IconData? icon;
  double? width;
  double? height;
  bool? isIcon;

  DateWidget(
      {Key? key,
      required this.textColor,
      required this.backgroundColor,
      this.width,
      this.height,
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
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: (isIcon == false
                ? Text(
                    text,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: const Color(0xffffffff),
                    ),
                  )
                : Icon(
                    icon,
                    color: textColor,
                    size: 12,
                  )),
          ),
        ),
        const SizedBox(height: 3),
      ],
    );
  }
}
