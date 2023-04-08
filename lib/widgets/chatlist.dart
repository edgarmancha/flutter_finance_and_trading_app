import 'package:finance/utils.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      margin: const EdgeInsets.fromLTRB(00, 0, 20, 20),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Stack(children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(5),
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/dark_back.png'),
                      fit: BoxFit.cover)),
            ),
            Positioned(
              bottom: 5,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(5),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: GlobalColors.primaryColor),
              ),
            ),
          ]),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Analytics Chat Group",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: GlobalColors.secondaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Welcome to the traders hub chat group")
              ],
            ),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            child: Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("00:30"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 15,
                    width: 15,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                    child: const Center(
                        child: Text(
                      "3",
                      style: TextStyle(color: Colors.white),
                    )),
                  )
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
