import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../utils.dart';
import '../widgets/chatlist.dart';
import '../widgets/story.dart';

class ChatGroup {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final String imageUrl;

  ChatGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.imageUrl,
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

class TradersHub extends StatefulWidget {
  const TradersHub({
    super.key,
  });

  @override
  State<TradersHub> createState() => _TradersHubState();
}

class _TradersHubState extends State<TradersHub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: '',
        centerImage: Image.asset(
          'assets/logo.png',
          height: 55,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Hello Kaweng,",
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // ignore: avoid_unnecessary_containers
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(5),
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/logo.png'))),
              ),
              Expanded(
                child: SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const Story(),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: GlobalColors.secondaryColor,
                                    width: 1.5),
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                    image: AssetImage('assets/dash-back.png'),
                                    fit: BoxFit.cover)),
                          ),
                          Text(
                            "Oswald",
                            style: SafeGoogleFont(
                              'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                              color: Colors.grey.shade700,
                            ),
                          )
                        ],
                      ),
                      const Story(),
                      const Story(),
                      const Story(),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: GlobalColors.secondaryColor,
                                    width: 1.5),
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/british-flag-medium.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                          Text(
                            "David",
                            style: SafeGoogleFont(
                              'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                              color: Colors.grey.shade700,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: GlobalColors.primaryColor,
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
              child: ListView(
              scrollDirection: Axis.vertical,
              children: [
              Column(
                children: const [
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                  ChatList(),
                ],
              ),
            ],
          ))
        ]),
      ),
    );
  }
}
