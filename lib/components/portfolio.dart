import 'package:finance/constants/colors.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class Portfolio extends StatelessWidget {
  const Portfolio({super.key});

  @override
  Widget build(BuildContext context) {
    String walletBalance = '₦ 567,125.21';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
          child: Text(
            'Portfolio',
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
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('Current Wallet Balance (₦)'),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    walletBalance,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  )
                ],
              ),
              const Divider(),
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Deposits (₦)'),
                          Text(
                            '₦ 850,125.09',
                            style: SafeGoogleFont(
                              'Roboto',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Withdrawals (₦)'),
                          Text(
                            '₦ 282,999.88',
                            style: SafeGoogleFont(
                              'Roboto',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('Account Growth (₦)'),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "+ 140,201.23",
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: Colors.green,
                    ),
                  )
                ],
              ),

              // TRYOUTS
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: const [
              //     Text('Account Growth (₦)'),
              //   ],
              // ),
              // const SizedBox(height: 3),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text(
              //       "+ 140,201.23",
              //       style: SafeGoogleFont(
              //         'Roboto',
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //         height: 1.5,
              //         color: Colors.green,
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
