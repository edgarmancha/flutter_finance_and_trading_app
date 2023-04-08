// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, library_prefixes, unused_element

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:finance/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'package:path/path.dart' as p;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../channels/chat_groups.dart';
import '../channels/status.dart';
import '../utils.dart';

class LatestUpdates extends StatefulWidget {
  const LatestUpdates({Key? key}) : super(key: key);

  @override
  _LatestUpdatesState createState() => _LatestUpdatesState();
}

class _LatestUpdatesState extends State<LatestUpdates> {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget is initialized
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final firstName = snapshot.data()!['firstName'];
        final lastName = snapshot.data()!['lastName'];

        if (firstName != null && lastName != null) {
          setState(() {});
        }
      }
    }
  }

  Future<void> _addStatusToFirestore(String imageUrl, String caption) async {
    try {
      await FirebaseFirestore.instance.collection('statuses').add({
        'imageUrl': imageUrl,
        'caption': caption,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addStatus() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      String? caption = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a caption'),
            content: TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                hintText: 'Enter a caption',
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(_captionController.text);
                },
              ),
            ],
          );
        },
      );

      if (caption != null) {
        // Upload the image file to Firebase Storage
        String imagePath = 'statuses/${Path.basename(imageFile.path)}';
        File image = File(imageFile.path);
        final ref = FirebaseStorage.instance.ref().child(imagePath);
        final uploadTask = ref.putFile(image);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();

        FirebaseFirestore.instance.collection('statuses').add({
          'userId': currentUserId, // Use the current user ID
          'imageUrl': imageUrl,
          'caption': caption,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  Future<String?> _uploadImage(File file) async {
    try {
      final String fileName = p.basename(file.path);
      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('statuses/$fileName');
      final UploadTask uploadTask = firebaseStorageRef.putFile(file);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _saveStatusToFirestore(String imageUrl, String caption) async {
    await FirebaseFirestore.instance.collection('statuses').add({
      'userId': currentUserId, // Use the current user ID
      'imageUrl': imageUrl,
      'caption': caption,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _filterChatGroups() {
    // Implement the filtering logic here
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: GlobalColors.primaryColor),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Latest Updates",
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: GlobalColors.whiteAcc,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              // width: double.infinity,
                              height: 100,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('statuses')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: LinearProgressIndicator(),
                                    );
                                  }

                                  final statuses = snapshot.data!.docs
                                      .map((doc) => Status.fromDoc(doc))
                                      .where((status) =>
                                          DateTime.now()
                                              .difference(status.timestamp)
                                              .inHours <
                                          24)
                                      .toList();

                                  // Sort the statuses in descending order by timestamp
                                  statuses.sort((a, b) =>
                                      b.timestamp.compareTo(a.timestamp));

                                  if (statuses.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'No updates to show',
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          height: 1.5,
                                          color: GlobalColors.whiteAcc,
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: statuses.length,
                                    itemBuilder: (context, index) {
                                      final status = statuses[index];
                                      // Build the status UI here
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: GlobalColors.whiteAcc
                                                .withOpacity(0.1)),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StatusDetailsPage(
                                                  status: status,
                                                ),
                                              ),
                                            );
                                            // Handle onTap event for the status here
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    status.imageUrl,
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      status.caption.length > 25
                                                          ? '${status.caption.substring(0, 25)}...'
                                                          : status.caption,
                                                      style: SafeGoogleFont(
                                                        'Poppins',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        height: 1.5,
                                                        color: GlobalColors
                                                            .whiteAcc,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          color: GlobalColors
                                                              .whiteAcc
                                                              .withOpacity(
                                                                  0.3)),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: Text(
                                                        '${timeago.format(status.timestamp, locale: 'en_short' 'ago', allowFromNow: false)} ',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1.5,
                                                          color: GlobalColors
                                                              .whiteAcc,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
