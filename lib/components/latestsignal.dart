// ignore_for_file: prefer_final_fields, avoid_unnecessary_containers

import 'package:finance/constants/colors.dart';
import 'package:finance/utils.dart';
import 'package:finance/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class LatestSignal extends StatefulWidget {
  @override
  _LatestSignalState createState() => _LatestSignalState();
}

class _LatestSignalState extends State<LatestSignal> {
  TextEditingController _instrumentController = TextEditingController();
  TextEditingController _stopLossController = TextEditingController();
  TextEditingController _takeProfitController = TextEditingController();
  TextEditingController _entryPriceController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  final TextEditingController _goodOutcomePercentageController =
      TextEditingController();
  int numberOfBuys = 0;
  int numberOfSells = 0;

  String _updateType = 'Buy';

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  CollectionReference _updatesRef =
      FirebaseFirestore.instance.collection('updates');

  Future<void> _addUpdate() async {
    await _updatesRef.add({
      'instrument': _instrumentController.text,
      'stop_loss': double.parse(_stopLossController.text),
      'take_profit': double.parse(_takeProfitController.text),
      'entry_price': double.parse(_entryPriceController.text),
      'comment': _commentController.text,
      'update_type': _updateType, // Add this line
      'timestamp': FieldValue.serverTimestamp(),
    });

    _instrumentController.clear();
    _stopLossController.clear();
    _takeProfitController.clear();
    _entryPriceController.clear();
    _commentController.clear();

    Navigator.of(context).pop();
  }

  Widget _buildSwipeableUpdate(BuildContext context, DocumentSnapshot update) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTimestamp(update['timestamp']),
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              height: 1.5,
              color: GlobalColors.whiteAcc,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: GlobalColors.whiteAcc.withOpacity(0.2),
                borderRadius: BorderRadius.circular(7)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 3, 3, 3),
                            decoration: BoxDecoration(
                              color: (update['update_type'] == 'Buy' ||
                                      update['update_type'] == 'Buy Stop' ||
                                      update['update_type'] == 'Buy Limit')
                                  ? Colors.green
                                  : Colors.red.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              children: [
                                Text('${update['update_type']}',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      color: GlobalColors.whiteAcc
                                          .withOpacity(0.7),
                                    )),
                                const SizedBox(width: 4),
                                Icon(
                                  (update['update_type'] == 'Buy' ||
                                          update['update_type'] == 'Buy Stop' ||
                                          update['update_type'] == 'Buy Limit')
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  color: GlobalColors.whiteAcc.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            update['instrument'].toUpperCase(),
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              color: GlobalColors.whiteAcc,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Entry Price:',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                    color: GlobalColors.whiteAcc,
                                  )),
                              Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 80),
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 3, 3, 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: GlobalColors.secondaryColor),
                                  child: Text('${update['entry_price']}',
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                        color: GlobalColors.whiteAcc,
                                      ))),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: GlobalColors.whiteAcc.withOpacity(0.6),
                      )
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Stop Loss:',
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            height: 1.5,
                                            color: GlobalColors.whiteAcc,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: '${update['stop_loss']}'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Copied to clipboard!'),
                                          ));
                                          // Show a snackbar or toast message to indicate that the text has been copied
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 3, 3, 3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: Colors.red
                                                    .withOpacity(0.7)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('${update['stop_loss']}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1.5,
                                                      color:
                                                          GlobalColors.whiteAcc,
                                                    )),
                                                Icon(
                                                  Icons.copy,
                                                  color: GlobalColors.whiteAcc
                                                      .withOpacity(0.7),
                                                  size: 15,
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Take Profit:',
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            height: 1.5,
                                            color: GlobalColors.whiteAcc,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text:
                                                  '${update['take_profit']}'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Copied to clipboard!'),
                                          ));
                                          // Show a snackbar or toast message to indicate that the text has been copied
                                        },
                                        child: Container(
                                            // constraints: const BoxConstraints(
                                            //     minWidth: 80),
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 3, 3, 3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: GlobalColors.thirdColor),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('${update['take_profit']}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1.5,
                                                      color:
                                                          GlobalColors.whiteAcc,
                                                    )),
                                                Icon(
                                                  Icons.copy,
                                                  color: GlobalColors.whiteAcc
                                                      .withOpacity(0.7),
                                                  size: 15,
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Comment:',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                    color: GlobalColors.whiteAcc,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: '${update['comment']}'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Copied to clipboard!'),
                                  ));
                                  // Show a snackbar or toast message to indicate that the text has been copied
                                },
                                child: Container(
                                    constraints:
                                        const BoxConstraints(minWidth: 150),
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 3, 3, 3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: GlobalColors.secondaryColor),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${update['comment']}',
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              height: 1.5,
                                              color: GlobalColors.whiteAcc,
                                            )),
                                        Icon(
                                          Icons.copy,
                                          color: GlobalColors.whiteAcc
                                              .withOpacity(0.7),
                                          size: 15,
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Outcome',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                              color: GlobalColors.whiteAcc,
                            )),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      GlobalColors.whiteAcc.withOpacity(0.7))),
                          child: (update.data() as Map<String, dynamic>?)
                                      ?.containsKey('status') ==
                                  true
                              ? Icon(
                                  update['status'] == 'good'
                                      ? Icons.check
                                      : Icons.close,
                                  color: update['status'] == 'good'
                                      ? Colors.green
                                      : Colors.red,
                                )
                              : null,
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: _updatesRef
                .orderBy('timestamp', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              numberOfBuys = 0;
              numberOfSells = 0;

              snapshot.data!.docs.forEach((update) {
                if (update['update_type'] == 'Buy' ||
                    update['update_type'] == 'Buy Stop' ||
                    update['update_type'] == 'Buy Limit') {
                  numberOfBuys++;
                } else if (update['update_type'] == 'Sell' ||
                    update['update_type'] == 'Sell Stop' ||
                    update['update_type'] == 'Sell Limit') {
                  numberOfSells++;
                }
              });

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final update = snapshot.data?.docs[index];
                  if (update == null) {
                    return SizedBox.shrink();
                  }
                  return _buildSwipeableUpdate(context, update);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
