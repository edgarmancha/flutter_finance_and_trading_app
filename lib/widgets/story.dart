import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils.dart';

class Story extends StatefulWidget {
  const Story({super.key});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(5),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              border:
                  Border.all(color: GlobalColors.secondaryColor, width: 1.5),
              shape: BoxShape.circle,
              image: const DecorationImage(
                  image: AssetImage('assets/dark_back.png'),
                  fit: BoxFit.cover)),
        ),
        Text(
          "Kaweng",
          style: SafeGoogleFont(
            'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            height: 1.5,
            color: Colors.grey.shade700,
          ),
        )
      ],
    );
  }
}
