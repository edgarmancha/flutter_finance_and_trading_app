// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../utils.dart';
import 'chat_details.dart';

class ChatPage extends StatefulWidget {
  final String chatGroupId;
  final String chatGroupName;
  final String chatGroupPhotoUrl;
  final String chatGroupDescription;

  const ChatPage(
      {required this.chatGroupId,
      required this.chatGroupName,
      required this.chatGroupDescription,
      required this.chatGroupPhotoUrl});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  FocusNode _messageFocusNode = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ScrollController _scrollController = ScrollController();

  CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('chat_groups');
  String? _customName;
  bool _showEmojiPicker = false;
  RegExp _urlPattern = RegExp(
      r'(https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*))');

  @override
  void initState() {
    super.initState();
    _retrieveCustomName();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  Future<void> sendNotificationToGroupMembers(
    List<Map<String, dynamic>> members,
    Map<String, dynamic> message,
    String serverKey,
  ) async {
    // Prepare the notification payload
    final payload = {
      'notification': {
        'title': '${message['senderName']} sent a new message',
        'body': message['text'],
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    // Send the notification to all group members except the sender
    for (final member in members) {
      if (member['uid'] != message['senderId']) {
        final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: json.encode({...payload, 'to': member['token']}),
          headers: headers,
        );

        if (response.statusCode != 200) {
          print('Failed to send notification: ${response.body}');
        }
      }
    }
  }

  Future<void> _sendNotificationToGroupMembers(
      Map<String, dynamic> message, String chatGroupId) async {
    final groupDoc = await FirebaseFirestore.instance
        .collection('chat_groups')
        .doc(chatGroupId)
        .get();
    final groupData = groupDoc.data() as Map<String, dynamic>;
    final members =
        (groupData['members'] as List<dynamic>).cast<Map<String, dynamic>>();

    final tokens = members
        .where((member) => member['uid'] != message['senderId'])
        .map((member) => member['token'])
        .toList();

    // Replace 'YOUR_SERVER_KEY' with your actual Firebase Cloud Messaging server key
    const String serverKey =
        'AAAAm-gujyE:APA91bEqLvu3NF7-HLpbuUhxhNz-NS84RocY5gTpWsO0tImmIbgafiS0F7PElcPcUWc1vz-pA2aaSS_UrhSrZ_pcyw0HWlZSDQ9Gd__GMokEHsVphP6xVekoc9OsJ1FM9NOJ_C0GkJKf';

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: json.encode({
        'registration_ids': tokens,
        'notification': {
          'title': 'New message in ${groupData['name']}',
          'body': '${message['senderName']}: ${message['text']}',
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'CHAT_MESSAGE',
          'chatGroupId': chatGroupId,
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Notification failed to send: ${response.body}');
    }
  }

  Future<void> _retrieveCustomName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _customName = prefs.getString('username');
  }

  bool _shouldShowJoinPrompt(List<Map<String, dynamic>> members) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return false;
    }
    if (_customName == null) {
      return true;
    }
    final isMember = members.any((member) => member['uid'] == currentUser.uid);
    if (isMember) {
      return false;
    }
    _firestore.collection('chat_groups').doc(widget.chatGroupId).update({
      'members': FieldValue.arrayUnion([
        {
          'uid': currentUser.uid,
          'name': _customName,
        },
      ]),
    });
    return false;
  }

  AlertDialog _buildJoinPrompt() {
    TextEditingController _nameController = TextEditingController();

    return AlertDialog(
      title: const Text('Join Chat'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter your name to join the chat:'),
          TextField(
            controller: _nameController,
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final enteredName = _nameController.text.trim();
            if (enteredName.isEmpty) {
              return;
            }

            setState(() {
              _customName = enteredName;
            });

            await _saveUsernameToSharedPreferences(enteredName);

            final currentUser = _auth.currentUser;
            await _firestore
                .collection('chat_groups')
                .doc(widget.chatGroupId)
                .update({
              'members': FieldValue.arrayUnion([
                {
                  'uid': currentUser!.uid,
                  'name': enteredName,
                },
              ]),
            });

            Navigator.pop(context);
          },
          child: const Text('Join'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlobalColors.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.chatGroupName,
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.5,
                color: GlobalColors.whiteAcc.withOpacity(0.8),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              StreamBuilder<DocumentSnapshot>(
                stream: _messagesCollection.doc(widget.chatGroupId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const SizedBox.shrink();
                  }

                  final data = snapshot.data!.data() as Map<String?, dynamic>;
                  final members = (data['members'] as List<dynamic>)
                      .cast<Map<String, dynamic>>();

                  return Text(
                    '${members.length} members',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: GlobalColors.whiteAcc.withOpacity(0.8),
                    ),
                  );
                },
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 6,
                  width: 6,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 126, 189, 152)),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  "Active",
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: GlobalColors.whiteAcc.withOpacity(0.8),
                  ),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChatGroupDetails()),
              );
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: GlobalColors.primaryColor),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: GlobalColors.whiteAcc.withOpacity(0.03)),
                      child: Text(
                        widget.chatGroupDescription,
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                          color: GlobalColors.whiteAcc.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _messagesCollection.doc(widget.chatGroupId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const SizedBox.shrink();
                  }

                  final data = snapshot.data!.data() as Map<String?, dynamic>;
                  final messages = (data['messages'] as List<dynamic>? ?? [])
                      .cast<Map<String, dynamic>>();
                  print("Messages: $messages");

                  final members = (data['members'] as List<dynamic>)
                      .cast<Map<String, dynamic>>();

                  if (_shouldShowJoinPrompt(members)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (_) => _buildJoinPrompt(),
                      );
                    });
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    reverse: false,
                    itemCount: messages.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final bool isOwnMessage =
                          message['senderId'] == _auth.currentUser?.uid;
                      final bool isNewDay = index == 0 ||
                          !_isSameDay(messages[index - 1]['timestamp'],
                              messages[index]['timestamp']);

                      return Column(
                        crossAxisAlignment: isOwnMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (isNewDay)
                            _buildDateSeparator(messages[index]['timestamp']),
                          _buildMessageBubble(message, isOwnMessage),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            if (_showEmojiPicker)
              Container(
                height:
                    250, // You can adjust the height value according to your needs
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text += emoji.emoji;
                    });
                    _messageFocusNode.requestFocus();
                  },
                ),
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showEmojiPicker = !_showEmojiPicker;
                      });
                    },
                    icon: Icon(
                      Icons.insert_emoticon_outlined,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 95, 95, 100),
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            color: GlobalColors.whiteAcc.withOpacity(0.8),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Container(
                            margin: EdgeInsets.all(0.5),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: GlobalColors.thirdColor,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.send_outlined),
                              color: Colors.white,
                              onPressed: () async {
                                final currentUser = _auth.currentUser;
                                final timestamp = DateTime.now();

                                final message = {
                                  'senderId': currentUser!.uid,
                                  'senderName': _customName,
                                  'senderPhotoUrl': currentUser.photoURL,
                                  'text': _messageController.text,
                                  'timestamp': Timestamp.fromDate(timestamp),
                                  'thumbsUp': 0,
                                  'thumbsDown': 0,
                                };

                                await FirebaseFirestore.instance
                                    .collection('chat_groups')
                                    .doc(widget.chatGroupId)
                                    .update({
                                  'messages': FieldValue.arrayUnion([message])
                                });

                                // Send a notification to all group members except the sender
                                _sendNotificationToGroupMembers(
                                    message, widget.chatGroupId);

                                _messageController.clear();
                                _messageFocusNode.requestFocus();

                                // Add this line to scroll to the bottom
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              },
                            ),
                          ),
                        ),
                        focusNode: _messageFocusNode,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(Timestamp timestamp) {
    final date = timestamp.toDate();
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormatter.format(date);

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        formattedDate,
        style: SafeGoogleFont(
          'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          height: 1.5,
          color: GlobalColors.whiteAcc.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isOwnMessage) {
    final messageBgColor = isOwnMessage
        ? GlobalColors.thirdColor
        : const Color.fromARGB(255, 95, 95, 100);
    final textColor = isOwnMessage ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment:
            isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message['senderName'] as String,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: GlobalColors.whiteAcc.withOpacity(0.8),
            ),
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minWidth: MediaQuery.of(context).size.width * 0.3),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: messageBgColor,
              borderRadius: BorderRadius.only(
                topLeft: isOwnMessage
                    ? const Radius.circular(10)
                    : const Radius.circular(0),
                topRight: isOwnMessage
                    ? const Radius.circular(10)
                    : const Radius.circular(10),
                bottomRight: isOwnMessage
                    ? const Radius.circular(0)
                    : const Radius.circular(10),
                bottomLeft: isOwnMessage
                    ? const Radius.circular(10)
                    : const Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['text'] as String,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                    color: GlobalColors.whiteAcc.withOpacity(0.8),
                  ),
                ),
                // Add reaction counts below the message text

                Padding(
                    padding: isOwnMessage
                        ? const EdgeInsets.only(top: 4)
                        : const EdgeInsets.only(right: 4),
                    child: Text(
                      DateFormat('HH:mm')
                          .format((message['timestamp'] as Timestamp).toDate()),
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                        color: GlobalColors.whiteAcc.withOpacity(0.8),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildLinkedText(String text, Color textColor) {
    final words = text.split(' ');
    List<TextSpan> textSpans = [];
    for (final word in words) {
      if (_urlPattern.hasMatch(word)) {
        textSpans.add(
          TextSpan(
            text: word + ' ',
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (await canLaunch(word)) {
                  await launch(word);
                } else {
                  print('Could not launch $word');
                }
              },
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: TextStyle(color: textColor),
          ),
        );
      }
    }

    return TextSpan(children: textSpans);
  }

  bool _isSameDay(Timestamp ts1, Timestamp ts2) {
    final date1 = ts1.toDate();
    final date2 = ts2.toDate();
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _saveUsernameToSharedPreferences(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }
}
