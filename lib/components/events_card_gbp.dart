import 'package:finance/components/smallbutton.dart';
import 'package:finance/constants/colors.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class GbpEvent extends StatefulWidget {
  const GbpEvent({super.key});

  @override
  State<GbpEvent> createState() => _GbpEventState();
}

class _GbpEventState extends State<GbpEvent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                                    'assets/british-flag-medium.jpg'),
                                fit: BoxFit.fill),
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      SmallButton(
                        textColor: Colors.white,
                        backgroundColor: Colors.blue,
                        height: 15,
                        width: 45,
                        borderColor: Colors.blue,
                        text: "GBP",
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
                        text: "3:00 AM",
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
                      backgroundColor: Colors.blue,
                      height: 15,
                      width: 125,
                      borderColor: Colors.blue,
                      text: "CLAIMANT COUNT CHANGE",
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
                        text: "FORECAST: 12.5K ",
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
                        text: "PREVIOUS: -30.3K",
                        isIcon: false,
                        icon: Icons.menu,
                      ),
                    ],
                  )
                ],
              )
            ],
            // children: [
            //   Row(
            //     children: [
            //       Column(),
            //       Container(
            //         padding: EdgeInsets.all(15),
            //         alignment: Alignment.center,
            //         height: 30,
            //         width: 30,
            //         decoration: const BoxDecoration(
            //             image: DecorationImage(
            //                 image:
            //                     AssetImage('assets/american-flag-medium.jpg'),
            //                 fit: BoxFit.fill),
            //             shape: BoxShape.circle),
            //       ),
            //       const SizedBox(
            //         width: 5,
            //       ),
            //       SmallButton(
            //         textColor: Colors.white,
            //         backgroundColor: Colors.red,
            //         height: 15,
            //         width: 45,
            //         borderColor: Colors.red,
            //         text: "USD",
            //         isIcon: false,
            //         icon: Icons.menu,
            //       ),
            //       const SizedBox(
            //         width: 5,
            //       ),
            //       SmallButton(
            //         textColor: Colors.white,
            //         backgroundColor: Colors.black,
            //         height: 15,
            //         width: 75,
            //         borderColor: Colors.black,
            //         text: "CORE CPI M/M",
            //         isIcon: false,
            //         icon: Icons.menu,
            //       ),
            //     ],
            //   )
            // ],
          ),
        ),
      ),
    );
  }
}
