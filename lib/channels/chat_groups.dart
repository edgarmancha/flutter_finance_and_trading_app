// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, library_prefixes, unused_element

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:finance/channels/chat_page.dart';
import 'package:finance/channels/status.dart';
import 'package:finance/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'package:path/path.dart' as p;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils.dart';
import '../widgets/appbar.dart';

class ChatGroup {
  final String? id;
  final String? name;
  final String? description;
  final String? createdBy;
  final DateTime? createdAt;
  final String? imageUrl;

  ChatGroup({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.createdAt,
    this.imageUrl,
  });

  factory ChatGroup.fromDoc(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    final createdAt = data['created_at'] is String
        ? DateFormat('yyyy/MM/dd').parse(data['created_at'])
        : data['created_at'].toDate();
    return ChatGroup(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      createdBy: data['created_by'],
      createdAt: createdAt,
      imageUrl: data['image_url'] ?? '',
    );
  }
}

class ChatGroupsPage extends StatefulWidget {
  const ChatGroupsPage({Key? key}) : super(key: key);

  @override
  _ChatGroupsPageState createState() => _ChatGroupsPageState();
}

class _ChatGroupsPageState extends State<ChatGroupsPage> {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget is initialized
  }

  Future<void> _createNewChatGroup(
      String chatGroupName, String chatGroupDescription) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not logged in
      return;
    }

    // Create a new chat group in the Firestore 'chat_groups' collection
    await FirebaseFirestore.instance.collection('chat_groups').add({
      'name': chatGroupName,
      'description': chatGroupDescription,
      'created_by': user.uid,
      'created_at': Timestamp.now(),
      'image_url':
          '', // You can add a default image URL or let users upload an image.
    });

    // Optionally, show a confirmation message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New chat group created!')),
    );
  }

  Future<void> _showCreateChatGroupDialog() async {
    TextEditingController _chatGroupNameController = TextEditingController();
    TextEditingController _chatGroupDescriptionController =
        TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a New Chat Group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _chatGroupNameController,
                  decoration: const InputDecoration(
                    labelText: 'Chat Group Name',
                  ),
                ),
                TextField(
                  controller: _chatGroupDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Chat Group Description',
                  ),
                ),
              ],
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
              child: const Text('Create'),
              onPressed: () async {
                await _createNewChatGroup(
                  _chatGroupNameController.text,
                  _chatGroupDescriptionController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    return Scaffold(
      backgroundColor: GlobalColors.primaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showCreateChatGroupDialog();
        },
        backgroundColor: GlobalColors.primaryColor,
        child: const Icon(Icons.add),
      ),
      appBar: const MyAppBar(
        title: "Traders Hub",
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: GlobalColors.primaryColor),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        height: 45,
                        decoration: BoxDecoration(
                            color: GlobalColors.secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.15),
                                  blurRadius: 10,
                                  spreadRadius: .1,
                                  offset: const Offset(2, 2))
                            ]),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.chat_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                'Need Help?',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  color: GlobalColors.whiteAcc,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
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
                            child: Row(
                              children: [
                                //Status Implement listview
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
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
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: GlobalColors.thirdColor),
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
                                                margin:
                                                    const EdgeInsets.all(8.0),
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          status.caption
                                                                      .length >
                                                                  25
                                                              ? '${status.caption.substring(0, 25)}...'
                                                              : status.caption,
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
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
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                              color: GlobalColors
                                                                  .secondaryColor),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          child: Text(
                                                            '${timeago.format(status.timestamp, locale: 'en_short' 'ago', allowFromNow: false)} ',
                                                            style:
                                                                SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height: 1.5,
                                                              color:
                                                                  GlobalColors
                                                                      .whiteAcc,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
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
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1,
                                    color: Colors.white.withOpacity(0.8))),
                            height: 35,
                            width: 35,
                            child: InkWell(
                              onTap: _addStatus,
                              child: Icon(
                                Icons.add,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Active Channels",
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
                  height: 20,
                ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   decoration: BoxDecoration(
                //       color: Colors.black,
                //       borderRadius: BorderRadius.circular(6),
                //       boxShadow: [
                //         BoxShadow(
                //             color: Colors.white.withOpacity(0.1),
                //             blurRadius: 5,
                //             spreadRadius: .1,
                //             offset: const Offset(1, 1))
                //       ]),
                //   child: TextField(
                //     controller: _searchController,
                //     decoration: InputDecoration(
                //       hintText: "Search",
                //       hintStyle: SafeGoogleFont(
                //         'Poppins',
                //         fontSize: 16,
                //         fontWeight: FontWeight.normal,
                //         height: 1.5,
                //         color: GlobalColors.whiteAcc,
                //       ),
                //       border: InputBorder.none,
                //       prefixIcon: Icon(
                //         Icons.search,
                //         color: GlobalColors.whiteAcc,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: GlobalColors.primaryColor,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chat_groups')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final chatGroups = snapshot.data!.docs
                      .map((doc) => ChatGroup.fromDoc(doc))
                      .toList();

                  return ListView.builder(
                    itemCount: chatGroups.length,
                    itemBuilder: (context, index) {
                      final chatGroup = chatGroups[index];

                      return Container(
                        width: double.infinity,
                        color: GlobalColors.primaryColor,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print(
                                              'Tapped on group: ${chatGroup.name}');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                  chatGroupId: chatGroup.id!,
                                                  chatGroupName:
                                                      chatGroup.name!,
                                                  chatGroupPhotoUrl:
                                                      chatGroup.imageUrl!,
                                                  chatGroupDescription:
                                                      chatGroup.description!),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          margin: const EdgeInsets.fromLTRB(
                                              00, 0, 20, 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              Stack(children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: GlobalColors
                                                              .whiteAcc
                                                              .withOpacity(
                                                                  0.3)),
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              chatGroup
                                                                  .imageUrl!),
                                                          fit: BoxFit.cover)),
                                                ),
                                                Positioned(
                                                  bottom: 5,
                                                  right: 0,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    height: 10,
                                                    width: 10,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: GlobalColors
                                                            .thirdColor),
                                                  ),
                                                ),
                                              ]),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        chatGroup.name!,
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1.5,
                                                          color: GlobalColors
                                                              .whiteAcc
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            chatGroup
                                                                .description!,
                                                            style:
                                                                SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height: 1.5,
                                                              color: GlobalColors
                                                                  .whiteAcc
                                                                  .withOpacity(
                                                                      0.6),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Row(children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      //Time of the last message in group
                                                      Text(
                                                        "00:30",
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1.5,
                                                          color: GlobalColors
                                                              .whiteAcc
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 15,
                                                        width: 15,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: GlobalColors
                                                                .secondaryColor),
                                                        child: const Center(
                                                            //Number of messages that haven't been read
                                                            child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    ],
                                                  )
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Status {
  final String id;
  final String imageUrl;
  final String caption;
  final DateTime timestamp;

  Status({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.timestamp,
  });

  factory Status.fromDoc(DocumentSnapshot doc) {
    return Status(
      id: doc.id,
      imageUrl: doc['imageUrl'],
      caption: doc['caption'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }
}


// GestureDetector(
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StatusDetailsPage(
//           status: status,
//         ),
//       ),
//     );
//   },
//   child: // Status container
// ),