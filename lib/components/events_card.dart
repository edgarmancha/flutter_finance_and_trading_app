import 'package:finance/components/event_modal.dart';
import 'package:finance/components/smallbutton.dart';
import 'package:finance/constants/colors.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class EventsCard extends StatefulWidget {
  const EventsCard({super.key});

  @override
  State<EventsCard> createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          showBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: ((context) {
                return const BottomModal();
              }));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GlobalColors.boxColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/american-flag-medium.jpg'),
                                  fit: BoxFit.fill),
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        SmallButton(
                          textColor: Colors.white,
                          backgroundColor: Colors.red,
                          height: 15,
                          width: 45,
                          borderColor: Colors.red,
                          text: "USD",
                          isIcon: false,
                          icon: Icons.menu,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        SmallButton(
                          textColor: Colors.white,
                          backgroundColor: Colors.black,
                          height: 15,
                          width: 45,
                          borderColor: Colors.black,
                          text: "3:00 PM",
                          isIcon: false,
                          icon: Icons.menu,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      SmallButton(
                        textColor: Colors.white,
                        backgroundColor: Colors.red,
                        height: 15,
                        width: 125,
                        borderColor: Colors.red,
                        text: "CORE CPI M/M",
                        isIcon: false,
                        icon: Icons.menu,
                      ),
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: 125,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: GlobalColors.secondaryColor),
                      child: Text(
                        "Change in the price of goods and services purchased by consumers...",
                        style: SafeGoogleFont(
                          'lato',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SmallButton(
                          textColor: Colors.white,
                          backgroundColor: Colors.lightGreen,
                          height: 15,
                          width: 100,
                          borderColor: Colors.lightGreen,
                          text: "ACTUAL: __",
                          isIcon: false,
                          icon: Icons.menu,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SmallButton(
                          textColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          height: 15,
                          width: 100,
                          borderColor: Colors.indigo,
                          text: "FORECAST: 0.4% ",
                          isIcon: false,
                          icon: Icons.menu,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SmallButton(
                          textColor: Colors.white,
                          backgroundColor: Colors.red,
                          height: 15,
                          width: 100,
                          borderColor: Colors.red,
                          text: "PREVIOUS: 0.4%",
                          isIcon: false,
                          icon: Icons.menu,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
