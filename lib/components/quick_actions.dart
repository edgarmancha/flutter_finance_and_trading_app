import 'package:finance/channels/chat_groups.dart';
import 'package:finance/channels/status.dart';
import 'package:finance/constants/colors.dart';
import 'package:finance/dump.dart';
import 'package:finance/economic_events.dart';
import 'package:finance/forex_symbols.dart';
import 'package:finance/stories.dart';
import 'package:finance/widgets/forexdata.dart';
import 'package:flutter/material.dart';

import '../utils.dart';
import 'buttons_widget.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
          child: Text(
            'Quick Actions',
            style: SafeGoogleFont(
              'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: GlobalColors.secondaryColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GlobalColors.boxColor),
          margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (EconomicCalendarPage())),
                  );
                },
                child: ButtonWidget(
                  textColor: Colors.white,
                  backgroundColor: GlobalColors.secondaryColor,
                  height: 30,
                  width: 30,
                  borderColor: GlobalColors.secondaryColor,
                  text: "Send Money",
                  isIcon: true,
                  icon: Icons.newspaper,
                  description: "News",
                  // icon: icon)
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (ForexSymbolsPage())),
                  );
                },
                child: ButtonWidget(
                  textColor: Colors.white,
                  backgroundColor: GlobalColors.secondaryColor,
                  height: 30,
                  width: 30,
                  borderColor: GlobalColors.secondaryColor,
                  text: "Cards",
                  isIcon: true,
                  icon: Icons.chat,
                  description: "Channels",

                  // icon: icon)
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (const ChatGroupsPage())),
                  );
                },
                child: ButtonWidget(
                  textColor: Colors.white,
                  backgroundColor: GlobalColors.secondaryColor,
                  height: 30,
                  width: 30,
                  borderColor: GlobalColors.secondaryColor,
                  text: "Airtime/Data",
                  isIcon: true,
                  icon: Icons.bar_chart,
                  description: "Channels",

                  // icon: icon)
                ),
              ),
              InkWell(
                onTap: () {},
                child: ButtonWidget(
                  textColor: Colors.white,
                  backgroundColor: GlobalColors.secondaryColor,
                  height: 30,
                  width: 30,
                  borderColor: GlobalColors.secondaryColor,
                  text: "Bills",
                  isIcon: true,
                  icon: Icons.login,
                  description: "Login",

                  // icon: icon)
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// Padding(
//               padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(
//                     maxHeight: 60, maxWidth: double.infinity),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ButtonWidget(
//                       textColor: Colors.white,
//                       backgroundColor: GlobalColors.primaryColor,
//                       height: 60,
//                       width: 160,
//                       borderColor: Colors.white,
//                       text: "Deposit",
//                       isIcon: false,
//                       icon: Icons.send,
//                       // icon: icon)
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     ButtonWidget(
//                       textColor: Colors.white,
//                       backgroundColor: GlobalColors.secondaryColor,
//                       height: 60,
//                       width: 160,
//                       borderColor: Colors.white,
//                       text: "Withdraw",
//                       isIcon: false,
//                       icon: Icons.send,
//                       // icon: icon)
//                     )
//                   ],
//                 ),
//               ),
//             ),
