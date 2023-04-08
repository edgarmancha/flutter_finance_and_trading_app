import 'package:flutter/material.dart';

class BottomModal extends StatefulWidget {
  const BottomModal({super.key});

  @override
  State<BottomModal> createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(children: [
        Container(
          height: 100,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/american-flag-medium.jpg'),
                  fit: BoxFit.cover)),
        )
      ]),
    );
  }
}
