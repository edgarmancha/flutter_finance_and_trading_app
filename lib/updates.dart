// ignore_for_file: prefer_final_fields

import 'package:finance/constants/colors.dart';
import 'package:finance/utils.dart';
import 'package:finance/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
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

  @override
  void dispose() {
    _goodOutcomePercentageController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _calculateGoodPercentage(List<QueryDocumentSnapshot> updates) {
    int goodCount = updates
        .where((update) =>
            (update.data() as Map<String, dynamic>).containsKey('status') &&
            update['status'] == 'good')
        .length;
    int totalCount = updates.length;
    double percentage = totalCount == 0 ? 0.0 : (goodCount / totalCount) * 100;
    _goodOutcomePercentageController.text = '${percentage.toStringAsFixed(2)}%';
  }

  void _showAddUpdateDialog(BuildContext context) {
    String updateType =
        'Buy'; // Add this new variable to store the selected update type

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Update'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add this new DropdownButtonFormField inside the children of SingleChildScrollView
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton<String>(
                      value: _updateType,
                      items: <String>[
                        'Buy',
                        'Sell',
                        'Sell Stop',
                        'Buy Stop',
                        'Sell Limit',
                        'Buy Limit',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _updateType =
                              newValue!; // Add this line to update the _updateType variable
                        });
                      },
                    );
                  },
                ),

                TextField(
                  controller: _instrumentController,
                  decoration: const InputDecoration(labelText: 'Instrument'),
                ),
                TextField(
                  controller: _stopLossController,
                  decoration: const InputDecoration(labelText: 'Stop Loss'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _takeProfitController,
                  decoration: const InputDecoration(labelText: 'Take Profit'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _entryPriceController,
                  decoration: const InputDecoration(labelText: 'Entry Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(labelText: 'Comment'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _addUpdate,
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _onSwipeGood(DocumentSnapshot update) async {
    await _updatesRef.doc(update.id).update({'status': 'good'});
  }

  void _onSwipeBad(DocumentSnapshot update) async {
    await _updatesRef.doc(update.id).update({'status': 'bad'});
  }

  Widget _buildSwipeableUpdate(BuildContext context, DocumentSnapshot update) {
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _onSwipeGood(update);
          } else {
            _onSwipeBad(update);
          }
        },
        child: Padding(
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
                          // TextField(
                          //   controller: _goodOutcomePercentageController,
                          //   readOnly: true,
                          //   decoration: const InputDecoration(
                          //     labelText: 'Good Outcomes %',
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
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
                                              update['update_type'] ==
                                                  'Buy Stop' ||
                                              update['update_type'] ==
                                                  'Buy Limit')
                                          ? Icons.trending_up
                                          : Icons.trending_down,
                                      color: GlobalColors.whiteAcc
                                          .withOpacity(0.7),
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
                                          borderRadius:
                                              BorderRadius.circular(3),
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
                                                  text:
                                                      '${update['stop_loss']}'));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Copied to clipboard!'),
                                              ));
                                              // Show a snackbar or toast message to indicate that the text has been copied
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 3, 3, 3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    color: Colors.red
                                                        .withOpacity(0.7)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${update['stop_loss']}',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1.5,
                                                          color: GlobalColors
                                                              .whiteAcc,
                                                        )),
                                                    Icon(
                                                      Icons.copy,
                                                      color: GlobalColors
                                                          .whiteAcc
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
                                                content: Text(
                                                    'Copied to clipboard!'),
                                              ));
                                              // Show a snackbar or toast message to indicate that the text has been copied
                                            },
                                            child: Container(
                                                // constraints: const BoxConstraints(
                                                //     minWidth: 80),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 3, 3, 3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    color: GlobalColors
                                                        .thirdColor),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${update['take_profit']}',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1.5,
                                                          color: GlobalColors
                                                              .whiteAcc,
                                                        )),
                                                    Icon(
                                                      Icons.copy,
                                                      color: GlobalColors
                                                          .whiteAcc
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
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 3, 3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
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
                                      color: GlobalColors.whiteAcc
                                          .withOpacity(0.7))),
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
                            // Container(
                            //   height: 30,
                            //   width: 30,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //       border: Border.all(
                            //           width: 1,
                            //           color: GlobalColors.whiteAcc.withOpacity(0.7))),
                            //   child: (update.data() as Map<String, dynamic>?)?.containsKey('status') ==true)
                            //   ? Icon(update['status'] == 'good' ? Icons.check: Icons.close,
                            //   colors: update['status'] =='good' ? Colors.green : Colors.red,)
                            //   :null,

                            // ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

        // ListTile(
        //   title: Text(update['instrument']),
        //   subtitle: Text(
        //       'Stop Loss: ${update['stop_loss']}, Take Profit: ${update['take_profit']}, Entry Price: ${update['entry_price']}, Comment: ${update['comment']}'),
        //   trailing: (update.data() as Map<String, dynamic>?)
        //               ?.containsKey('status') ==
        //           true
        //       ? Icon(
        //           update['status'] == 'good' ? Icons.check : Icons.close,
        //           color: update['status'] == 'good' ? Colors.green : Colors.red,
        //         )
        //       : null,
        // ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.primaryColor,
      appBar: const MyAppBar(
        title: 'Updates',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Win Rate (%)',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            color: GlobalColors.whiteAcc,
                          )),
                      Container(
                          // constraints: const BoxConstraints(minWidth: 150),
                          padding: const EdgeInsets.fromLTRB(8, 3, 3, 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: GlobalColors.thirdColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_goodOutcomePercentageController.text,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                    color: GlobalColors.whiteAcc,
                                  )),
                              Icon(
                                Icons.copy,
                                color: GlobalColors.whiteAcc.withOpacity(0.7),
                                size: 15,
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Buys:',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            color: GlobalColors.whiteAcc,
                          )),
                      Container(
                          // constraints: const BoxConstraints(minWidth: 150),
                          padding: const EdgeInsets.fromLTRB(8, 3, 3, 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: GlobalColors.secondaryColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$numberOfBuys',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                    color: GlobalColors.whiteAcc,
                                  )),
                              Icon(
                                Icons.copy,
                                color: GlobalColors.whiteAcc.withOpacity(0.7),
                                size: 15,
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Sells',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            color: GlobalColors.whiteAcc,
                          )),
                      Container(
                          // constraints: const BoxConstraints(minWidth: 70),
                          padding: const EdgeInsets.fromLTRB(8, 3, 3, 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.red.withOpacity(0.7)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$numberOfSells',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                    color: GlobalColors.whiteAcc,
                                  )),
                              Icon(
                                Icons.copy,
                                color: GlobalColors.whiteAcc.withOpacity(0.7),
                                size: 15,
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _updatesRef
                  .orderBy('timestamp', descending: true)
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

                if (snapshot.hasData) {
                  _calculateGoodPercentage(snapshot.data!.docs);
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot update = snapshot.data!.docs[index];
                    return _buildSwipeableUpdate(context, update);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GlobalColors.primaryColor,
        onPressed: () => _showAddUpdateDialog(context),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
