import 'package:finance/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_groups.dart';

class StatusDetailsPage extends StatelessWidget {
  final Status status;

  const StatusDetailsPage({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 500),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  child: Image.network(
                    status.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                    child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.black),
                  child: Text(
                    "Traders Hub",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                      color: GlobalColors.whiteAcc,
                    ),
                  ),
                )),
                Positioned(
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: GlobalColors.thirdColor),
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      DateFormat.yMd().add_jm().format(status.timestamp),
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: GlobalColors.whiteAcc,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Positioned(
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: GlobalColors.whiteAcc.withOpacity(0.2)),
              padding: const EdgeInsets.all(8),
              child: Text(
                status.caption,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                  color: GlobalColors.whiteAcc,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// appBar: AppBar(
//         title: Text(status.caption),
//       ),        child: Image.network(status.imageUrl),
