// ignore_for_file: must_be_immutable

import 'package:finance/constants/colors.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class ButtonWidget extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final String? description;
  IconData? icon;
  double width;
  double height;
  bool? isIcon;

  ButtonWidget(
      {Key? key,
      required this.textColor,
      required this.backgroundColor,
      required this.width,
      required this.height,
      required this.borderColor,
      required this.text,
      this.description,
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
        Text(
          description!,
          style: SafeGoogleFont(
            'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            height: 1.5,
            color: GlobalColors.secondaryColor,
          ),
        )
      ],
    );
  }
}
