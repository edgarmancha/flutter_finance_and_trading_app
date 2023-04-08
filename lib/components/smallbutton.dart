// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../utils.dart';

class SmallButton extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Function? onTap;

  IconData? icon;
  double? width;
  double? height;
  bool? isIcon;

  SmallButton(
      {Key? key,
      required this.textColor,
      required this.backgroundColor,
      this.width,
      this.height,
      required this.borderColor,
      required this.text,
      this.isIcon = false,
      this.icon,
      this.onTap})
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
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
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
